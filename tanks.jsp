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

    <script type="text/javascript">
    var game = new Phaser.Game(850, 540, Phaser.CANVAS, 'game');
    var TankGame = function (game) {
        this.tank = null;
        
        this.tank2 = null;
        
        this.tanks = null;
        
        this.turret = null;
        this.flame = null;
        this.bullet = null;
        this.background = null;
        this.power = 300;
        this.powerText = null;
        this.cursors = null;
        this.fireButton = null;
        
        //VARIABLES THAT SHOULD BE READ IN FROM SERVER
        this.playerNum = 2;
        this.tank1Color = 'red';
        this.tank2Color = 'blue';
        
        //NOTE PLAYER TWO FIRING DOES NOT WORK
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
            this.load.image('land', 'assets/land.png');
            
            //Tank Colors
            this.load.image('tankRed', 'assets/tank_red.png');
            this.load.image('tankBlue', 'assets/tank_blue.png');
            this.load.image('tankGreen', 'assets/tank_green.png');
        },
        create: function () {
            this.background = this.add.sprite(0, 0, 'background');
            this.bullet = this.add.sprite(0, 0, 'bullet');
            this.bullet.exists = false;
            this.physics.arcade.enable(this.bullet);
            
            if(this.tank1Color == 'blue')
            {
            	this.tank = this.add.sprite(24, 383, 'tankBlue');
            }
            
            else if(this.tank1Color == 'green')
            {
            	this.tank = this.add.sprite(24, 383, 'tankGreen');
            }
            
            else
            {
            	this.tank = this.add.sprite(24, 383, 'tankRed');
            }
            
            if(this.tank2Color == 'blue')
            {
            	 this.tank2 = this.add.sprite(560, 320, 'tankBlue');
            }
            
            else if(this.tank2Color == 'green')
            {
            	 this.tank2 = this.add.sprite(560, 320, 'tankGreen');
            }
            
            else
            {
            	 this.tank2 = this.add.sprite(560, 320, 'tankRed');
            }
            
            this.physics.arcade.enable(this.tank);
            this.tank.body.allowGravity = false;
            
           
            this.physics.arcade.enable(this.tank2);
            this.tank2.body.allowGravity = false;
            this.tank2.anchor.setTo(0.5);
            this.tank2.scale.setTo(-1,1);
            
            this.turret = this.add.sprite(this.tank.x + 30, this.tank.y + 14, 'turret');
            
            this.turret2 = this.add.sprite(this.tank2.x + 2, this.tank2.y - 7, 'turret')
            //this.turret2.anchor.setTo(0.5);
            this.turret2.scale.setTo(-1,1);
            
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

                this.removeBullet();
            }

        },
        fire: function () {
            if (this.bullet.exists)
            {
                return;
            }
            
            if(this.playerNum == 1)
            {
	            this.bullet.reset(this.turret.x + Math.cos(this.turret.rotation)*50, this.turret.y + Math.sin(this.turret.rotation)*50);
	            var p = new Phaser.Point(this.turret.x, this.turret.y);
	            p.rotate(p.x, p.y, this.turret.rotation, false, 34);
	            this.flame.x = p.x;
	            this.flame.y = p.y;
	            this.flame.alpha = 1;
	            this.flame.visible = true;
	            this.add.tween(this.flame).to( { alpha: 0 }, 100, "Linear", true);
	            
	            this.physics.arcade.velocityFromRotation(this.turret.rotation, this.power, this.bullet.body.velocity);
            }
            
            else if (this.playerNum == 2)
            {
            	this.bullet.reset(this.turret2.x - Math.cos(this.turret2.rotation)*50, this.turret2.y - Math.sin(this.turret2.rotation)*50);
 	            var p = new Phaser.Point(this.turret2.x - Math.cos(this.turret2.rotation)*70, this.turret2.y - Math.sin(this.turret2.rotation)*70);
 	            p.rotate(p.x, p.y, this.turret2.rotation, false, 34);
 	            this.flame.x = p.x;
 	            this.flame.y = p.y;
 	            this.flame.alpha = 1;
 	            this.flame.visible = true;
 	            this.add.tween(this.flame).to( { alpha: 0 }, 100, "Linear", true);
 	            
 	            this.physics.arcade.velocityFromRotation(this.turret2.rotation, -1* this.power, this.bullet.body.velocity);
            }
        },
        
        removeBullet: function () {
            this.bullet.kill();
            this.camera.follow();
            this.add.tween(this.camera).to( { x: 0 }, 1000, "Quint", true, 1000);
        },
        update: function () {
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
                    //  Bullet vs. the land
                    this.bulletVsLand();
                    
                    
                    if (this.physics.arcade.overlap(this.bullet, this.tank2))
                    {

                    	this.emitter.at(this.tank2);
                        this.emitter.explode(2000, 10);
                        
                    	this.tank2.kill();
                    	this.turret2.kill();

                        this.removeBullet(true);
                    }
                    
                    if (this.physics.arcade.overlap(this.bullet, this.tank))
                    {

                    	this.emitter.at(this.tank);
                        this.emitter.explode(2000, 10);
                        
                    	this.tank.kill();
                    	this.turret.kill();

                        this.removeBullet(true);
                    }
                }
            }
             else
            {
                if (this.cursors.left.isDown && this.power > 100)
                {
                    this.power -= 2;
                }
                else if (this.cursors.right.isDown && this.power < 600)
                {
                    this.power += 2;
                }
                
                if (this.cursors.up.isDown && this.turret.angle > -90 && this.playerNum == 1)
                {
                    this.turret.angle--;
                }
                
                else if (this.cursors.up.isDown && this.turret2.angle < 90 && this.playerNum == 2)
                {
                	this.turret2.angle++;
                }
                
                else if (this.cursors.down.isDown && this.turret.angle < 0 && this.playerNum == 1)
                {
                    this.turret.angle++;
                }
                
                else if (this.cursors.down.isDown && this.turret2.angle > 0 && this.playerNum == 2)
                {
                	this.turret2.angle--;
                }
                //  Update the text
                this.powerText.text = 'Power: ' + this.power;
            }
        }
    };
    game.state.add('Game', TankGame, true);
    </script>

    

</body>
</html>