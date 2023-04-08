class Shot extends Mover{
    protected int delay = 0;
    protected ArrayList<ShotMoveCue> cues;
    protected boolean isDeletable = true;
    protected boolean isHittable = true;
    protected int blendStyle = BLEND;
    protected Mover parent = null;
    protected ShotStyle shotStyle = ShotStyle.Orb;

    Shot(float _x, float _y){
        super(_x, _y);
        vel = (new PVector(0, 0));
        delay = 15;
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
        setVelocityFromSpeedAngle(speed, angle);
        delay = 0;
        cues = new ArrayList<ShotMoveCue>();
    }

    @Override
    void updateMe(Stage _s){
        super.updateMe(_s);
        executeCue();
        if(count < delay){
            isHittable = false;
        }else{
            isHittable = true;
        }
        if(isOutOfScreen()){
            kill();
        }
        //大きい敵を倒すと弾が消えるあれ
        //画面外で死んでもなるのはよくない。
        if(parent != null && parent.isDead && !parent.isOutOfScreen()){
            Item item = new Item(pos.x, pos.y, 0, 0, 0);
            stage.addItem(item);

            kill();
        }
    }

    @Override
    void drawMe(PGraphics pg){
        if(count < delay){
            delayDraw(pg);
        }else{
            shotDraw(pg);
        }
    }

    @Override
    void kill(){
        if(!isOutOfScreen()){
            rectParticle particle = new rectParticle(pos.x, pos.y, col);
            stage.addParticle(particle);
        }
        super.kill();
    }

    void shotDraw(PGraphics pg){
        switch(shotStyle){
            case Orb:
                orbShotDraw(pg, this);
            break;
            case Oval:
                ovalShotDraw(pg, this);
            break;
            case Rect:
                rectShotDraw(pg, this);
            break;
            case Glow:
                glowShotDraw(pg, this);
            break;
            default:
                orbShotDraw(pg, this);
            break;
        }
    }

    void delayDraw(PGraphics pg){
        switch(shotStyle){
            case Rect:
                rectDelayDraw(pg, this);
            break;
            default:
                orbDelayDraw(pg, this);
            break;
        }
    }

    public void setVelocityFromSpeedAngle(float speed, float angle){
        vel = (new PVector(speed * cos(angle), speed * sin(angle)));
    }

    public void setAccelerationFromAccelAngle(float acc, float angle){
        accel = (new PVector(acc * cos(angle), acc * sin(angle)));
    }

    void executeCue(){
        if(cues.size() > 0){
            for(int i = 0; i < cues.size(); i++){
                ShotMoveCue cue = cues.get(i);
                if(cue.getCount() == count){
                    this.vel = (cue.getVel());
                    this.accel = (cue.getAccel());
                    this.rotation = (cue.getRotation());
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

    public boolean isHittable(){
        return isHittable;
    }

    public int getDelay(){
        return delay;
    }

    public void setDelay(int _d){
        delay = _d;
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

    public void setShotStyle(ShotStyle _s){
        shotStyle = _s;
    }
}

class ShotMoveCue{
    private int count;
    private PVector vel;
    private PVector accel;
    private float rotation;
    private color col;

    
    ShotMoveCue(int _c, PVector _v, PVector _a, float _r, int _col){
        count = _c;
        vel = _v;
        accel = _a;
        rotation = _r;
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

    public float getRotation(){
        return rotation;
    }

    public color getColor(){
        return col;
    }
}

class OrbitShot extends Shot{
    //楕円回転もあるよ
    PVector orbitRadius = new PVector(70, 100);
    PVector radius = new PVector(0, 0);
    int waitFrame = 60;     //最大回転半径に到達するまで
    float angle = 0f;
    float spinSpd = radians(3);

    OrbitShot(float _x, float _y){
        super(_x, _y);
    }

    @Override
    void updateMe(Stage _s){
        super.updateMe(_s);

        if(count < waitFrame){
            radius.add(PVector.div(orbitRadius, waitFrame));
        }
        pos = new PVector(parent.getX() + cos(angle) * radius.x, parent.getY() + sin(angle) * radius.y);
        angle += spinSpd;
    }
}

class LaserShot extends Shot{
    private float leng = 0, wid = 0;    //長さと太さ　sizeはつかわない
    private float mxLeng = 0;
    private PVector apex;   //先端の位置
    private PVector defPos; //初期位置

    LaserShot(float _x, float _y, float _l, float _w){
        super(_x, _y);
        defPos = new PVector(_x, _y);
        apex = new PVector(_x, _y);
        mxLeng = _l;
        wid = _w;
        setDeletable(false);
    }

    @Override
    void updateMe(Stage _s){
        super.updateMe(_s);
        if(leng < mxLeng){
            leng = min(leng + vel.mag(), mxLeng);
            pos = (defPos);
        }
        apex = PVector.add(pos, PVector.mult(vel.normalize(null), leng));
    }

    @Override
    void shotDraw(PGraphics pg){
        pg.beginDraw();

        pg.push();
            blendMode(blendStyle);
            pg.noStroke();
            pg.fill(col);
            PVector center = new PVector((apex.x + pos.x) / 2, (apex.y + pos.y) / 2);
            pg.translate(center.x, center.y);
            pg.rotate(vel.heading());
            pg.rect(0, 0, leng, wid * 2, wid / 2);
        pg.pop();

        pg.endDraw();
    }

    @Override
    void delayDraw(PGraphics pg){
        pg.beginDraw();

        pg.push();
            blendMode(blendStyle);
            pg.noStroke();
            pg.fill(col, map(delay - count, 0, delay, 255, 0));
            PVector center = new PVector((apex.x + pos.x) / 2, (apex.y + pos.y) / 2);
            pg.translate(center.x, center.y);
            pg.rotate(vel.heading());
            float delaysize = map(delay - count, 0, delay, wid, 0);
            pg.rect(0, 0, leng, delaysize * 2, delaysize / 2);
        pg.pop();

        pg.endDraw();
    }

    @Override
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
    float maxAngle = radians(120);
    //float accelValue = 0.5;
    int targetSelectCount = 0;

    JikiRockOnShot(float _x, float _y){
        super(_x, _y);
        vel = (new PVector(0, 0));
        accel = (new PVector(0.1, 0));
        col = (color(255, 0, 0));
        searchTarget();
    }

    @Override
    void updateMe(Stage _s){
        super.updateMe(_s);
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
    
    @Override
    void shotDraw(PGraphics pg){
        pg.beginDraw();

        pg.push();
            blendMode(blendStyle);
            pg.strokeWeight(2);
            pg.stroke(255);
            pg.fill(col);
            pg.ellipse(pos.x, pos.y, size * 2, size * 2);
        pg.pop();

        pg.endDraw();
    }

    void homing(){
        //ターゲットが死んでると暴走するっぽい(解決...?)
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
        col = (color(0, 0));    //削除パーティクルが出るのが困るから透明色にするらしい。なんと雑な
        setSize(64);
        setBlendStyle(ADD);
    }

    @Override
    void updateMe(Stage _s){
        super.updateMe(_s);
        if(count > 1){
            this.kill();
        }
        tamaKeshi();
    }

    @Override
    void drawMe(PGraphics pg){
        pg.beginDraw();
            pg.push();

            pg.blendMode(blendStyle);
            pg.strokeWeight(2);
            pg.stroke(255);
            pg.fill(0, 255, 0, 32);
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
                    println("deleteshot");
                    s.kill();
                }
            }
        }
    }
}

//青ﾊﾟﾜ弾　敵弾を搔き消せる
class JikiBlueLaser extends Shot{
    JikiBlueLaser(float _x, float _y){
        super(_x, _y, 64);
        vel = (new PVector(10, 0));
        accel = (new PVector(0.1, 0));
        col = (color(64, 64, 255, 180));
        setDeletable(false);
        setHittable(true);
        setBlendStyle(BLEND);
    }

    @Override
    void updateMe(Stage _s){
        super.updateMe(_s);
        size = min((size + 64 / (width / 10) * 2), 64);
        if(count > width / 10){
            this.kill();
        }
        tamaKeshi();
        
    }

    @Override
    void drawMe(PGraphics pg){
        println("blueShotDraw");
        super.drawMe(pg);
    }

    void tamaKeshi(){
        Stage stage = playingStage;
        Iterator<Shot> it = stage.getEnemyShots().iterator();
        while(it.hasNext()){
            Shot s = it.next();
            if(this.collision(s) == true && s.isDeletable){
                println("deleteshot");
                s.kill();
            }
        }
    }
}
