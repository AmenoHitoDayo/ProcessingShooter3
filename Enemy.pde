class Enemy extends Machine{
    boolean isDead = false;
    boolean isOutOfScreen = false;  //画面外に出て消えた時にはエフェクト出ないように
    Enemy(float _x, float _y, int _HP){
        super(_x, _y, _HP);
        size = 16;
        col = color(255);
    }

    void updateMe(){
        super.updateMe();
        if(pos.x < 0 - size || pos.x > width + size || pos.y < 0 - size || pos.y > height + size){
            isOutOfScreen = true;
            isDead = true;
        }
        if(HP <= 0){
            isDead = true;
        }
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
        HP = 2;
        vel = new PVector(-0.07, 1);
        col = HSVtoRGB(100, 255, 255);
    }
}

class March02 extends Enemy{
    March02(float _x, float _y){
        super(_x, _y, 10);
        HP = 2;
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
                    RectShot shot = new RectShot(pos.x, pos.y, 15);
                    shot.setVelocity(3, angle + TWO_PI / 13 * i);
                    shot.size = 8;
                    shot.col = HSVtoRGB(hue, 255, 255);
                    s.enemyShots.addShot(shot);
                    hue += 360 / 13;
                }
            }else{
                angle += TWO_PI / 14 / 2;
                for(int i = 0; i < 14; i++){
                    RectShot shot = new RectShot(pos.x, pos.y, 15);
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

class ShotGun01 extends Enemy{
    float shotAngle = 0, currentAngle = 0;
    float bure = 15;
    ShotGun01(float _x, float _y, float _angle){
        super(_x, _y, 16);
        size = 16;
        shotAngle = _angle;
        currentAngle = PI;
        col = HSVtoRGB(90, 255, 255);
    }

    void updateMe(){
        super.updateMe();
        
        if(count == 1){
            vel = new PVector(-2, 0);
        }
        if(count > 30 && count <= 60){
            vel = new PVector(0, 0);
            currentAngle += (shotAngle - PI) / 30;
        }
        if(count > 90 && count <= 120){
            currentAngle += (PI - shotAngle) / 30;
        }
        if(count > 120){
            vel = new PVector(2, 0);
        }
    }

    void drawMe(){
        fill(col);
        stroke(col);
        easyTriangle(pos, currentAngle, size);
    }

    void shot(Stage s){
        if(count == 65){
            for(int i = 0; i < 30; i++){
                Shot shot = new Shot(pos.x, pos.y, 15);
                shot.setVelocity(3 + random(-1, 1), shotAngle + radians(random(-bure, bure)));
                shot.size = 6;
                shot.col = HSVtoRGB(90, 120, 255);
                s.enemyShots.addShot(shot);
            }
        }
    }
}

class Red01 extends Enemy{
    float angle = radians(90);
    Red01(float _x, float _y){
        super(_x, _y, 16);
        size = 16;
        col = HSVtoRGB(0, 255, 255);
        vel = new PVector(-5, 0);
    }

    void updateMe(){
        super.updateMe();

        if(count == 30){
            vel = new PVector(0, 0);
        }
        if(count == 300){
            vel = new PVector(2, 0);
        }
    }

    void shot(Stage s){
        if(count >= 30 && count <= 300){
            if(count % 5 == 0){
                Shot shot = new Shot(pos.x, pos.y, 15);
                shot.size = 8;
                shot.col = col;
                shot.setVelocity(2, angle);
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
                s.enemyShots.addShot(shot);
                angle += radians(19);
            }
        }
    }
}

class Green01 extends Enemy{
    float angle = radians(90);
    Green01(float _x, float _y){
        super(_x, _y, 16);
        size = 16;
        col = HSVtoRGB(120, 255, 255);
        vel = new PVector(-5, 0);
    }

    void updateMe(){
        super.updateMe();

        if(count == 30){
            vel = new PVector(0, 0);
        }
        if(count == 300){
            vel = new PVector(2, 0);
        }
    }

    void shot(Stage s){
        if(count >= 30 && count <= 300){
            if(count % 5 == 0){
                Shot shot = new Shot(pos.x, pos.y, 15);
                shot.size = 8;
                shot.col = col;
                shot.setVelocity(1, angle);
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
                s.enemyShots.addShot(shot);
                angle += radians(13);
            }
        }
    }
}

class Blue01 extends Enemy{
    float angle = radians(90);
    Blue01(float _x, float _y){
        super(_x, _y, 10);
        size = 16;
        col = HSVtoRGB(240, 255, 255);
        vel = new PVector(-5, 0);
    }

    void updateMe(){
        super.updateMe();

        if(count == 30){
            vel = new PVector(0, 0);
        }
        if(count == 300){
            vel = new PVector(2, 0);
        }
    }

    void shot(Stage s){
        if(count >= 30 && count <= 300){
            if(count % 5 == 0){
                Shot shot = new Shot(pos.x, pos.y, 30);
                shot.size = 8;
                shot.col = col;
                shot.setVelocity(1, angle);
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
                s.enemyShots.addShot(shot);
                angle += radians(7);
            }
        }
    }
}

class MidBoss01 extends Enemy{
    float bitRadius = 0;
    Shot[] bits = new Shot[5];

    MidBoss01(float _x, float _y){
        super(_x, _y, 100);
        size = 32;
        col = color(255, 255, 255);
        vel = new PVector(-5, 0);
    }

    void updateMe(){
        super.updateMe();
        if(count > 1){
            for(int i = 0; i < 5; i++){
                bits[i].pos = new PVector(pos.x + bitRadius * cos(radians(count + 360 / 5 * i)), pos.y + bitRadius * sin(radians(count + 360 / 5 * i)));
            }
        }
        if(count > 30 && count < 60){
            bitRadius += 100 / 30;
        }

        if(count == 30){
            vel = new PVector(0, 0);
        }
    }

    void shot(Stage s){
        if(count == 1){
            for(int i = 0; i < 5; i++){
                Shot shot = new Shot(pos.x + bitRadius * cos(radians(count + 360 / 5 * i)), pos.y + bitRadius * sin(radians(count + 360 / 5 * i)), 30);
                bits[i] = shot;
                shot.isDeletable = false;
                shot.size = 12;
                shot.col = HSVtoRGB(0 + 360 / 5 * i, 255, 255);
                s.enemyShots.addShot(shot);
            }
        }

        if(count > 60 && HP > 1){
            switch(count % 60){
                case 0:
                    float a0 = random(TWO_PI);
                    for(int i = 0; i < 3; i++){
                        for(int j = 0; j < 5; j++){
                            RectShot shot = new RectShot(bits[0].pos.x, bits[0].pos.y, 10);
                            shot.size = 6;
                            shot.setVelocity(1.5 + j * 0.5, TWO_PI / 3 * i + radians(7.5) * j);
                            shot.col = HSVtoRGB(0 + j * 10, 255, 255);
                            s.enemyShots.addShot(shot);
                        }
                    }
                    break;
                case 60 / 5 * 1:
                    float a1 = new PVector(s.jiki.pos.x - bits[1].pos.x, s.jiki.pos.y - bits[1].pos.y).heading();
                    a1 += TWO_PI / 10;
                    for(int i = 0; i < 5; i++){
                        LaserShot shot = new LaserShot(bits[1].pos.x, bits[1].pos.y, 48, 5);
                        shot.setVelocity(3, a1 + TWO_PI / 5 * i);
                        shot.delay = 0;
                        shot.col = bits[1].col;
                        s.enemyShots.addShot(shot);
                    }
                    break;
                case 60 / 5 * 2:
                    float a2 = 0;
                    for(int i = 0; i < 30; i++){
                        Shot shot = new Shot(bits[2].pos.x, bits[2].pos.y, 30);
                        shot.setVelocity(0, a2);
                        shot.size = 5;
                        shot.col = HSVtoRGB(360 / 5 * 2 + i * 2, 255, 255);
                        shot.addCue(new ShotMoveCue(
                            i + 1,
                            new PVector(3 * cos(a2), 3 * sin(a2)),
                            new PVector(0.025 * cos(a2), 0.025 * cos(a2)),
                            shot.col
                        ));
                        s.enemyShots.addShot(shot);
                        a2 += TWO_PI / 30;
                    }
                    break;
                case 60 / 5 * 3:
                    float a3 = new PVector(s.jiki.pos.x - bits[3].pos.x, s.jiki.pos.y - bits[3].pos.y).heading();
                    for(int i = 0; i < 6; i++){
                        for(int j = 0; j < 3; j++){
                            RectShot shot = new RectShot(bits[3].pos.x + cos(a3) * j * 30, bits[3].pos.y + sin(a3) * j * 30, 10);
                            shot.size = 8;
                            shot.setVelocity(2, a3);
                            float a3_3 = radians(random(-10, 10));
                            shot.accel = new PVector(0.05 * cos(a3 + a3_3), 0.05 * sin(a3 + a3_3));
                            shot.col = HSVtoRGB(360 / 5 * 3 + j * 7.737, 200, 255);
                            s.enemyShots.addShot(shot);
                        }
                        a3 += TWO_PI / 6;
                    }
                    break;
                case 60 / 5 * 4:
                    float a4 = new PVector(s.jiki.pos.x - bits[4].pos.x, s.jiki.pos.y - bits[4].pos.y).heading();
                    for(int i = 0; i < 5; i++){
                        Shot shot = new Shot(bits[4].pos.x, bits[4].pos.y, 10);
                        shot.size = 8;
                        shot.setVelocity(3, a4 + radians(-60 + 30 * i));
                        shot.col = bits[4].col;
                        s.enemyShots.addShot(shot);
                    }
                    break;
            }
        }

        if(HP <= 1){
            for(int i = 0; i < 5; i++){
                s.enemyShots.removeShot(bits[i]);
            }
        }
    }
}