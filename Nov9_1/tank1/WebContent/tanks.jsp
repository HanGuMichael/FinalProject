<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
    <title>Tanks</title>
    <meta charset="utf-8">
    <script src="//cdn.jsdelivr.net/phaser/2.2.2/phaser.min.js"></script>
</head>
<body>

    <div id="game"></div>
    
    
    <% String room = (String)request.getAttribute("room"); %>
	<% String position = (String)request.getAttribute("position"); %>
    <script type="text/javascript">
    var room = "<%= room%>"; 
    var position = "<%= position%>"; 
    console.log(position);
    
    
    console.log(room);
    connectToServer();
    var game = new Phaser.Game(850, 540, Phaser.CANVAS, 'game');
    var TankGame = function (game) {
        this.tank = null;
        this.turret = null;
        this.flame = null;
        this.bullet = null;
        this.background = null;
        this.targets = null;
        this.power = 300;
        this.powerText = null;
        this.cursors = null;
        this.fireButton = null;
    };
    
    
    
    TankGame.prototype = {
        init: function () {
            //this.game.renderer.renderSession.roundPixels = true;
            this.game.world.setBounds(0, 0, 992, 480);
            this.physics.startSystem(Phaser.Physics.ARCADE);
            this.physics.arcade.gravity.y = 200;
        },
        preload: function () {
            this.load.image('tank', 'assets/tank.png');
            this.load.image('turret', 'assets/turret.png');
            this.load.image('bullet', 'assets/bullet.png');
            this.load.image('background', 'assets/background.png');
            //this.load.image('background', 'assets/background.jpg');
            this.load.image('flame', 'assets/flame.png');
            this.load.image('target', 'assets/target.png');
            this.load.image('land', 'assets/land.png');
        },
        create: function () {
        	
        	
            this.background = this.add.sprite(0, 0, 'background');
            this.targets = this.add.group(this.game.world, 'targets', false, true, Phaser.Physics.ARCADE);
            this.targets.create(300, 320, 'target');
            this.targets.create(500, 250, 'target');
            this.targets.create(700, 320, 'target');
            //this.targets.create(900, 320, 'target');
            this.targets.setAll('body.allowGravity', false);
            this.bullet = this.add.sprite(0, 0, 'bullet');
            this.bullet.exists = false;
            this.physics.arcade.enable(this.bullet);
            this.tank = this.add.sprite(24, 383, 'tank');
            this.turret = this.add.sprite(this.tank.x + 30, this.tank.y + 14, 'turret');
            this.flame = this.add.sprite(0, 0, 'flame');
            this.flame.anchor.set(0.5);
            this.flame.visible = false;
            this.power = 300;
            this.powerText = this.add.text(8, 8, 'Power: 300', { font: "18px Arial", fill: "#ffffff" });
            this.powerText.setShadow(1, 1, 'rgba(0, 0, 0, 0.8)', 1);
            this.powerText.fixedToCamera = true;
            this.cursors = this.input.keyboard.createCursorKeys();
    
            this.fireButton = this.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR);
            this.fireButton.onDown.add(this.fire, this);
            
            this.land = this.add.bitmapData(992, 480);
            this.land.draw('land');
            this.land.update();
            this.land.addToWorld();
            
       
            this.emitter = this.add.emitter(0, 0, 30);
            this.emitter.makeParticles('flame');
            this.emitter.setXSpeed(-120, 120);
            this.emitter.setYSpeed(-100, -200);
            this.emitter.setRotation();
            
            
        },
        
        bulletVsLand: function () {

            //  Simple bounds check
            if (this.bullet.x < 0 || this.bullet.x > this.game.world.width || this.bullet.y > this.game.height)
            {
                this.removeBullet();
                return;
            }

            var x = Math.floor(this.bullet.x);
            var y = Math.floor(this.bullet.y);
            var rgba = this.land.getPixel(x, y);

            if (rgba.a > 0)
            {
                this.land.blendDestinationOut();
                this.land.circle(x, y, 16, 'rgba(0, 0, 0, 255');
                this.land.blendReset();
                this.land.update();

                //  If you like you could combine the above 4 lines:
                // this.land.blendDestinationOut().circle(x, y, 16, 'rgba(0, 0, 0, 255').blendReset().update();

                this.removeBullet();
            }

        },
        fire: function () {
            if (this.bullet.exists)
            {
                return;
            }
            this.bullet.reset(this.turret.x, this.turret.y);
            var p = new Phaser.Point(this.turret.x, this.turret.y);
            p.rotate(p.x, p.y, this.turret.rotation, false, 34);
            this.flame.x = p.x;
            this.flame.y = p.y;
            this.flame.alpha = 1;
            this.flame.visible = true;
            this.add.tween(this.flame).to( { alpha: 0 }, 100, "Linear", true);
            //this.camera.follow(this.bullet);
            this.physics.arcade.velocityFromRotation(this.turret.rotation, this.power, this.bullet.body.velocity);
            sendMessage("fire",0, "client 1");
        },
        hitTarget: function (bullet, target) {
        	this.emitter.at(target);
            this.emitter.explode(2000, 10);

            target.kill();

            this.removeBullet(true);
        },
        
        
        removeBullet: function () {
        	console.log(this.power);
            this.bullet.kill();
            this.camera.follow();
            this.add.tween(this.camera).to( { x: 0 }, 1000, "Quint", true, 1000);
        },
        update: function () {
        	//console.log(this.power);
            //  If the bullet is in flight we don't let them control anything
            if (this.bullet.exists)
            {
                if (this.bullet.y > 420)
                {
                    //  Simple check to see if it's fallen too low
                    this.removeBullet();
                }
                else
                {
                    //  Bullet vs. the Targets
                    this.physics.arcade.overlap(this.bullet, this.targets, this.hitTarget, null, this);
                    //  Bullet vs. the land
                    this.bulletVsLand();
                }
            }
             else
            {
                if (this.cursors.left.isDown && this.power > 100)
                {
                    this.power -= 2;
                    sendMessage("power",this.power, "client 1");
                }
                else if (this.cursors.right.isDown && this.power < 600)
                {
                    this.power += 2;
                    sendMessage("power",this.power, "client 1");
                }
                if (this.cursors.up.isDown && this.turret.angle > -90)
                {
                    this.turret.angle--;
                    sendMessage("angle",this.turret.angle, "client 1");
                }
                else if (this.cursors.down.isDown && this.turret.angle < 0)
                {
                    this.turret.angle++;
                    sendMessage("angle",this.turret.angle, "client 1");
                }
                //  Update the text
                this.powerText.text = 'Power: ' + this.power;
            }
        }
        
        
        
    };
    game.state.add('Game', TankGame, true);
    
    
    
    //console.log(request.getParameter("room"));
    
    
    var socket;
    	function connectToServer() {
    		socket = new WebSocket("ws://localhost:8080/tank1/ws");
    		socket.onopen = function(event) {
    			console.log("Connected");
    			//document.getElementById("mychat").innerHTML += "Connected!";
    		}
    		socket.onmessage = function(event) {
    			//document.getElementById("mychat").innerHTML += event.data + "<br />";
    			var d = event.data;
    			//console.log(d);
    			var obj = JSON.parse(d);
    			if(obj.field=="power"){
    				game.state.states['Game'].power = obj.value;
                }else if(obj.field=="angle"){
                	game.state.states['Game'].turret.angle = obj.value;
                }else{
                	
                	game.state.states['Game'].bullet.reset(game.state.states['Game'].turret.x, game.state.states['Game'].turret.y);
                    var p = new Phaser.Point(game.state.states['Game'].turret.x, game.state.states['Game'].turret.y);
                    p.rotate(p.x, p.y, game.state.states['Game'].turret.rotation, false, 34);
                    game.state.states['Game'].flame.x = p.x;
                    game.state.states['Game'].flame.y = p.y;
                    game.state.states['Game'].flame.alpha = 1;
                    game.state.states['Game'].flame.visible = true;
                    game.state.states['Game'].add.tween(game.state.states['Game'].flame).to( { alpha: 0 }, 100, "Linear", true);
                    //this.camera.follow(this.bullet);
                    game.state.states['Game'].physics.arcade.velocityFromRotation(game.state.states['Game'].turret.rotation, game.state.states['Game'].power, game.state.states['Game'].bullet.body.velocity);
                	
                }
    			//console.log(game.state.states['Game'].power);
    			//TankGame.prototype.receiveUpdate(d);
    			//TankGame.prototype.removeBullet();
    			//console.log(game.power);
    			//moveTank(game);
    			
    		}
    		socket.onclose = function(event) {
    			//document.getElementById("mychat").innerHTML += "Disconnected!";
    		}
    	}
    	function sendMessage(f,v,u) {
    		//socket.send("Miller: " + document.chatform.message.value);
    		var action = {field:f, value:v, user:u};
    		//console.log(action);
    		
    		socket.send(JSON.stringify(action));
    		return false;
    	}
    </script>

</body>
</html>