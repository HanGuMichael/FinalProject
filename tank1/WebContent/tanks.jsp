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
        },
        create: function () {
            this.background = this.add.sprite(0, 0, 'background');
            this.targets = this.add.group(this.game.world, 'targets', false, true, Phaser.Physics.ARCADE);
            //this.targets.create(300, 390, 'target');
            //this.targets.create(500, 390, 'target');
            //this.targets.create(700, 390, 'target');
            //this.targets.create(900, 390, 'target');
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
        },
        hitTarget: function (bullet, target) {
            target.kill();
            this.removeBullet();
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
                    //  Bullet vs. the Targets
                    this.physics.arcade.overlap(this.bullet, this.targets, this.hitTarget, null, this);
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
                if (this.cursors.up.isDown && this.turret.angle > -90)
                {
                    this.turret.angle--;
                }
                else if (this.cursors.down.isDown && this.turret.angle < 0)
                {
                    this.turret.angle++;
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