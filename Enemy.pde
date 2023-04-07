class Enemy extends Machine{
    private AudioPlayer deadSound;
    private AudioPlayer hitSound;

    Enemy(float _x, float _y, int _HP){
        super(_x, _y, _HP);
        size = 16;
        col = color(255);

        deadSound = minim.loadFile("魔王魂  戦闘18.mp3");
        deadSound.setGain(-10f);
        hitSound = minim.loadFile("魔王魂  戦闘07.mp3");
        hitSound.setGain(-10f);
    }

    //移動とかのショット以外の挙動はここに書く
    void updateMe(Stage _s){
        super.updateMe(_s);
        if(isOutOfScreen()){
            kill();
        }
    }

    //敵機体の描画をここに書く
    void drawMe(PGraphics pg){
        super.drawMe(pg);
    }

    //ショットの発射処理はここに書く
    void shot(){

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
        vel = new PVector(-1, 0);
        size = 16;
        hue = random(360);
        col = HSVtoRGB(hue, 255, 255);
    }

    void shot(){
        if(count % 6 == 1){
            for(int i = 0; i < way; i++){
                LaserShot shot = new LaserShot(pos.x, pos.y, 50, 5);
                shot.setVelocityFromSpeedAngle(2, radians(angle) + TWO_PI / way * i);
                accel = (new PVector(0.1 * cos(shot.vel.heading()) , 0.1 * sin(shot.vel.heading())));
                //shot.delay = 15;
                //shot.size = 6;
                shot.col = (HSVtoRGB(hue, 255 - 64, 255));
                /*
                ShotMoveCue cue = new ShotMoveCue(60, 
                    PVector.mult(shot.vel, 4),
                    new PVector(0, 0),
                    HSVtoRGB(hue, 255 - 64, 255));
                shot.addCue(cue);
                */
                stage.addEnemyShot(shot);

                RectShot shot2 = new RectShot(pos.x, pos.y, 30);
                shot2.setVelocityFromSpeedAngle(2, radians(angle + 45) + TWO_PI / way * i);
                shot.setSize(6);
                shot2.setColor(HSVtoRGB(hue, 255 - 64, 255));
                
                ShotMoveCue cue = new ShotMoveCue(60, 
                    PVector.mult(shot2.vel, 3),
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
        vel = new PVector(-0.07, 1);
        col = HSVtoRGB(100, 255, 255);
    }
}

class March02 extends Enemy{
    March02(float _x, float _y){
        super(_x, _y, 2);
        vel = new PVector(-0.07, -1);
        col = HSVtoRGB(100, 255, 255);
    }
}

class Aim01 extends Enemy{
    private float shotHue;

    Aim01(float _x, float _y){
        super(_x, _y, 16);
        vel = new PVector(-0.07, -1);
        shotHue = 75;
        col = HSVtoRGB(shotHue, 255, 255);
    }

    void updateMe(Stage _s){
        super.updateMe(_s);

        if(count < 60){
            vel = new PVector(-1.5, 0);
        }else if(count == 60){
            vel = new PVector(0, 0);
        }else if(count == 180){
            vel = new PVector(-1, 0);
            accel = new PVector(-0.1, 0);
        }
    }

    void shot(){
        if(count > 60 && count <= 180){
            if(count % 15 == 0){
                PVector dirToJiki = new PVector(stage.getJiki().getX() - pos.x, stage.getJiki().getY() - pos.y);
                float angle = dirToJiki.heading();
                nWay(stage, pos, 3, 3.0f, angle, radians(15), HSVtoRGB(shotHue, 255, 255));
                shotHue -= 10;
            }
        }
    }

    void setHue(float hue){
        shotHue = hue;
        col = HSVtoRGB(shotHue, 255, 255);
    }
}

class Circle01 extends Enemy{
    Circle01(float _x, float _y){
        super(_x, _y, 15);
        size = 20;
        vel = (new PVector(-1, 0));
        col = (HSVtoRGB(0, 255, 255));
    }
    int shotCount = 0;

    void updateMe(Stage _s){
        super.updateMe(_s);

        if(count == 0){
            vel = (new PVector(-1, 0));
        }
        if(count == 60){
            vel = (new PVector(0, 0));
        }
        if(count == 180){
            vel = (new PVector(1, 0));
        }
    }

    void shot(){
        if(count < 60 || count > 180 || count % 30 != 0)return;

        PVector dirToJiki = new PVector(stage.getJiki().getX() - pos.x, stage.getJiki().getY() - pos.y);
        float angle = dirToJiki.heading();
        float hue = shotCount * 10;
        if(shotCount % 2 == 0){
            for(int i = 0; i < 13; i++){
                RectShot shot = new RectShot(pos.x, pos.y, 15);
                shot.setVelocityFromSpeedAngle(3, angle + TWO_PI / 13 * i);
                shot.setSize(8);
                shot.setColor(HSVtoRGB(hue, 255, 255));
                stage.addEnemyShot(shot);
                hue += 360 / 13;
            }
        }else{
            angle += TWO_PI / 14 / 2;
            for(int i = 0; i < 14; i++){
                RectShot shot = new RectShot(pos.x, pos.y, 15);
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

class ShotGun01 extends Enemy{
    private float shotAngle = 0, currentAngle = 0;
    private float bure = 15;
    ShotGun01(float _x, float _y, float _angle){
        super(_x, _y, 12);
        size = (16);
        shotAngle = _angle;
        currentAngle = PI;
        col = (HSVtoRGB(90, 255, 255));
    }

    void updateMe(Stage _s){
        super.updateMe(_s);
        
        if(count == 1){
            vel = (new PVector(-2, 0));
        }
        if(count > 30 && count <= 60){
            vel = (new PVector(0, 0));
            currentAngle += (shotAngle - PI) / 30;
        }
        if(count > 90 && count <= 120){
            currentAngle += (PI - shotAngle) / 30;
        }
        if(count > 120){
            vel = (new PVector(2, 0));
        }
    }

    void drawMe(PGraphics pg){
        pg.beginDraw();

        pg.fill(col);
        pg.stroke(col);
        easyTriangle(pg, pos, currentAngle, size);

        pg.endDraw();
    }

    void shot(){
        if(count == 65){
            for(int i = 0; i < 30; i++){
                Shot shot = new Shot(getX(), pos.y, 15);
                shot.setVelocityFromSpeedAngle(3 + random(-1, 1), shotAngle + radians(random(-bure, bure)));
                shot.setSize(6);
                shot.setColor(HSVtoRGB(90, 120, 255));
                shot.setBlendStyle(ADD);
                stage.addEnemyShot(shot);
            }
        }
    }
}

class Red01 extends Enemy{
    float angle = radians(90);
    Red01(float _x, float _y){
        super(_x, _y, 16);
        size = (16);
        col = (HSVtoRGB(0, 255, 255));
        vel = (new PVector(-5, 0));
    }

    void updateMe(Stage _s){
        super.updateMe(_s);

        if(count == 30){
            vel = (new PVector(0, 0));
        }
        if(count == 300){
            vel = (new PVector(2, 0));
        }
    }

    void shot(){
        if(count >= 30 && count <= 300){
            if(count % 5 == 0){
                Shot shot = new Shot(pos.x, pos.y, 15);
                shot.size = (8);
                shot.col = (col);
                shot.setVelocityFromSpeedAngle(2, angle);
                shot.addCue(new ShotMoveCue(
                    60,
                    new PVector(0, 0),
                    new PVector(0, 0),
                    col
                ));
                shot.addCue(new ShotMoveCue(
                    90,
                    new PVector(-3, 0),
                    new PVector(0, 0),
                    col
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
        size = (16);
        col = (HSVtoRGB(120, 255, 255));
        vel = (new PVector(-5, 0));
    }

    void updateMe(Stage _s){
        super.updateMe(_s);

        if(count == 30){
            vel = (new PVector(0, 0));
        }
        if(count == 300){
            vel = (new PVector(2, 0));
        }
    }

    void shot(){
        if(count >= 30 && count <= 300){
            if(count % 5 == 0){
                Shot shot = new Shot(pos.x, pos.y, 15);
                shot.size = (8);
                shot.col = (col);
                shot.setVelocityFromSpeedAngle(1, angle);
                shot.addCue(new ShotMoveCue(
                    30,
                    new PVector(0, 0),
                    new PVector(0, 0),
                    col
                ));
                shot.addCue(new ShotMoveCue(
                    90,
                    new PVector(0, 0),
                    new PVector(0.1 * cos(angle), 0.1 * sin(angle)),
                    col
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
        size = (16);
        col = (HSVtoRGB(240, 255, 255));
        vel = (new PVector(-5, 0));
    }

    void updateMe(Stage _s){
        super.updateMe(_s);

        if(count == 30){
            vel = (new PVector(0, 0));
        }
        if(count == 300){
            vel = (new PVector(2, 0));
        }
    }

    void shot(){
        if(count >= 30 && count <= 300){
            if(count % 5 == 0){
                Shot shot = new Shot(pos.x, pos.y, 30);
                shot.size = (8);
                shot.col = (col);
                shot.setVelocityFromSpeedAngle(1, angle);
                shot.addCue(new ShotMoveCue(
                    60,
                    new PVector(0, 0),
                    new PVector(0, 0),
                    col
                ));
                float bure = random(-10, 10);
                shot.addCue(new ShotMoveCue(
                    90,
                    new PVector(3 * cos(angle + radians(bure)), 3 * sin(angle + radians(bure))),
                    new PVector(0, 0),
                    col
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
        size = (16);
        setVel(-2.25, 0);
        col = (HSVtoRGB(165, 255, 255));
    }


    void updateMe(Stage _s){
        super.updateMe(_s);
    }

    void shot(){
        if(count >= 60 && count % 90 == 0){
            for(int i = 0; i < 4; i++){
                LaserShot laser = new LaserShot(pos.x, pos.y, 30, 3);
                laser.col = (col);
                laser.setVelocityFromSpeedAngle(3, radians(45) + radians(90) * i);
                stage.addEnemyShot(laser);
            }
        }
    }
}

//撃破か画面左端到達で自爆弾
class Missile01 extends Enemy{
    //自爆弾が1回しか出ないように
    private boolean shotFinish = false;

    Missile01(float _x, float _y){
        super(_x, _y, 2);
        size = (16);
        vel = new PVector(-4, 0);
        col = color(255, 10, 185);
    }

    void shot(){
        if(pos.x < 0 && !shotFinish){
            for(int i = 0; i < 10; i++){
                Shot shot = new Shot(pos.x, pos.y, 10);
                float angle = TWO_PI / 10 * i;
                shot.size = (8);
                shot.col = (col);
                shot.setVel(0, 0);
                shot.setAccel(0.05 * cos(angle), 0.05 * sin(angle));
                stage.addEnemyShot(shot);
            }
            shotFinish = true;
        }
    }

    public void kill(){
        for(int i = 0; i < 10; i++){
            Shot shot = new Shot(pos.x, pos.y, 10);
            float angle = TWO_PI / 10 * i;
            shot.size = (8);
            shot.col = (col);
            shot.setVel(0, 0);
            shot.setAccel(0.05 * cos(angle), 0.05 * sin(angle));
            stage.addEnemyShot(shot);
        }
        super.kill();
    }
}

//撃破時にビットが居残りすることがあるっぽい？
class MidBoss01 extends Enemy{
    float bitRadius = 0;
    Shot[] bits = new Shot[5];

    MidBoss01(float _x, float _y){
        super(_x, _y, 100);
        size = 32;
        col = color(255, 255, 255);
        vel = new PVector(-5, 0);
    }

    void updateMe(Stage _s){
        super.updateMe(_s);
        if(count > 1){
            for(int i = 0; i < 5; i++){
                bits[i].setPos(pos.x + bitRadius * cos(radians(count + 360 / 5 * i)), pos.y + bitRadius * sin(radians(count + 360 / 5 * i)));
            }
        }
        if(count > 30 && count < 60){
            bitRadius += 100 / 30;
        }

        if(count == 30){
            vel = (new PVector(0, 0));
        }
    }

    void shot(){
        if(count == 1){
            for(int i = 0; i < 5; i++){
                Shot shot = new Shot(pos.x + bitRadius * cos(radians(count + 360 / 5 * i)), pos.y + bitRadius * sin(radians(count + 360 / 5 * i)), 30);
                bits[i] = shot;
                shot.setDeletable(false);
                shot.size = (12);
                shot.col = (HSVtoRGB(0 + 360 / 5 * i, 255, 255));
                stage.addEnemyShot(shot);
            }
        }

        if(count > 60 && getHP() > 1){
            switch(count % 60){
                case 0:
                    //赤ビット
                    float a0 = random(TWO_PI);
                    for(int i = 0; i < 3; i++){
                        for(int j = 0; j < 5; j++){
                            RectShot shot = new RectShot(bits[0].getX(), bits[0].getY(), 10);
                            shot.size = (6);
                            shot.setVelocityFromSpeedAngle(1.5 + j * 0.5, TWO_PI / 3 * i + radians(7.5) * j);
                            shot.col = (HSVtoRGB(0 + j * 10, 255, 255));
                            stage.addEnemyShot(shot);
                        }
                    }
                    break;
                case 60 / 5 * 1:
                    //黄色ビット
                    float a1 = new PVector(stage.getJiki().getX() - bits[1].getX(), stage.getJiki().getY() - bits[1].getY()).heading();
                    a1 += TWO_PI / 10;
                    for(int i = 0; i < 5; i++){
                        LaserShot shot = new LaserShot(bits[1].getX(), bits[1].getY(), 48, 5);
                        shot.setVelocityFromSpeedAngle(3, a1 + TWO_PI / 5 * i);
                        //shot.delay = 0;
                        shot.col = (bits[1].getColor());
                        stage.addEnemyShot(shot);
                    }
                    break;
                case 60 / 5 * 2:
                    //みどりビット
                    float a2 = 0;
                    for(int i = 0; i < 30; i++){
                        Shot shot = new Shot(bits[2].getX(), bits[2].getY(), 30);
                        shot.setVelocityFromSpeedAngle(0, a2);
                        shot.size = (5);
                        shot.col = (HSVtoRGB(360 / 5 * 2 + i * 2, 255, 255));
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
                    //青ビット
                    float a3 = new PVector(stage.getJiki().getX() - bits[3].getX(), stage.getJiki().getY() - bits[3].getY()).heading();
                    for(int i = 0; i < 6; i++){
                        for(int j = 0; j < 3; j++){
                            RectShot shot = new RectShot(bits[3].getX() + cos(a3) * j * 30, bits[3].getY() + sin(a3) * j * 30, 10);
                            shot.size = (8);
                            shot.setVelocityFromSpeedAngle(2, a3);
                            float a3_3 = radians(random(-10, 10));
                            shot.accel = (new PVector(0.05 * cos(a3 + a3_3), 0.05 * sin(a3 + a3_3)));
                            shot.col = (HSVtoRGB(360 / 5 * 3 + j * 7.737, 200, 255));
                            stage.addEnemyShot(shot);
                        }
                        a3 += TWO_PI / 6;
                    }
                    break;
                case 60 / 5 * 4:
                    //むらさきビット
                    float a4 = new PVector(stage.getJiki().getX() - bits[4].getX(), stage.getJiki().getY() - bits[4].getY()).heading();
                    for(int i = 0; i < 5; i++){
                        Shot shot = new Shot(bits[4].getX(), bits[4].getY(), 10);
                        shot.size = (8);
                        shot.setVelocityFromSpeedAngle(3, a4 + radians(-60 + 30 * i));
                        shot.col = (bits[4].getColor());
                        stage.addEnemyShot(shot);
                    }
                    break;
            }
        }
    }

    void kill(){
        for(int i = 0; i < 5; i++){
            stage.removeEnemyShot(bits[i]);
        }
        super.kill();
    }
}

class Boss_Mauve extends Enemy{
    private int keitai = 0;
    Boss_Mauve(float _x, float _y){
        super(_x, _y, 100);
        size = 32;
        col = color(#915da3);
        vel = new PVector(-3, 0);
    }

    void updateMe(Stage _s){
        switch(keitai){
            case 0:
                if(count == 30){
                    vel = new PVector(0, 0);
                }else if(count > 30){

                }
            break;
        }
    }

    void shot(){
        switch(keitai){
            case 0:
                if(count <= 30)return;
                
            break;
        }
    }
}