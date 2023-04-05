class Shot extends Mover{
    private color col = color(255);
    private int delay = 0;
    private ArrayList<ShotMoveCue> cues;
    private boolean isDeletable = true;
    private boolean isHittable = true;

    Shot(float _x, float _y){
        super(_x, _y);
        setVel(new PVector(0, 0));
        delay = 0;
        cues = new ArrayList<ShotMoveCue>();
    }

    Shot(float _x, float _y, int _delay){
        super(_x, _y);
        setVel(new PVector(0, 0));
        delay = _delay;
        cues = new ArrayList<ShotMoveCue>();
    }

    Shot(float _x, float _y, float speed, float angle){
        super(_x, _y);
        setVel(new PVector(speed * cos(angle), speed * sin(angle)));
        delay = 0;
        cues = new ArrayList<ShotMoveCue>();
    }

    void updateMe(Stage stage){
        super.updateMe(stage);
        executeCue();
        if(getCount() < delay){
            isHittable = false;
        }else{
            isHittable = true;
        }
        if(isOutOfScreen()){
            kill();
        }
    }

    void drawMe(PGraphics pg){
        if(getCount() < delay){
            delayDraw(pg);
        }else{
            shotDraw(pg);
        }
    }

    void shotDraw(PGraphics pg){
        pg.beginDraw();
            pg.noStroke();
            pg.fill(col);
            pg.ellipse(getX(), getY(), getSize() * 2, getSize() * 2);
        pg.endDraw();
    }

    void delayDraw(PGraphics pg){
        pg.beginDraw();

        pg.push();
            pg.blendMode(ADD);
            for(int i = 0; i < 4; i++){
                pg.noStroke();
                pg.fill(col, map(delay - getCount(), 0, delay, 255, 0) / 1.5);
                float delaysize = map(delay - getCount(), 0, delay, getSize(), getSize() * 4);
                pg.ellipse(getX(), getY(), delaysize * 2 * 0.25 * i, delaysize * 2 * 0.25 * i);
            }
        pg.pop();

        pg.endDraw();
    }

    void setVelocityFromSpeedAngle(float speed, float angle){
        setVel(new PVector(speed * cos(angle), speed * sin(angle)));
    }

    void executeCue(){
        if(cues.size() > 0){
            for(int i = 0; i < cues.size(); i++){
                ShotMoveCue cue = cues.get(i);
                if(cue.getCount() == this.getCount()){
                    this.setVel(cue.getVel());
                    this.setAccel(cue.getAccel());
                    this.setColor(cue.getColor());
                }
            }
        }
    }

    void addCue(ShotMoveCue cue){
        cues.add(cue);
    }

    public color getColor(){
        return col;
    }

    public int getDelay(){
        return delay;
    }

    public boolean getHittable(){
        return isHittable;
    }

    public void setColor(color _c){
        col = _c;
    }

    public void setDeletable(boolean _d){
        isDeletable = _d;
    }

    public void setHittable(boolean _b){
        isHittable = _b;
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
        pg.stroke(getColor());
        pg.noFill();
        pg.push();
            pg.translate(getX(), getY());
            pg.rotate(getVel().heading() + TWO_PI / 4);
            pg.rect(0, 0, getSize() * 2, getSize() * 2, getSize() / 4);
        pg.pop();

        pg.endDraw();
    }

    void delayDraw(PGraphics pg){
        pg.beginDraw();

        pg.push();
            pg.blendMode(ADD);
            pg.translate(getX(), getY());
            pg.rotate(getVel().heading() + TWO_PI / 4);
            for(int i = 0; i < 4; i++){
                pg.strokeWeight(lineWeight + lineWeight / 2 * i);
                pg.stroke(getColor(), 255 / 4);
                pg.noFill();
                float delaysize = map(getDelay() - getCount(), 0, getDelay(), getSize(), getSize() * 2);
                pg.rect(0, 0, delaysize * 2, delaysize * 2, delaysize / 4);
            }
        pg.pop();

        pg.endDraw();
    }

    void culcLineWeight(){
        lineWeight = getSize() / 3;
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
            leng = min(leng + getVel().mag(), mxLeng);
            setPos(defPos);
        }
        apex = PVector.add(getPos(), PVector.mult(getVel().normalize(null), leng));
    }

    void shotDraw(PGraphics pg){
        pg.beginDraw();

        pg.push();
            //blendMode(ADD);
            pg.noStroke();
            pg.fill(getColor());
            PVector center = new PVector((apex.x + getX()) / 2, (apex.y + getY()) / 2);
            pg.translate(center.x, center.y);
            pg.rotate(getVel().heading());
            pg.rect(0, 0, leng, wid * 2, wid / 2);
        pg.pop();

        pg.endDraw();
    }

    void delayDraw(PGraphics pg){
        pg.beginDraw();

        pg.push();
            //blendMode(ADD);
            pg.noStroke();
            pg.fill(getColor(), map(getDelay() - getCount(), 0, getDelay(), 255, 0));
            PVector center = new PVector((apex.x + getX()) / 2, (apex.y + getY()) / 2);
            pg.translate(center.x, center.y);
            pg.rotate(getVel().heading());
            float delaysize = map(getDelay() - getCount(), 0, getDelay(), wid, 0);
            pg.rect(0, 0, leng, delaysize * 2, delaysize / 2);
        pg.pop();

        pg.endDraw();
    }

    boolean collision(Mover m){
        //if(lineCollision(m, apex, pos)){return true;}
        if(lineCollision2(m.getX(), m.getY(), m.getSize(), apex.x, apex.y, getX(), getY())){print("hit");return true;}

        
        for(int i = 0; i <= m.getSize(); i++){
            
            PVector posMinusI = new PVector(apex.x + i * cos(getVel().heading()), apex.y + i * sin(getVel().heading()));
            PVector posPlusI = new PVector(apex.x + i * cos(getVel().heading() + PI), apex.y + i * sin(getVel().heading() + PI));
            PVector baseMinusI = new PVector(getX() + i * cos(getVel().heading()), getY() + i * sin(getVel().heading()));
            PVector basePlusI = new PVector(getX() + i * cos(getVel().heading() + PI), getY() + i * sin(getVel().heading() + PI));
            
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
    float maxAngle = radians(120);
    float accelValue = 0.5;
    int targetSelectCount = 0;

    JikiRockOnShot(float _x, float _y){
        super(_x, _y);
        setVel(new PVector(0, 0));
        setAccel(new PVector(0.1, 0));
        setColor(color(255, 0, 0));
        searchTarget();
    }

    void updateMe(Stage stage){
        super.updateMe(stage);
        if(target != null && !target.areYouDead()){
            homing();
        }else if(targetSelectCount < 5){
            setVel(new PVector(0, 0));
            setAccel(new PVector(0, 0));
            searchTarget();
            targetSelectCount++;
        }else{
            setAccel(new PVector(0.1, 0));
        }
    }
    
    void shotDraw(PGraphics pg){
        pg.beginDraw();

        pg.push();
            //blendMode(ADD);
            pg.strokeWeight(2);
            pg.stroke(255);
            pg.fill(getColor());
            pg.ellipse(getX(), getY(), getSize() * 2, getSize() * 2);
        pg.pop();

        pg.endDraw();
    }

    void homing(){
        //ターゲットが死んでると暴走するっぽい(解決)
        //追尾が弱くて撃ち損な感じがあるので、追尾対象がなくなったら追尾対象探し直しとかするべきかと　
        float angle = new PVector(target.getX() - getX(), target.getY() - getY()).heading();
        if(angle > PI){
            angle = map(angle, PI, TWO_PI, -PI, 0);
        }
        if(abs(angle) > maxAngle){
            if(angle > 0){
                setAccel(new PVector(accelValue * cos(maxAngle), accelValue * sin(maxAngle)));
            }else{
                setAccel(new PVector(accelValue * cos(-maxAngle), accelValue * sin(-maxAngle)));
            }
        }else{
            setAccel(new PVector(accelValue * cos(angle), accelValue * sin(angle)));
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
            float d = dist(getX(), getY(), e.getX(), e.getY());
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
        setVel(new PVector(0, 0));
        setAccel(new PVector(0, 0));
        setColor(color(0, 255, 0));
        setSize(64);
    }

    void updateMe(Stage stage){
        super.updateMe(stage);
        if(getCount() > 1){
            this.kill();
        }
        tamaKeshi();
    }

    void drawMe(PGraphics pg){
        pg.beginDraw();

        pg.strokeWeight(2);
        pg.stroke(255);
        pg.fill(getColor(), 32);
        pg.ellipse(getX(), getY(), getSize() * 2, getSize() * 2);

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
        setVel(new PVector(10, 0));
        setAccel(new PVector(0.1, 0));
        setColor(color(64, 64, 128));
        setDeletable(false);
        setHittable(true);
    }

    void updateMe(Stage stage){
        println("blueShot");
        super.updateMe(stage);
        setSize(getSize() + 64 / (width / 10) * 2);
        if(getCount() > width / 10){
            this.kill();
        }
        tamaKeshi();
        
    }

    void drawMe(PGraphics pg){
        println("blueShotDraw");
        pg.beginDraw();

        pg.push();
            pg.blendMode(ADD);
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