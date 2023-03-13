class Enemy extends Machine{
    boolean isDead = false;
    Enemy(float _x, float _y, int _HP){
        super(_x, _y, _HP);
        size = 16;
        col = color(255);
    }

    void updateMe(){
        super.updateMe();
    }

    void drawMe(){
        super.drawMe();
    }

    void shot(Stage s){

    }
    
    void death(){
    }
}

class SampleEnemy extends Enemy{
    float angle = 0;
    float rotation = 0;
    int way = 4;
    float hue = 0;

    SampleEnemy(){
        super(width, height / 2, 10);
        vel = new PVector(-1, 0);
        size = 16;
        hue = random(360);
        col = HSVtoRGB(hue, 255, 255);
    }

    void shot(Stage s){
        if(count % 6 == 1){
            for(int i = 0; i < way; i++){
                LaserShot shot = new LaserShot(pos.x, pos.y, 50, 5);
                shot.setVelocity(2, radians(angle) + TWO_PI / way * i);
                shot.accel = new PVector(0.1 * cos(shot.vel.heading()) , 0.1 * sin(shot.vel.heading()));
                //shot.delay = 15;
                //shot.size = 6;
                shot.col = HSVtoRGB(hue, 255 - 64, 255);
                /*
                ShotMoveCue cue = new ShotMoveCue(60, 
                    PVector.mult(shot.vel, 4),
                    new PVector(0, 0),
                    HSVtoRGB(hue, 255 - 64, 255));
                shot.addCue(cue);
                */
                s.enemyShots.addShot(shot);

                RectShot shot2 = new RectShot(pos.x, pos.y, 30);
                shot2.setVelocity(2, radians(angle + 45) + TWO_PI / way * i);
                shot.size = 6;
                shot2.col = HSVtoRGB(hue, 255 - 64, 255);
                
                ShotMoveCue cue = new ShotMoveCue(60, 
                    PVector.mult(shot2.vel, 3),
                    new PVector(0, 0),
                    HSVtoRGB(hue, 255 - 64, 255));
                shot2.addCue(cue);
                
                s.enemyShots.addShot(shot2);
            }
            angle += rotation;
            rotation += 0.1;
            hue = (hue + 0.5) % 360;
        }
    }
}

class March01 extends Enemy{
    March01(float _x, float _y){
        super(_x, _y, 10);
        HP = 3;
        vel = new PVector(-0.07, 1);
        col = HSVtoRGB(100, 255, 255);
    }
}

class March02 extends Enemy{
    March02(float _x, float _y){
        super(_x, _y, 10);
        HP = 3;
        vel = new PVector(-0.07, -1);
        col = HSVtoRGB(100, 255, 255);
    }
}

class Aim01 extends Enemy{
    float shotHue;

    Aim01(float _x, float _y){
        super(_x, _y, 10);
        HP = 7;
        vel = new PVector(-0.07, -1);
        shotHue = 75;
        col = HSVtoRGB(shotHue, 255, 255);
    }

    void updateMe(){
        super.updateMe();

        if(count < 60){
            vel = new PVector(-1.5, 0);
        }else if(count == 60){
            vel = new PVector(0, 0);
        }else if(count == 180){
            vel = new PVector(-1, 0);
            accel = new PVector(-0.1, 0);
        }
    }

    void shot(Stage s){
        if(count > 60 && count <= 180){
            if(count % 15 == 0){
                PVector dirToJiki = new PVector(s.jiki.pos.x - pos.x, s.jiki.pos.y - pos.y);
                float angle = dirToJiki.heading();
                for(int i = 0; i < 3; i++){
                    RectShot shot = new RectShot(pos.x, pos.y, 15);
                    shot.setVelocity(3, angle + radians(-30 + 30 * i));
                    shot.size = 6;
                    shot.col = HSVtoRGB(shotHue, 255, 255);
                    s.enemyShots.addShot(shot);
                }
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
        super(_x, _y, 10);
        HP = 15;
        size = 20;
        vel = new PVector(-1, 0);
        col = HSVtoRGB(0, 255, 255);
    }
    int shotCount = 0;

    void updateMe(){
        super.updateMe();

        if(count == 0){
            vel = new PVector(-1, 0);
        }
        if(count == 60){
            vel = new PVector(0, 0);
        }
        if(count == 180){
            vel = new PVector(1, 0);
        }
    }

    void shot(Stage s){
        if(count >= 60 && count <= 180 && count % 30 == 0){
            PVector dirToJiki = new PVector(s.jiki.pos.x - pos.x, s.jiki.pos.y - pos.y);
            float angle = dirToJiki.heading();
            float hue = shotCount * 10;
            if(shotCount % 2 == 0){
                for(int i = 0; i < 13; i++){
                    Shot shot = new Shot(pos.x, pos.y, 15);
                    shot.setVelocity(3, angle + TWO_PI / 13 * i);
                    shot.size = 8;
                    shot.col = HSVtoRGB(hue, 255, 255);
                    s.enemyShots.addShot(shot);
                    hue += 360 / 13;
                }
            }else{
                angle += TWO_PI / 14 / 2;
                for(int i = 0; i < 14; i++){
                    Shot shot = new Shot(pos.x, pos.y, 15);
                    shot.setVelocity(3, angle + TWO_PI / 14 * i);
                    shot.size = 6;
                    shot.col = HSVtoRGB(hue, 255, 255);
                    s.enemyShots.addShot(shot);
                    hue += 360 / 14;
                }
            }
            shotCount++;
        }
    }
}