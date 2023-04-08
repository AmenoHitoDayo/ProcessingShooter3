class Enemy extends Machine{
    private AudioPlayer deadSound;
    private AudioPlayer hitSound;

    //これtrueにしてたら弾があたらない
    protected boolean invincible = false;

    Enemy(float _x, float _y, int _HP){
        super(_x, _y, _HP);
        size = 16;
        col = color(255);

        deadSound = minim.loadFile("魔王魂  戦闘18.mp3");
        deadSound.setGain(-10f);
        hitSound = minim.loadFile("魔王魂  戦闘07.mp3");
        hitSound.setGain(-15f);
    }

    //移動とかのショット以外の挙動はここに書く
    @Override
    void updateMe(Stage _s){
        super.updateMe(_s);
        if(isOutOfScreen()){
            kill();
        }
    }

    //敵機体の描画をここに書く
    @Override
    void drawMe(PGraphics pg){
        super.drawMe(pg);
    }

    @Override
    void kill(){
        if(!isOutOfScreen()){
            playDeadSound();
            circleParticle particle = new circleParticle(pos.x, pos.y, col);
            stage.addParticle(particle);
        }
        super.kill();
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

    @Override
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

                Shot shot2 = new Shot(pos.x, pos.y, 30);
                shot2.setVelocityFromSpeedAngle(2, radians(angle + 45) + TWO_PI / way * i);
                shot2.setSize(6);
                shot2.setColor(HSVtoRGB(hue, 255 - 64, 255));
                
                ShotMoveCue cue = new ShotMoveCue(60, 
                    PVector.mult(shot2.vel, 3),
                    new PVector(0, 0),
                    0,
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

    @Override
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

    @Override
    void shot(){
        if(count > 60 && count <= 180){
            if(count % 15 == 0){
                PVector dirToJiki = new PVector(stage.getJiki().getX() - pos.x, stage.getJiki().getY() - pos.y);
                float angle = dirToJiki.heading();
                ArrayList<Shot> shots = nWay(pos, 3, 3.0f, angle, radians(15));
                for(Shot s : shots){
                    s.setColor(HSVtoRGB(shotHue, 255, 255));
                    s.setSize(8);
                    s.setShotStyle(ShotStyle.Rect);
                    stage.addEnemyShot(s);
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
        super(_x, _y, 15);
        size = 20;
        vel = (new PVector(-1, 0));
        col = (HSVtoRGB(0, 255, 255));
    }
    int shotCount = 0;

    @Override
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

    @Override
    void shot(){
        if(count < 60 || count > 180 || count % 30 != 0)return;

        PVector dirToJiki = new PVector(stage.getJiki().getX() - pos.x, stage.getJiki().getY() - pos.y);
        float angle = dirToJiki.heading();
        float hue = shotCount * 10;
        if(shotCount % 2 == 0){
            for(int i = 0; i < 13; i++){
                Shot shot = new Shot(pos.x, pos.y, 15);
                shot.setVelocityFromSpeedAngle(3, angle + TWO_PI / 13 * i);
                shot.setSize(8);
                shot.setColor(HSVtoRGB(hue, 255, 255));
                shot.setShotStyle(ShotStyle.Rect);
                stage.addEnemyShot(shot);
                hue += 360 / 13;
            }
        }else{
            angle += TWO_PI / 14 / 2;
            for(int i = 0; i < 14; i++){
                Shot shot = new Shot(pos.x, pos.y, 15);
                shot.setVelocityFromSpeedAngle(3, angle + TWO_PI / 14 * i);
                shot.setSize(8);
                shot.setColor(HSVtoRGB(hue, 255, 255));
                shot.setShotStyle(ShotStyle.Rect);
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

    @Override
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

    @Override
    void drawMe(PGraphics pg){
        pg.beginDraw();

        pg.fill(col);
        pg.stroke(col);
        easyTriangle(pg, pos, currentAngle, size);

        pg.endDraw();
    }

    @Override
    void shot(){
        if(count == 65){
            for(int i = 0; i < 30; i++){
                Shot shot = new Shot(getX(), getY(), 15);
                float angle = shotAngle + radians(random(-bure, bure));
                shot.setVelocityFromSpeedAngle(3 + random(-1, 1), angle);
                shot.setSize(4);
                shot.setColor(HSVtoRGB(random(360), 50, 255));
                shot.setBlendStyle(LIGHTEST);
                shot.shotStyle = ShotStyle.Oval;
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

    @Override
    void updateMe(Stage _s){
        super.updateMe(_s);

        if(count == 30){
            vel = (new PVector(0, 0));
        }
        if(count == 300){
            vel = (new PVector(2, 0));
        }
    }

    @Override
    void shot(){
        if(count >= 30 && count <= 300){
            if(count % 5 == 0){
                Shot shot = new Shot(pos.x, pos.y, 15);
                shot.setSize(8);
                shot.setColor(col);
                shot.setVelocityFromSpeedAngle(2, angle);
                shot.addCue(new ShotMoveCue(
                    60,
                    new PVector(0, 0),
                    new PVector(0, 0),
                    0,
                    col
                ));
                shot.addCue(new ShotMoveCue(
                    90,
                    new PVector(-3, 0),
                    new PVector(0, 0),
                    0,
                    col
                ));
                shot.setBlendStyle(LIGHTEST);
                shot.setShotStyle(ShotStyle.Glow);
                shot.parent = this;
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

    @Override
    void updateMe(Stage _s){
        super.updateMe(_s);

        if(count == 30){
            vel = (new PVector(0, 0));
        }
        if(count == 300){
            vel = (new PVector(2, 0));
        }
    }

    @Override
    void shot(){
        if(count >= 30 && count <= 300){
            if(count % 5 == 0){
                Shot shot = new Shot(pos.x, pos.y, 15);
                shot.setSize(8);
                shot.setColor(col);
                shot.setVelocityFromSpeedAngle(1, angle);
                shot.addCue(new ShotMoveCue(
                    30,
                    new PVector(0, 0),
                    new PVector(0, 0),
                    0,
                    col
                ));
                shot.addCue(new ShotMoveCue(
                    90,
                    new PVector(0, 0),
                    new PVector(0.1 * cos(angle), 0.1 * sin(angle)),
                    radians(0.25),
                    col
                ));
                shot.setBlendStyle(LIGHTEST);
                shot.setShotStyle(ShotStyle.Glow);
                shot.parent = this;
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

    @Override
    void updateMe(Stage _s){
        super.updateMe(_s);

        if(count == 30){
            vel = (new PVector(0, 0));
        }
        if(count == 300){
            vel = (new PVector(2, 0));
        }
    }

    @Override
    void shot(){
        if(count >= 30 && count <= 300){
            if(count % 5 == 0){
                Shot shot = new Shot(pos.x, pos.y, 30);
                shot.setSize(8);
                shot.setColor(col);
                shot.setVelocityFromSpeedAngle(1, angle);
                shot.addCue(new ShotMoveCue(
                    60,
                    new PVector(0, 0),
                    new PVector(0, 0),
                    0,
                    col
                ));
                float bure = random(-10, 10);
                shot.addCue(new ShotMoveCue(
                    90,
                    new PVector(3 * cos(angle + radians(bure)), 3 * sin(angle + radians(bure))),
                    new PVector(0, 0),
                    0,
                    col
                ));
                shot.setBlendStyle(SCREEN);
                shot.setShotStyle(ShotStyle.Glow);
                shot.parent = this;
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


    @Override
    void updateMe(Stage _s){
        super.updateMe(_s);
    }

    @Override
    void shot(){
        if(count >= 60 && count % 90 == 0){
            for(int i = 0; i < 4; i++){
                LaserShot laser = new LaserShot(pos.x, pos.y, 35, 8);
                laser.col = (col);
                laser.setVelocityFromSpeedAngle(3, radians(45) + radians(90) * i);
                laser.setBlendStyle(SCREEN);
                stage.addEnemyShot(laser);
            }
        }
    }
}

//撃破か画面左端到達で自爆弾
class Missile01 extends Enemy{
    //自爆弾が1回しか出ないように
    private boolean shotFinish = false;
    private int way = 10;

    Missile01(float _x, float _y){
        super(_x, _y, 2);
        size = (16);
        vel = new PVector(-4, 0);
        accel = new PVector(-0.1, 0);
        col = color(255, 10, 185);
    }

    @Override
    void shot(){
        if(pos.x < 0 && !shotFinish){
            //circleShot(pos, 10, 0, 0.05, 0, ShotStyle.Oval, col, EXCLUSION);
            makeCircle();
            shotFinish = true;
        }
    }

    @Override
    public void kill(){
        makeCircle();
        super.kill();
    }

    void makeCircle(){
        ArrayList<Shot> shots = circleShot(pos, 10, 0, 0.1, 0);
        for(Shot s : shots){
            s.setColor(col);
            s.setShotStyle(ShotStyle.Oval);
            s.setSize(10);
            stage.addEnemyShot(s);
        }
    }
}

//重力落下噴水
class Fountain01 extends Enemy{
    private float shotAngle;
    private float bure = 7.5;
    Fountain01(float _x, float _y, float _angle){
        super(_x, _y, 3);
        size = 16;
        col = HSVtoRGB(215, 255, 255);
        vel = new PVector(1 * cos(_angle), 1 * sin(_angle));
        shotAngle = _angle;
    }

    @Override
    void updateMe(Stage _s){
        super.updateMe(_s);
        if(count == 45){
            vel = new PVector(0, 0);
        }
        if(count == 90){
            kill();
        }
    }

    @Override
    void drawMe(PGraphics pg){
        pg.beginDraw();
            pg.fill(col);
            pg.stroke(col);
            easyTriangle(pg, pos, radians(0), size);
        pg.endDraw();
    }

    @Override
    void shot(){
        if(count == 60){
            //噴水
            ArrayList<Shot> shots = nWay(pos, 10, 6, shotAngle, radians(5));
            for(Shot s : shots){
                s.setAccel(0, 0.098);
                s.setSize(6);
                s.setColor(red(col) + random(-20, 40), green(col) + random(-20, 40), blue(col) + random(40));
                s.setBlendStyle(LIGHTEST);
                s.shotStyle = ShotStyle.Oval;
                stage.addEnemyShot(s);
            }

            /*
            for(int i = 0; i < 30; i++){
                Shot shot = new Shot(getX(), getY(), 15);
                float angle = shotAngle + radians(random(-bure, bure));
                shot.setVelocityFromSpeedAngle(6 + random(-2, 2), angle);
                shot.setAccel(0, 0.098);
                shot.setSize(6);
                shot.setColor(red(col) + random(-20, 40), green(col) + random(-20, 40), blue(col) + random(40));
                shot.setBlendStyle(LIGHTEST);
                shot.shotStyle = ShotStyle.Oval;
                stage.addEnemyShot(shot);
            }
            */
        }
    }
}

//東方虹龍洞2面に出てくる妖精っぽいの
//クラスタ渦巻き＋大米固定
class UM02Fae extends Enemy{
    float angle = 0f;

    UM02Fae(float _x, float _y){
        super(_x, _y, 3);
        size = 16;
        col = HSVtoRGB(80, 255, 255);
        vel = new PVector(0, -1);
    }

    @Override
    void updateMe(Stage _s){
        super.updateMe(_s);
        if(count == 60){
            vel = new PVector(0, 0);
        }
    }

    @Override
    void shot(){
        if(count < 60) return;

        if(count % 10 == 0){
            ArrayList<Shot> shots = nWay(pos, 10, 1.0, 0.005f, angle, radians(1));
            for(Shot s : shots){
                s.setColor(col);
                s.setSize(4);
                s.setShotStyle(ShotStyle.Oval);
                stage.addEnemyShot(s);
            }
            angle += radians(17);
        }
    }
}

//落下弾をまき散らしながら突っ込んでくるやつ
class ShootingStar extends Enemy{
    ShootingStar(float _x, float _y){
        super(_x, _y, 5);
    }
}

class Lissajous01 extends Enemy{
    Lissajous01(float _x, float _y){
        super(_x, _y, 50);
        size = 24;
        col = color(64, 127, 255);
        vel = new PVector(-3, 0);
        invincible = true;
    }

    @Override
    void updateMe(Stage _s){
        super.updateMe(_s);
        if(count < 30)return;
        if(count == 30){
            invincible = false;
            vel = new PVector(0, 0);
        }
        if(count > 1200){
            vel = new PVector(1, 0);
        }
    }

    @Override
    void shot(){
        if(count < 30)return;

        float angle = radians(count * 7) % TWO_PI;
        float radius = 50f;
        PVector liss = new PVector(pos.x + radius * cos(3 * angle), pos.y + radius * sin(2 * angle));
        Shot s = new Shot(liss.x, liss.y, 30);
        s.setColor(color(0, 255, 255));
        s.setShotStyle(ShotStyle.Oval);
        s.setSize(4);
        s.setVel(0, 0);
        s.setAccelerationFromAccelAngle(0.01, angle);
        s.addCue(new ShotMoveCue(
            60,
            vectorFromMagAngle(2, angle),
            new PVector(0, 0),
            map(angle, 0, TWO_PI, -0.03, 0.03),
            s.getColor()
        ));
        s.parent = this;
        stage.addEnemyShot(s);
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
        invincible = true;
    }

    @Override
    void updateMe(Stage _s){
        super.updateMe(_s);

        if(count < 30) return;

        if(count == 30){
            invincible = false;
            vel = (new PVector(0, 0));
        }

        //積み防止というかあれ
        if(count > 1500){
            kill();
        }

        vel = new PVector(0, cos(radians(count - 30)) * 2);
    }

    @Override
    void shot(){
        if(count == 1){
            for(int i = 0; i < 5; i++){
                OrbitShot shot = new OrbitShot(pos.x, pos.y);
                bits[i] = shot;
                shot.setDeletable(false);
                shot.setColor(HSVtoRGB(0 + 360 / 5 * i, 255, 255));
                shot.setSize(12);
                shot.setShotStyle(ShotStyle.Orb);
                shot.angle = TWO_PI / 5 * i;
                shot.parent = this;
                stage.addEnemyShot(shot);
            }
        }

        //ビット制御
        //クソ読みづらいんで、あとで各ビット毎の制動関数作って呼びつけるのがいいと思う。
        if(count > 60){
            ctrlRed();
            ctrlYellow();
            ctrlGreen();
            ctrlBlue();
            ctrlViolet();
        }
    }

    /*
    @Override
    void kill(){
        for(int i = 0; i < 5; i++){
            stage.removeEnemyShot(bits[i]);
        }
        super.kill();
    }
    */

    void ctrlRed(){
        if(count % 60 != 0)return;

        float a0 = random(TWO_PI);
        for(int i = 0; i < 3; i++){
            for(int j = 0; j < 5; j++){
                Shot shot = new Shot(bits[0].getX(), bits[0].getY(), 10);
                shot.setShotStyle(ShotStyle.Rect);
                shot.setSize(6);
                shot.setVelocityFromSpeedAngle(1.5 + j * 0.5, TWO_PI / 3 * i + radians(7.5) * j);
                shot.setColor(HSVtoRGB(0 + j * 10, 255, 255));
                shot.parent = this;
                stage.addEnemyShot(shot);
            }
        }
    }

    void ctrlYellow(){
        if(count % 60 != 60 / 5) return;

        LaserShot shot = new LaserShot(bits[1].getX(), bits[1].getY(), 64, 5);
        shot.setVel(3, 0);
        shot.setColor(bits[1].getColor());
        shot.parent = this;
        stage.addEnemyShot(shot);

        LaserShot shot2 = new LaserShot(bits[1].getX(), bits[1].getY(), 64, 5);
        shot2.setVel(-3, 0);
        shot2.setColor(bits[1].getColor());
        shot2.parent = this;
        stage.addEnemyShot(shot2);
    }

    //これは後で直せると思う。渦巻き弾をまき散らす感じに・・・
    void ctrlGreen(){
        if(count % 90 > 45) return;

        float a2 = map(count % 90, 0, 45, 0, TWO_PI);
        Shot shot = new Shot(bits[2].getX(), bits[2].getY(), 30);
        shot.setVelocityFromSpeedAngle(0, a2);
        shot.setAccelerationFromAccelAngle(0.05, a2);
        shot.setShotStyle(ShotStyle.Oval);
        shot.setSize(5);
        shot.setColor(lerpColor(bits[2].getColor(), bits[3].getColor(), a2 / TWO_PI));
        shot.parent = this;
        stage.addEnemyShot(shot);
    }

    void ctrlBlue(){
        if(count % 60 != 60 / 5 * 3)return;

        float a3 = new PVector(stage.getJiki().getX() - bits[3].getX(), stage.getJiki().getY() - bits[3].getY()).heading();
        for(int i = 0; i < 6; i++){
            for(int j = 0; j < 3; j++){
                Shot shot = new Shot(bits[3].getX() + cos(a3) * j * 30, bits[3].getY() + sin(a3) * j * 30, 10);
                shot.setShotStyle(ShotStyle.Glow);
                shot.setSize(8);
                shot.setVelocityFromSpeedAngle(2, a3);
                float a3_3 = radians(random(-10, 10));
                shot.setAccel(0.05 * cos(a3 + a3_3), 0.05 * sin(a3 + a3_3));
                shot.setColor(HSVtoRGB(360 / 5 * 3 + j * 7.737, 200, 255));
                shot.parent = this;
                stage.addEnemyShot(shot);
            }
            a3 += TWO_PI / 6;
        }
    }

    void ctrlViolet(){
        if(count % 60 != 60 / 5 * 4)return;
        int way = 10;

        float a4 = new PVector(stage.getJiki().getX() - bits[4].getX(), stage.getJiki().getY() - bits[4].getY()).heading();
        for(int i = 0; i < 3; i++){
            ArrayList<Shot> shots = lineShot(bits[4].getPos(), way, 3.0f, a4 + TWO_PI / 3 * i, radians(120f) / (way - 1));
            for(Shot s : shots){
                s.parent = this;
                s.setColor(bits[4].getColor());
                s.setSize(6);
                stage.addEnemyShot(s);
            }
        }
    }
}

class Boss_Mauve extends Enemy{
    private int keitai = 0;
    float aimAngle = 0; //射角用の
    Boss_Mauve(float _x, float _y){
        super(_x, _y, 500);
        size = 32;
        col = color(#915da3);
        vel = new PVector(-5, 0);
    }

    @Override
    void updateMe(Stage _s){
        super.updateMe(_s);
        switch(keitai){
            case 0:
                if(count < 30) return;
                if(count == 30){
                    vel = new PVector(0, 0);
                }
            break;
        }
    }

    @Override
    void shot(){
        switch(keitai){
            case 0:
                if(count < 30)return;
                formOne();
            break;
        }
    }

    //第一形態のショット
    void formOne(){
        int baseCount = (count - 30) % 120;

        if(baseCount == 0 || baseCount == 20){
            PVector dirToJiki = new PVector(stage.getJiki().getX() - pos.x, stage.getJiki().getY() - pos.y);
            aimAngle = dirToJiki.heading();
            println(aimAngle);
        }
        if(baseCount < 20){
            float angle = map(baseCount, 0, 20, radians(30), radians(300));
            for(int i = 0; i < 3; i++){
                Shot s = new Shot(pos.x + cos(angle) * 50, pos.y + sin(angle) * 180);
                s.setColor(col);
                s.setShotStyle(ShotStyle.Glow);
                s.setBlendStyle(LIGHTEST);
                s.setSize(6);
                s.setVelocityFromSpeedAngle(3 + 0.25 * i, aimAngle);
                stage.addEnemyShot(s);
            }
        }
        if(baseCount > 30 && baseCount < 50){
            float angle = map(baseCount, 30, 50, radians(330), radians(60));
            for(int i = 0; i < 3; i++){
                Shot s = new Shot(pos.x + cos(angle) * 50, pos.y + sin(angle) * 180);
                s.setColor(col);
                s.setShotStyle(ShotStyle.Glow);
                s.setBlendStyle(LIGHTEST);
                s.setSize(6);
                s.setVelocityFromSpeedAngle(3 + 0.25 * i, aimAngle);
                stage.addEnemyShot(s);
            }
        }
        if(baseCount > 60 && baseCount < 120 && baseCount % 10 == 0){
            float angle = map(baseCount, 60, 90, radians(90), radians(270));
            PVector p = new PVector(pos.x + 30 * cos(random(TWO_PI)), pos.y + 30 * sin(random(TWO_PI)));
            for(int i = 0; i < 5; i++){
                ArrayList<Shot> shots = nWay(p, 3, 2 + 0.5 * i, angle, radians(20));
                for(Shot s : shots){
                    s.setSize(4);
                    s.setColor(HSVtoRGB(240, 100, 255));
                    s.setDelay(30);
                    stage.addEnemyShot(s);
                }
            }
        }
    }
}