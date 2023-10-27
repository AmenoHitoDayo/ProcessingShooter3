class Shot extends Mover{
    protected int delay = 0;
    protected List<ShotMoveCue> cues;
    protected boolean isDeletable = true;   //弾消し耐性
    protected boolean isHittable = true;    //ヒットするか（主にディレイ中に弾に当たらないようにする処理に使う）
    protected boolean isAbsorbed = false;   //吸収されたとき、直接消すのではなく弾の残骸が残るようにしたいので、それ用
    protected int blendStyle = BLEND;
    protected Mover parent = null;
    protected ShotStyle shotStyle = ShotStyle.Orb;

    Shot(float _x, float _y){
        super(_x, _y);
        vel = (new PVector(0, 0));
        delay = 15;
        cues = new ArrayList<ShotMoveCue>();
    }

    @Override
    void updateMe(){
        super.updateMe();
        executeCue();
        if(count < delay){
            isHittable = false;
        }
        isHittable = !isAbsorbed;
        if(isOutOfScreen()){
            kill();
        }
        //大きい敵を倒すと弾が消えるあれ(永夜抄)
        //画面外で死んでもなるのはよくない。
        if(parent != null && parent.isDead && !parent.isOutOfScreen()){
            Item item = new Item(pos.x, pos.y, 0, 0, 0);
            playingStage.addItem(item);
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
            RectParticle particle = new RectParticle(pos.x, pos.y, col, size * 2);
            playingStage.addParticle(particle);
        }
        super.kill();
    }

    void shotDraw(PGraphics pg){
        if(isAbsorbed){
            absorbedShotDraw(pg, this);
        }else{
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

    public void absorbed(){
        this.isAbsorbed = true;
    }

    public int getBlendStyle(){
        return blendStyle;
    }

    public boolean isHittable(){
        return isHittable;
    }

    public boolean isDeletable(){
        return isDeletable;
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
    void updateMe(){
        super.updateMe();

        if(count < waitFrame){
            radius.add(PVector.div(orbitRadius, waitFrame));
        }
        if(parent != null){
            pos = new PVector(parent.getX() + cos(angle) * radius.x, parent.getY() + sin(angle) * radius.y);
        }
        angle += spinSpd;
    }

    void setAngle(float _a){
        angle = _a;
    }
}

//炸裂して全方位弾をまき散らす
class ExplodeShot extends Shot{
    private float explodeFarme = 60;    //何F目で破裂するか
    private List<Shot> clusters;   //破裂時にまき散らす弾幕

    ExplodeShot(float _x, float _y){
        super(_x, _y);
        clusters = new ArrayList<Shot>();
        isDeletable = false;
    }

    @Override
    void updateMe(){
        super.updateMe();

        if(count >= explodeFarme){
            explosion();
            kill();
        }
    }

    @Override
    void kill(){
        super.kill();
    }

    void explosion(){
        //println("exp");
        for(Shot s: clusters){
            //println("lode");
            s.pos = s.getPos().add(this.pos); //自分の位置から出るようにする
            playingStage.addEnemyShot(s);
        }
    }

    void setCluster(List<Shot> shots){
        clusters = shots;
    }
}

class LaserShot extends Shot{
    protected float leng = 0, wid = 0;    //長さと太さ　sizeはつかわない
    protected float mxLeng = 0;
    protected PVector apex;   //先端の位置
    protected PVector defPos; //初期位置
    protected float expSpeed = 3.0f;   //1f当たりに伸びる長さ

    LaserShot(float _x, float _y, float _l, float _w){
        super(_x, _y);
        defPos = new PVector(_x, _y);
        apex = new PVector(_x, _y);
        mxLeng = _l;
        wid = _w;
        setDeletable(false);
    }

    @Override
    //レーザー伸び挙動をテストすること
    void updateMe(){
        super.updateMe();

        if(leng < mxLeng){
            if(vel.mag() == 0 && accel.mag() == 0){
                //レーザー自体が動かない場合に、伸ばせるようにしないとレーザーがでん
                //なのでこれないと設置型レーザーできないとおも
                expSpeed = 3.0f;
            }else{
                expSpeed = vel.mag();
            }
            leng = min(leng + expSpeed, mxLeng);
            pos = (defPos);
        }
        apex = PVector.add(pos, PVector.mult(vel.normalize(null), leng));
    }

    @Override
    void shotDraw(PGraphics pg){
        pg.beginDraw();

        pg.push();
            pg.blendMode(blendStyle);
            pg.noStroke();
            pg.fill(col);
            //pg.ellipse(pos.x, pos.y, wid * 3, wid * 3);
            //pg.ellipse(apex.x, apex.y, wid * 3, wid * 3);
            PVector center = new PVector((apex.x + pos.x) / 2, (apex.y + pos.y) / 2);
            pg.translate(center.x, center.y);
            pg.rotate(vel.heading());
            pg.rect(0, 0, leng, wid * 2, wid / 2);
        pg.pop();

        
        /*
        //当たり判定確認用
        
        pg.strokeWeight(1);
        pg.stroke(0);
        pg.fill(255, 32);
        float angle = vel.heading();
        //なんかいfor文を回すか
        int kurikaeshi = floor((leng - wid) / wid);
        for(int i = 1; i <= kurikaeshi; i++){
            //円判定の位置(ケツ+)
            PVector pos2 = new PVector(pos.x + wid * i * cos(angle), pos.y + wid * i * sin(angle));
        pg.ellipse(pos2.x, pos2.y, wid * 2, wid * 2);
        }
        PVector pos3 = new PVector(apex.x + wid * cos(angle - PI), apex.y + wid * sin(angle - PI));
        pg.ellipse(pos3.x, pos3.y, wid * 2, wid * 2);
        */
        

        pg.endDraw();
    }

    @Override
    void delayDraw(PGraphics pg){
        pg.beginDraw();

        pg.push();
            pg.blendMode(blendStyle);
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
        //レーザーの頭からケツまで円判定を敷き詰めるやりかた

        float angle = vel.heading();
        //なんかいfor文を回すか
        int kurikaeshi = floor((leng - wid) / wid);
        for(int i = 1; i <= kurikaeshi; i++){
            //円判定の位置(ケツ+)
            PVector pos2 = new PVector(pos.x + wid * i * cos(angle), pos.y + wid * i * sin(angle));
            float d = dist(pos2.x, pos2.y, m.pos.x, m.pos.y);
            if(d < size + m.size){
                return true;
            }
        }
        PVector pos3 = new PVector(apex.x + wid * cos(angle - PI), apex.y + wid * sin(angle - PI));
        float d = dist(pos3.x, pos3.y, m.pos.x, m.pos.y);
            if(d < size + m.size){
                return true;
            }
        return false;

    /*
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
        */
    }
    
}

/*
class JikiShot extends Shot{
    protected int damage = 1;
}
*/
class JikiRedShot extends Shot{
    JikiRedShot(float _x, float _y){
        super(_x, _y);
        size = 8;
        delay = 0;
        col = color(255, 0, 0);
        vel = new PVector(4, 0);
    }

    @Override
    void shotDraw(PGraphics pg){
        pg.beginDraw();

            pg.noStroke();
            pg.fill(col);
            easyTriangle(pg, pos.x, pos.y, this.getAngle(), size);

        pg.endDraw();
    }
}

class JikiGreenShot extends Shot{
    JikiGreenShot(float _x, float _y){
        super(_x, _y);
        size = 8;
        delay = 0;
        col = color(0, 255, 0);
        vel = new PVector(4, 0);
    }

    @Override
    void shotDraw(PGraphics pg){
        pg.beginDraw();

            pg.noStroke();
            pg.fill(col);
            easyTriangle(pg, pos.x, pos.y, this.getAngle(), size);

        pg.endDraw();
    }
}

class JikiBlueShot extends Shot{
    JikiBlueShot(float _x, float _y){
        super(_x, _y);
        size = 8;
        delay = 0;
        col = color(0, 0, 255);
        vel = new PVector(4, 0);
    }

    @Override
    void shotDraw(PGraphics pg){
        pg.beginDraw();

            pg.noStroke();
            pg.fill(col);
            easyTriangle(pg, pos.x, pos.y, this.getAngle(), size);

        pg.endDraw();
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
        col = (color(0, 0, 255));
        searchTarget();
    }

    @Override
    void updateMe(){
        super.updateMe();
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
        //println("search:" + this.targetSelectCount);
        Enemy t = null;
        float distant = 10000;
        Iterator<Mover> it = playingStage.enemys.getArray().iterator();
        while(it.hasNext()){
            Mover m = it.next();
            if(!(m instanceof Enemy))continue;
            Enemy e = (Enemy)m;
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
    void updateMe(){
        super.updateMe();
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
        
        Iterator<Mover> it = playingStage.getEnemyShots().iterator();
        while(it.hasNext()){
            Mover m = it.next();
            if(!(m instanceof Shot))continue;
            Shot s = (Shot)m;
            if(s.collision(this) == true){
                float ransu = random(100);
                if(s.isDeletable && ransu < 1){ //1%の確率でバリアに当たった弾がきえる
                    //println("deleteshot");
                    s.kill();
                }
            }
        }
        
    }
}

//青ﾊﾟﾜ弾　敵弾を搔き消せる
class JikiBlueLaser extends Shot{
    JikiBlueLaser(float _x, float _y){
        super(_x, _y);
        this.setDelay(64);
        vel = (new PVector(10, 0));
        accel = (new PVector(0.1, 0));
        col = (color(64, 64, 255, 180));
        setDeletable(false);
        setHittable(true);
        setBlendStyle(BLEND);
    }

    @Override
    void updateMe(){
        super.updateMe();
        size = min((size + 64 / (width / 10) * 2), 64);
        if(count > width / 10){
            this.kill();
        }
        tamaKeshi();
    }

    @Override
    void drawMe(PGraphics pg){
        //println("blueShotDraw");
        super.drawMe(pg);
    }

    void tamaKeshi(){
        
        Iterator<Mover> it = playingStage.getEnemyShots().iterator();
        while(it.hasNext()){
            Mover m = it.next();
            if(!(m instanceof Shot))continue;
            Shot s = (Shot)m;
            if(this.collision(s) == true && s.isDeletable){
                //println("deleteshot");
                s.kill();
            }
        }
        
    }
}
