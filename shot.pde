class Shot extends Mover{
    private int delay = 0;
    private ArrayList<ShotMoveCue> cues;
    private boolean isDeletable = true;
    private boolean isHittable = true;
    private int blendStyle = BLEND;
    private Mover parent = null;

    Shot(float _x, float _y){
        super(_x, _y);
        vel = (new PVector(0, 0));
        delay = 0;
        cues = new ArrayList<ShotMoveCue>();
    }

    Shot(float _x, float _y, int _delay){
        super(_x, _y);
        vel = (new PVector(0, 0));
        delay = _delay;
        cues = new ArrayList<ShotMoveCue>();
    }

    Shot(float _x, float _y, float speed, float angle){
        super(_x, _y);
        vel = (new PVector(speed * cos(angle), speed * sin(angle)));
        delay = 0;
        cues = new ArrayList<ShotMoveCue>();
    }

    void updateMe(Stage stage){
        super.updateMe(stage);
        executeCue();
        if(count < delay){
            isHittable = false;
        }else{
            isHittable = true;
        }
        if(isOutOfScreen()){
            kill();
        }
        if(parent != null && parent.isDead){
            kill();
        }
    }

    void drawMe(PGraphics pg){
        if(count < delay){
            delayDraw(pg);
        }else{
            shotDraw(pg);
        }
    }

    void shotDraw(PGraphics pg){
        pg.beginDraw();
            pg.push();
                pg.blendMode(blendStyle);
                pg.noStroke();
                pg.fill(col);
                pg.ellipse(pos.x, pos.y, size * 2, size * 2);
            pg.pop();
        pg.endDraw();
    }

    void delayDraw(PGraphics pg){
        pg.beginDraw();

        pg.push();
            pg.blendMode(ADD);
            for(int i = 0; i < 4; i++){
                pg.noStroke();
                pg.fill(col, map(delay - count, 0, delay, 255, 0) / 1.5);
                float delaysize = map(delay - count, 0, delay, size, size * 4);
                pg.ellipse(pos.x, pos.y, delaysize * 2 * 0.25 * i, delaysize * 2 * 0.25 * i);
            }
        pg.pop();

        pg.endDraw();
    }

    public void setVelocityFromSpeedAngle(float speed, float angle){
        vel = (new PVector(speed * cos(angle), speed * sin(angle)));
    }

    void executeCue(){
        if(cues.size() > 0){
            for(int i = 0; i < cues.size(); i++){
                ShotMoveCue cue = cues.get(i);
                if(cue.getCount() == this.count){
                    this.vel = (cue.getVel());
                    this.accel = (cue.getAccel());
                    this.col = (cue.getColor());
                }
            }
        }
    }

    void addCue(ShotMoveCue cue){
        cues.add(cue);
    }

    public int getBlendStyle(){
        return blendStyle;
    }

    public int getDelay(){
        return delay;
    }

    public boolean getHittable(){
        return isHittable;
    }

    public void setDeletable(boolean _d){
        isDeletable = _d;
    }

    public void setHittable(boolean _b){
        isHittable = _b;
    }

    public void setBlendStyle(int _s){
        blendStyle = _s;
    }
}

class ShotMoveCue{
    private int count;
    private PVector vel;
    private PVector accel;
    private color col;

    
    ShotMoveCue(int _c, PVector _v, PVector _a, int _col){
        count = _c;
        vel = _v;
        accel = _a;
        col = _col;
    }

    public int getCount(){
        return count;
    }

    public PVector getVel(){
        return vel;
    }

    public PVector getAccel(){
        return accel;
    }

    public color getColor(){
        return col;
    }
}

class RectShot extends Shot{
    float lineWeight;
    RectShot(float _x, float _y){
        super(_x, _y);
    }

    RectShot(float _x, float _y, int _delay){
        super(_x, _y, _delay);
    }

    RectShot(float _x, float _y, float speed, float angle){
        super(_x, _y, speed, angle);
    }

    void updateMe(Stage stage){
        culcLineWeight();
        super.updateMe(stage);
    }

    void shotDraw(PGraphics pg){
        pg.beginDraw();

        pg.strokeWeight(lineWeight);
        pg.stroke(col);
        pg.noFill();
        pg.push();
            pg.blendMode(getBlendStyle());
            pg.translate(pos.x, pos.y);
            pg.rotate(vel.heading() + TWO_PI / 4);
            pg.rect(0, 0, size * 2, size * 2, size / 4);
        pg.pop();

        pg.endDraw();
    }

    void delayDraw(PGraphics pg){
        pg.beginDraw();

        pg.push();
            pg.blendMode(ADD);
            pg.translate(pos.x, pos.y);
            pg.rotate(vel.heading() + TWO_PI / 4);
            for(int i = 0; i < 4; i++){
                pg.strokeWeight(lineWeight + lineWeight / 2 * i);
                pg.stroke(col, 255 / 4);
                pg.noFill();
                float delaysize = map(getDelay() - count, 0, getDelay(), size, size * 2);
                pg.rect(0, 0, delaysize * 2, delaysize * 2, delaysize / 4);
            }
        pg.pop();

        pg.endDraw();
    }

    void culcLineWeight(){
        lineWeight = size / 3;
    }
}

class LaserShot extends Shot{
    float leng = 0, wid = 0;    //長さと太さ　sizeはつかわない
    float mxLeng = 0;
    PVector apex;   //先端の位置
    PVector defPos; //初期位置

    LaserShot(float _x, float _y, float _l, float _w){
        super(_x, _y);
        defPos = new PVector(_x, _y);
        apex = new PVector(_x, _y);
        mxLeng = _l;
        wid = _w;
        setDeletable(false);
    }

    void updateMe(Stage stage){
        super.updateMe(stage);
        if(leng < mxLeng){
            leng = min(leng + vel.mag(), mxLeng);
            pos = (defPos);
        }
        apex = PVector.add(pos, PVector.mult(vel.normalize(null), leng));
    }

    void shotDraw(PGraphics pg){
        pg.beginDraw();

        pg.push();
            blendMode(getBlendStyle());
            pg.noStroke();
            pg.fill(col);
            PVector center = new PVector((apex.x + pos.x) / 2, (apex.y + pos.y) / 2);
            pg.translate(center.x, center.y);
            pg.rotate(vel.heading());
            pg.rect(0, 0, leng, wid * 2, wid / 2);
        pg.pop();

        pg.endDraw();
    }

    void delayDraw(PGraphics pg){
        pg.beginDraw();

        pg.push();
            blendMode(getBlendStyle());
            pg.noStroke();
            pg.fill(col, map(getDelay() - count, 0, getDelay(), 255, 0));
            PVector center = new PVector((apex.x + pos.x) / 2, (apex.y + pos.y) / 2);
            pg.translate(center.x, center.y);
            pg.rotate(vel.heading());
            float delaysize = map(getDelay() - count, 0, getDelay(), wid, 0);
            pg.rect(0, 0, leng, delaysize * 2, delaysize / 2);
        pg.pop();

        pg.endDraw();
    }

    boolean collision(Mover m){
        //if(lineCollision(m, apex, pos)){return true;}
        if(lineCollision2(m.pos.x, m.pos.y, m.getSize(), apex.x, apex.y, pos.x, pos.y)){print("hit");return true;}

        
        for(int i = 0; i <= m.getSize(); i++){
            
            PVector posMinusI = new PVector(apex.x + i * cos(vel.heading()), apex.y + i * sin(vel.heading()));
            PVector posPlusI = new PVector(apex.x + i * cos(vel.heading() + PI), apex.y + i * sin(vel.heading() + PI));
            PVector baseMinusI = new PVector(pos.x + i * cos(vel.heading()), pos.y + i * sin(vel.heading()));
            PVector basePlusI = new PVector(pos.x + i * cos(vel.heading() + PI), pos.y + i * sin(vel.heading() + PI));
            
            //if(lineCollision(m, posMinusI, baseMinusI)){return true;}
            //if(lineCollision(m, posPlusI, basePlusI)){return true;}
            
            if(lineCollision2(m.getX(), m.getY(), m.getSize(), posMinusI.x, posMinusI.y, baseMinusI.x, baseMinusI.y)){print("hit");return true;}
            if(lineCollision2(m.getX(), m.getY(), m.getSize(), posPlusI.x, posPlusI.y, basePlusI.x, basePlusI.y)){print("hit");return true;}
            
        }
        

        return false;
    }
    
}

class JikiRockOnShot extends Shot{
    Enemy target = null;
    float maxAngle = radians(60);
    //float accelValue = 0.5;
    int targetSelectCount = 0;

    JikiRockOnShot(float _x, float _y){
        super(_x, _y);
        vel = (new PVector(0, 0));
        accel = (new PVector(0.1, 0));
        col = (color(255, 0, 0));
        searchTarget();
    }

    void updateMe(Stage stage){
        super.updateMe(stage);
        if(target != null && !target.areYouDead()){
            homing();
        }else if(targetSelectCount < 5){
            vel = (new PVector(0, 0));
            accel = (new PVector(0, 0));
            searchTarget();
            targetSelectCount++;
        }else{
            accel = (new PVector(0.1, 0));
        }
    }
    
    void shotDraw(PGraphics pg){
        pg.beginDraw();

        pg.push();
            blendMode(getBlendStyle());
            pg.strokeWeight(2);
            pg.stroke(255);
            pg.fill(col);
            pg.ellipse(pos.x, pos.y, size * 2, size * 2);
        pg.pop();

        pg.endDraw();
    }

    void homing(){
        //ターゲットが死んでると暴走するっぽい(解決)
        //追尾が弱くて撃ち損な感じがあるので、追尾対象がなくなったら追尾対象探し直しとかするべきかと　
        float angle = new PVector(target.getX() - pos.x, target.getY() - pos.y).heading();
        if(angle > PI){
            angle = map(angle, PI, TWO_PI, -PI, 0);
        }
        if(abs(angle) > maxAngle){
            if(angle > 0){
                setVelocityFromSpeedAngle(10, maxAngle);
            }else{
                setVelocityFromSpeedAngle(10, -maxAngle);
            }
        }else{
                setVelocityFromSpeedAngle(10, angle);
        }
    }

    void setTarget(Enemy e){
        target = e;
    }

    void searchTarget(){
        println("search:" + this.targetSelectCount);
        Stage stage = playingStage;
        Enemy t = null;
        float distant = 10000;
        Iterator<Enemy> it = stage.enemys.getArray().iterator();
        while(it.hasNext()){
            Enemy e = it.next();
            float d = dist(pos.x, pos.y, e.getX(), e.getY());
            if(d < distant){
            distant = d;
            t = e;
            }
        }
        if(t != null){
            setTarget(t);
        }
    }
}

//バリヤー要素、範囲内にあるショットを確率で消す
class JikiBarrierShot extends Shot{
    JikiBarrierShot(float _x, float _y){
        super(_x, _y);
        vel = (new PVector(0, 0));
        accel = (new PVector(0, 0));
        col = (color(0, 255, 0));
        setSize(64);
        setBlendStyle(ADD);
    }

    void updateMe(Stage stage){
        super.updateMe(stage);
        if(count > 1){
            this.kill();
        }
        tamaKeshi();
    }

    void drawMe(PGraphics pg){
        pg.beginDraw();
            pg.push();

            pg.blendMode(getBlendStyle());
            pg.strokeWeight(2);
            pg.stroke(255);
            pg.fill(col, 32);
            pg.ellipse(pos.x, pos.y, size * 2, size * 2);

            pg.pop();
        pg.endDraw();
    }

    void tamaKeshi(){
        Stage stage = playingStage;
        Iterator<Shot> it = stage.enemyShots.getArray().iterator();
        while(it.hasNext()){
            Shot s = it.next();
            if(s.collision(this) == true){
                float ransu = random(100);
                if(s.isDeletable && ransu < 1){ //1%の確率でバリアに当たった弾がきえる
                    rectParticle r = new rectParticle(s.getX(), s.getY(), s.col);
                    r.baseAngle = s.getVel().heading();
                    stage.addParticle(r);
                    println("deleteshot");
                    s.kill();
                }
            }
        }
    }
}

//見た目はできたんだけどなぜか当たり判定がぬえ
class JikiBlueLaser extends Shot{
    JikiBlueLaser(float _x, float _y){
        super(_x, _y, 64);
        vel = (new PVector(10, 0));
        accel = (new PVector(0.1, 0));
        col = (color(64, 64, 128));
        setDeletable(false);
        setHittable(true);
        setBlendStyle(ADD);
    }

    void updateMe(Stage stage){
        println("blueShot");
        super.updateMe(stage);
        size = (size + 64 / (width / 10) * 2);
        if(count > width / 10){
            this.kill();
        }
        tamaKeshi();
        
    }

    void drawMe(PGraphics pg){
        println("blueShotDraw");
        pg.beginDraw();

        pg.push();
            pg.blendMode(getBlendStyle());
            super.drawMe(pg);
        pg.pop();

        pg.endDraw();
    }

    void tamaKeshi(){
        Stage stage = playingStage;
        Iterator<Shot> it = stage.enemyShots.getArray().iterator();
        while(it.hasNext()){
            Shot s = it.next();
            if(this.collision(s) == true){
                if(s.isDeletable){
                    rectParticle r = new rectParticle(s.getX(), s.getY(), s.col);
                    r.baseAngle = s.getVel().heading();
                    stage.addParticle(r);
                    println("deleteshot");
                    s.kill();
                }
            }
        }
    }
}
