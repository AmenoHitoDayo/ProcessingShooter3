class Enemy extends Machine{

    private AudioPlayer deadSound;
    private AudioPlayer hitSound;

    Enemy(float _x, float _y, int _HP){
        super(_x, _y, _HP);
        setSize(16);
        setColor(color(255));

        deadSound = minim.loadFile("魔王魂  戦闘18.mp3");
        deadSound.setGain(-10f);
        hitSound = minim.loadFile("魔王魂  戦闘07.mp3");
        hitSound.setGain(-10f);
    }

    //移動とかのショット以外の挙動はここに書く
    void updateMe(Stage stage){
        super.updateMe(stage);
        if(getHP() <= 0 || isOutOfScreen()){
            kill();
        }
    }

    //敵機体の描画をここに書く
    void drawMe(PGraphics pg){
        super.drawMe(pg);
    }

    //ショットの発射処理はここに書く
    void shot(Stage stage){

    }

    public void playHitSound(){
        hitSound.play(0);
    }

    public void playDeadSound(){
        deadSound.play(0);
    }
}

class SampleEnemy extends Enemy{
    private float angle = 0;
    private float rotation = 0;
    private int way = 4;
    private float hue = 0;

    SampleEnemy(){
        super(width, height / 2, 10);
        setVel(new PVector(-1, 0));
        setSize(16);
        hue = random(360);
        setColor(HSVtoRGB(hue, 255, 255));
    }

    void shot(Stage stage){
        if(getCount() % 6 == 1){
            for(int i = 0; i < way; i++){
                LaserShot shot = new LaserShot(this.getX(), this.getY(), 50, 5);
                shot.setVelocityFromSpeedAngle(2, radians(angle) + TWO_PI / way * i);
                shot.setAccel(new PVector(0.1 * cos(shot.getVel().heading()) , 0.1 * sin(shot.getVel().heading())));
                //shot.delay = 15;
                //shot.size = 6;
                shot.setColor(HSVtoRGB(hue, 255 - 64, 255));
                /*
                ShotMoveCue cue = new ShotMoveCue(60, 
                    PVector.mult(shot.vel, 4),
                    new PVector(0, 0),
                    HSVtoRGB(hue, 255 - 64, 255));
                shot.addCue(cue);
                */
                stage.addEnemyShot(shot);

                RectShot shot2 = new RectShot(this.getX(), this.getY(), 30);
                shot2.setVelocityFromSpeedAngle(2, radians(angle + 45) + TWO_PI / way * i);
                shot.setSize(6);
                shot2.setColor(HSVtoRGB(hue, 255 - 64, 255));
                
                ShotMoveCue cue = new ShotMoveCue(60, 
                    PVector.mult(shot2.getVel(), 3),
                    new PVector(0, 0),
                    HSVtoRGB(hue, 255 - 64, 255));
                shot2.addCue(cue);
                
                stage.addEnemyShot(shot2);
            }
            angle += rotation;
            rotation += 0.1;
            hue = (hue + 0.5) % 360;
        }
    }
}

class March01 extends Enemy{
    March01(float _x, float _y){
        super(_x, _y, 2);
        setVel(new PVector(-0.07, 1));
        setColor(HSVtoRGB(100, 255, 255));
    }
}

class March02 extends Enemy{
    March02(float _x, float _y){
        super(_x, _y, 2);
        setVel(new PVector(-0.07, -1));
        setColor(HSVtoRGB(100, 255, 255));
    }
}

class Aim01 extends Enemy{
    private float shotHue;

    Aim01(float _x, float _y){
        super(_x, _y, 16);
        setVel(new PVector(-0.07, -1));
        shotHue = 75;
        setColor(HSVtoRGB(shotHue, 255, 255));
    }

    void updateMe(Stage stage){
        super.updateMe(stage);

        if(getCount() < 60){
            setVel(new PVector(-1.5, 0));
        }else if(getCount() == 60){
            setVel(new PVector(0, 0));
        }else if(getCount() == 180){
            setVel(new PVector(-1, 0));
            setAccel(new PVector(-0.1, 0));
        }
    }

    void shot(Stage stage){
        if(getCount() > 60 && getCount() <= 180){
            if(getCount() % 15 == 0){
                PVector dirToJiki = new PVector(stage.jiki.getX() - this.getX(), stage.jiki.getY() - this.getY());
                float angle = dirToJiki.heading();
                for(int i = 0; i < 3; i++){
                    RectShot shot = new RectShot(this.getX(), this.getY(), 15);
                    shot.setVelocityFromSpeedAngle(3, angle + radians(-30 + 30 * i));
                    shot.setSize(6);
                    shot.setColor(HSVtoRGB(shotHue, 255, 255));
                    stage.addEnemyShot(shot);
                }
                shotHue -= 10;
            }
        }
    }

    void setHue(float hue){
        shotHue = hue;
        setColor(HSVtoRGB(shotHue, 255, 255));
    }
}

class Circle01 extends Enemy{
    Circle01(float _x, float _y){
        super(_x, _y, 15);
        setSize(20);
        setVel(new PVector(-1, 0));
        setColor(HSVtoRGB(0, 255, 255));
    }
    int shotCount = 0;

    void updateMe(Stage stage){
        super.updateMe(stage);

        if(getCount() == 0){
            setVel(new PVector(-1, 0));
        }
        if(getCount() == 60){
            setVel(new PVector(0, 0));
        }
        if(getCount() == 180){
            setVel(new PVector(1, 0));
        }
    }

    void shot(Stage stage){
        if(getCount() >= 60 && getCount() <= 180 && getCount() % 30 == 0){
            PVector dirToJiki = new PVector(stage.jiki.getX() - getX(), stage.jiki.getY() - getY());
            float angle = dirToJiki.heading();
            float hue = shotCount * 10;
            if(shotCount % 2 == 0){
                for(int i = 0; i < 13; i++){
                    RectShot shot = new RectShot(getX(), getY(), 15);
                    shot.setVelocityFromSpeedAngle(3, angle + TWO_PI / 13 * i);
                    shot.setSize(8);
                    shot.setColor(HSVtoRGB(hue, 255, 255));
                    stage.addEnemyShot(shot);
                    hue += 360 / 13;
                }
            }else{
                angle += TWO_PI / 14 / 2;
                for(int i = 0; i < 14; i++){
                    RectShot shot = new RectShot(getX(), getY(), 15);
                    shot.setVelocityFromSpeedAngle(3, angle + TWO_PI / 14 * i);
                    shot.setSize(8);
                    shot.setColor(HSVtoRGB(hue, 255, 255));
                    stage.addEnemyShot(shot);
                    hue += 360 / 14;
                }
            }
            shotCount++;
        }
    }
}

class ShotGun01 extends Enemy{
    float shotAngle = 0, currentAngle = 0;
    float bure = 15;
    ShotGun01(float _x, float _y, float _angle){
        super(_x, _y, 12);
        setSize(16);
        shotAngle = _angle;
        currentAngle = PI;
        setColor(HSVtoRGB(90, 255, 255));
    }

    void updateMe(Stage stage){
        super.updateMe(stage);
        
        if(getCount() == 1){
            setVel(new PVector(-2, 0));
        }
        if(getCount() > 30 && getCount() <= 60){
            setVel(new PVector(0, 0));
            currentAngle += (shotAngle - PI) / 30;
        }
        if(getCount() > 90 && getCount() <= 120){
            currentAngle += (PI - shotAngle) / 30;
        }
        if(getCount() > 120){
            setVel(new PVector(2, 0));
        }
    }

    void drawMe(PGraphics pg){
        pg.beginDraw();

        pg.fill(getColor());
        pg.stroke(getColor());
        easyTriangle(pg, getPos(), currentAngle, getSize());

        pg.endDraw();
    }

    void shot(Stage stage){
        if(getCount() == 65){
            for(int i = 0; i < 30; i++){
                Shot shot = new Shot(getX(), getY(), 15);
                shot.setVelocityFromSpeedAngle(3 + random(-1, 1), shotAngle + radians(random(-bure, bure)));
                shot.setSize(6);
                shot.setColor(HSVtoRGB(90, 120, 255));
                stage.addEnemyShot(shot);
            }
        }
    }
}

class Red01 extends Enemy{
    float angle = radians(90);
    Red01(float _x, float _y){
        super(_x, _y, 16);
        setSize(16);
        setColor(HSVtoRGB(0, 255, 255));
        setVel(new PVector(-5, 0));
    }

    void updateMe(Stage stage){
        super.updateMe(stage);

        if(getCount() == 30){
            setVel(new PVector(0, 0));
        }
        if(getCount() == 300){
            setVel(new PVector(2, 0));
        }
    }

    void shot(Stage stage){
        if(getCount() >= 30 && getCount() <= 300){
            if(getCount() % 5 == 0){
                Shot shot = new Shot(getX(), getY(), 15);
                shot.setSize(8);
                shot.setColor(this.getColor());
                shot.setVelocityFromSpeedAngle(2, angle);
                shot.addCue(new ShotMoveCue(
                    60,
                    new PVector(0, 0),
                    new PVector(0, 0),
                    getColor()
                ));
                shot.addCue(new ShotMoveCue(
                    90,
                    new PVector(-3, 0),
                    new PVector(0, 0),
                    getColor()
                ));
                stage.addEnemyShot(shot);
                angle += radians(19);
            }
        }
    }
}

class Green01 extends Enemy{
    float angle = radians(90);
    Green01(float _x, float _y){
        super(_x, _y, 16);
        setSize(16);
        setColor(HSVtoRGB(120, 255, 255));
        setVel(new PVector(-5, 0));
    }

    void updateMe(Stage stage){
        super.updateMe(stage);

        if(getCount() == 30){
            setVel(new PVector(0, 0));
        }
        if(getCount() == 300){
            setVel(new PVector(2, 0));
        }
    }

    void shot(Stage stage){
        if(getCount() >= 30 && getCount() <= 300){
            if(getCount() % 5 == 0){
                Shot shot = new Shot(getX(), getY(), 15);
                shot.setSize(8);
                shot.setColor(getColor());
                shot.setVelocityFromSpeedAngle(1, angle);
                shot.addCue(new ShotMoveCue(
                    30,
                    new PVector(0, 0),
                    new PVector(0, 0),
                    getColor()
                ));
                shot.addCue(new ShotMoveCue(
                    90,
                    new PVector(0, 0),
                    new PVector(0.1 * cos(angle), 0.1 * sin(angle)),
                    getColor()
                ));
                stage.addEnemyShot(shot);
                angle += radians(13);
            }
        }
    }
}

class Blue01 extends Enemy{
    private float angle = radians(90);
    Blue01(float _x, float _y){
        super(_x, _y, 10);
        setSize(16);
        setColor(HSVtoRGB(240, 255, 255));
        setVel(new PVector(-5, 0));
    }

    void updateMe(Stage stage){
        super.updateMe(stage);

        if(getCount() == 30){
            setVel(new PVector(0, 0));
        }
        if(getCount() == 300){
            setVel(new PVector(2, 0));
        }
    }

    void shot(Stage stage){
        if(getCount() >= 30 && getCount() <= 300){
            if(getCount() % 5 == 0){
                Shot shot = new Shot(getX(), getY(), 30);
                shot.setSize(8);
                shot.setColor(getColor());
                shot.setVelocityFromSpeedAngle(1, angle);
                shot.addCue(new ShotMoveCue(
                    60,
                    new PVector(0, 0),
                    new PVector(0, 0),
                    getColor()
                ));
                float bure = random(-10, 10);
                shot.addCue(new ShotMoveCue(
                    90,
                    new PVector(3 * cos(angle + radians(bure)), 3 * sin(angle + radians(bure))),
                    new PVector(0, 0),
                    getColor()
                ));
                stage.addEnemyShot(shot);
                angle += radians(7);
            }
        }
    }
}

class MarchLaser01 extends Enemy{
    MarchLaser01(float _x, float _y){
        super(_x, _y, 5);
        setSize(16);
        setVel(-2.25, 0);
        setColor(HSVtoRGB(165, 255, 255));
    }


    void updateMe(Stage stage){
        super.updateMe(stage);
    }

    void shot(Stage stage){
        if(getCount() >= 60 && getCount() % 90 == 0){
            for(int i = 0; i < 4; i++){
                LaserShot laser = new LaserShot(getX(), getY(), 30, 3);
                laser.setColor(getColor());
                laser.setVelocityFromSpeedAngle(3, radians(45) + radians(90) * i);
                stage.addEnemyShot(laser);
            }
        }
    }
}

class MidBoss01 extends Enemy{
    float bitRadius = 0;
    Shot[] bits = new Shot[5];

    MidBoss01(float _x, float _y){
        super(_x, _y, 100);
        setSize(32);
        setColor(color(255, 255, 255));
        setVel(new PVector(-5, 0));
    }

    void updateMe(Stage stage){
        super.updateMe(stage);
        if(getCount() > 1){
            for(int i = 0; i < 5; i++){
                bits[i].setPos(new PVector(getX() + bitRadius * cos(radians(getCount() + 360 / 5 * i)), getY() + bitRadius * sin(radians(getCount() + 360 / 5 * i))));
            }
        }
        if(getCount() > 30 && getCount() < 60){
            bitRadius += 100 / 30;
        }

        if(getCount() == 30){
            setVel(new PVector(0, 0));
        }
    }

    void shot(Stage stage){
        if(getCount() == 1){
            for(int i = 0; i < 5; i++){
                Shot shot = new Shot(getX() + bitRadius * cos(radians(getCount() + 360 / 5 * i)), getY() + bitRadius * sin(radians(getCount() + 360 / 5 * i)), 30);
                bits[i] = shot;
                shot.setDeletable(false);
                shot.setSize(12);
                shot.setColor(HSVtoRGB(0 + 360 / 5 * i, 255, 255));
                stage.addEnemyShot(shot);
            }
        }

        if(getCount() > 60 && getHP() > 1){
            switch(getCount() % 60){
                case 0:
                    float a0 = random(TWO_PI);
                    for(int i = 0; i < 3; i++){
                        for(int j = 0; j < 5; j++){
                            RectShot shot = new RectShot(bits[0].getX(), bits[0].getY(), 10);
                            shot.setSize(6);
                            shot.setVelocityFromSpeedAngle(1.5 + j * 0.5, TWO_PI / 3 * i + radians(7.5) * j);
                            shot.setColor(HSVtoRGB(0 + j * 10, 255, 255));
                            stage.addEnemyShot(shot);
                        }
                    }
                    break;
                case 60 / 5 * 1:
                    float a1 = new PVector(stage.jiki.getX() - bits[1].getX(), stage.jiki.getY() - bits[1].getY()).heading();
                    a1 += TWO_PI / 10;
                    for(int i = 0; i < 5; i++){
                        LaserShot shot = new LaserShot(bits[1].getX(), bits[1].getY(), 48, 5);
                        shot.setVelocityFromSpeedAngle(3, a1 + TWO_PI / 5 * i);
                        //shot.delay = 0;
                        shot.setColor(bits[1].getColor());
                        stage.addEnemyShot(shot);
                    }
                    break;
                case 60 / 5 * 2:
                    float a2 = 0;
                    for(int i = 0; i < 30; i++){
                        Shot shot = new Shot(bits[2].getX(), bits[2].getY(), 30);
                        shot.setVelocityFromSpeedAngle(0, a2);
                        shot.setSize(5);
                        shot.setColor(HSVtoRGB(360 / 5 * 2 + i * 2, 255, 255));
                        shot.addCue(new ShotMoveCue(
                            i + 1,
                            new PVector(3 * cos(a2), 3 * sin(a2)),
                            new PVector(0.025 * cos(a2), 0.025 * cos(a2)),
                            shot.col
                        ));
                        stage.addEnemyShot(shot);
                        a2 += TWO_PI / 30;
                    }
                    break;
                case 60 / 5 * 3:
                    float a3 = new PVector(stage.jiki.getX() - bits[3].getX(), stage.jiki.getY() - bits[3].getY()).heading();
                    for(int i = 0; i < 6; i++){
                        for(int j = 0; j < 3; j++){
                            RectShot shot = new RectShot(bits[3].getX() + cos(a3) * j * 30, bits[3].getY() + sin(a3) * j * 30, 10);
                            shot.setSize(8);
                            shot.setVelocityFromSpeedAngle(2, a3);
                            float a3_3 = radians(random(-10, 10));
                            shot.setAccel(new PVector(0.05 * cos(a3 + a3_3), 0.05 * sin(a3 + a3_3)));
                            shot.setColor(HSVtoRGB(360 / 5 * 3 + j * 7.737, 200, 255));
                            stage.addEnemyShot(shot);
                        }
                        a3 += TWO_PI / 6;
                    }
                    break;
                case 60 / 5 * 4:
                    float a4 = new PVector(stage.jiki.getX() - bits[4].getX(), stage.jiki.getY() - bits[4].getY()).heading();
                    for(int i = 0; i < 5; i++){
                        Shot shot = new Shot(bits[4].getX(), bits[4].getY(), 10);
                        shot.setSize(8);
                        shot.setVelocityFromSpeedAngle(3, a4 + radians(-60 + 30 * i));
                        shot.setColor(bits[4].getColor());
                        stage.addEnemyShot(shot);
                    }
                    break;
            }
        }

        if(getHP() <= 1){
            for(int i = 0; i < 5; i++){
                stage.enemyShots.removeShot(bits[i]);
            }
        }
    }
}
