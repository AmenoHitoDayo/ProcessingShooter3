class Shot extends Mover{
    color col = color(255);
    int delay = 0;
    ArrayList<ShotMoveCue> cues;
    boolean isDeletable = true;
    boolean isHittable = true;
    boolean isDeleted = false;

    Shot(float _x, float _y){
        super(_x, _y);
        vel = new PVector(0, 0);
        delay = 0;
        cues = new ArrayList<ShotMoveCue>();
    }

    Shot(float _x, float _y, int _delay){
        super(_x, _y);
        vel = new PVector(0, 0);
        delay = _delay;
        cues = new ArrayList<ShotMoveCue>();
    }

    Shot(float _x, float _y, float speed, float angle){
        super(_x, _y);
        vel = new PVector(speed * cos(angle), speed * sin(angle));
        delay = 0;
        cues = new ArrayList<ShotMoveCue>();
    }

    void updateMe(){
        super.updateMe();
        executeCue();
        if(count < delay){
            isHittable = false;
        }else{
            isHittable = true;
        }

        if(pos.x < 0 - size || pos.x > width + size || pos.y < 0 - size || pos.y > height + size){
            isDeleted = true;
        }
    }

    void drawMe(){
        if(count < delay){
            delayDraw();
        }else{
            shotDraw();
        }
    }

    void shotDraw(){
        noStroke();
        fill(col);
        ellipse(pos.x, pos.y, size * 2, size * 2);
    }

    void delayDraw(){
        push();
            blendMode(ADD);
            for(int i = 0; i < 4; i++){
                noStroke();
                fill(col, map(delay - count, 0, delay, 255, 0) / 1.5);
                float delaysize = map(delay - count, 0, delay, size, size * 4);
                ellipse(pos.x, pos.y, delaysize * 2 * 0.25 * i, delaysize * 2 * 0.25 * i);
            }
        pop();
    }

    void setVelocity(float speed, float angle){
        vel = new PVector(speed * cos(angle), speed * sin(angle));
    }

    void executeCue(){
        if(cues.size() > 0){
            for(int i = 0; i < cues.size(); i++){
                ShotMoveCue cue = cues.get(i);
                if(cue.count == this.count){
                    this.vel = cue.vel;
                    this.accel = cue.accel;
                    this.col = cue.col;
                }
            }
        }
    }

    void addCue(ShotMoveCue cue){
        cues.add(cue);
    }
}

class ShotMoveCue{
    int count;
    PVector vel;
    PVector accel;
    color col;

    
    ShotMoveCue(int _c, PVector _v, PVector _a, int _col){
        count = _c;
        vel = _v;
        accel = _a;
        col = _col;
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

    void updateMe(){
        culcLineWeight();
        super.updateMe();
    }

    void shotDraw(){
        strokeWeight(lineWeight);
        stroke(col);
        noFill();
        push();
            translate(pos.x, pos.y);
            rotate(vel.heading() + TWO_PI / 4);
            rect(0, 0, size * 2, size * 2, size / 4);
        pop();
    }

    void delayDraw(){
        push();
            blendMode(ADD);
            translate(pos.x, pos.y);
            rotate(vel.heading() + TWO_PI / 4);
            for(int i = 0; i < 4; i++){
                strokeWeight(lineWeight + lineWeight / 2 * i);
                stroke(col, 255 / 4);
                noFill();
                float delaysize = map(delay - count, 0, delay, size, size * 2);
                rect(0, 0, delaysize * 2, delaysize * 2, delaysize / 4);
            }
        pop();
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
        isDeletable = false;
    }

    void updateMe(){
        super.updateMe();
        if(leng < mxLeng){
            leng = min(leng + vel.mag(), mxLeng);
            pos = defPos;
        }
        apex = PVector.add(pos, PVector.mult(vel.normalize(null), leng));
    }

    void shotDraw(){
        /*
        strokeWeight(wid);
        stroke(col);
        line(apex.x, apex.y, pos.x, pos.y);
        */
        push();
            //blendMode(ADD);
            noStroke();
            fill(col);
            PVector center = new PVector((apex.x + pos.x) / 2, (apex.y + pos.y) / 2);
            translate(center.x, center.y);
            rotate(vel.heading());
            rect(0, 0, leng, wid * 2, wid / 2);
        pop();
    }

    void delayDraw(){
        push();
            //blendMode(ADD);
            noStroke();
            fill(col, map(delay - count, 0, delay, 255, 0));
            PVector center = new PVector((apex.x + pos.x) / 2, (apex.y + pos.y) / 2);
            translate(center.x, center.y);
            rotate(vel.heading());
            float delaysize = map(delay - count, 0, delay, wid, 0);
            rect(0, 0, leng, delaysize * 2, delaysize / 2);
        pop();
    }

    boolean collision(Mover m){
        //if(lineCollision(m, apex, pos)){return true;}
        if(lineCollision2(m.pos.x, m.pos.y, m.size, apex.x, apex.y, pos.x, pos.y)){print("hit");return true;}

        
        for(int i = 0; i <= m.size; i++){
            
            PVector posMinusI = new PVector(apex.x + i * cos(vel.heading()), apex.y + i * sin(vel.heading()));
            PVector posPlusI = new PVector(apex.x + i * cos(vel.heading() + PI), apex.y + i * sin(vel.heading() + PI));
            PVector baseMinusI = new PVector(pos.x + i * cos(vel.heading()), pos.y + i * sin(vel.heading()));
            PVector basePlusI = new PVector(pos.x + i * cos(vel.heading() + PI), pos.y + i * sin(vel.heading() + PI));
            
            //if(lineCollision(m, posMinusI, baseMinusI)){return true;}
            //if(lineCollision(m, posPlusI, basePlusI)){return true;}
            
            if(lineCollision2(m.pos.x, m.pos.y, m.size, posMinusI.x, posMinusI.y, baseMinusI.x, baseMinusI.y)){print("hit");return true;}
            if(lineCollision2(m.pos.x, m.pos.y, m.size, posPlusI.x, posPlusI.y, basePlusI.x, basePlusI.y)){print("hit");return true;}
            
        }
        

        return false;
    }
    
}

class JikiRockOnShot extends Shot{
    Enemy target = null;
    float maxAngle = radians(30);
    float accelValue = 0.25;

    JikiRockOnShot(float _x, float _y){
        super(_x, _y);
        vel = new PVector(0, 0);
        accel = new PVector(0.1, 0);
        col = color(255, 0, 0);
    }

    void updateMe(){
        super.updateMe();
        if(target != null && !target.isDead){
            homing();
        }
    }
    
    void shotDraw(){
        push();
            //blendMode(ADD);
            strokeWeight(2);
            stroke(255);
            fill(col);
            ellipse(pos.x, pos.y, size * 2, size * 2);
        pop();
    }

    void homing(){
        //ターゲットが死んでると暴走するっぽい(解決)
        //追尾が弱くて撃ち損な感じがあるので、追尾対象がなくなったら追尾対象探し直しとかするべきかと　
        float angle = new PVector(target.pos.x - pos.x, target.pos.y - pos.y).heading();
        if(angle > PI){
            angle = map(angle, PI, TWO_PI, -PI, 0);
        }
        if(abs(angle) > maxAngle){
            if(angle > 0){
                accel = new PVector(accelValue * cos(maxAngle), accelValue * sin(maxAngle));
            }else{
                accel = new PVector(accelValue * cos(-maxAngle), accelValue * sin(-maxAngle));
            }
        }else{
            accel = new PVector(accelValue * cos(angle), accelValue * sin(angle));
        }
    }

    void setTarget(Enemy e){
        target = e;
    }
}

//バリヤー要素、範囲内にあるショットを確率で消す
class JikiBarrierShot extends Shot{
    JikiBarrierShot(float _x, float _y){
        super(_x, _y);
        vel = new PVector(0, 0);
        accel = new PVector(0, 0);
        col = color(0, 255, 0);
        size = 64;
    }

    void updateMe(){
        super.updateMe();
        if(count > 1){
            isDeleted = true;
        }
        deleteShot();
    }

    void drawMe(){
        strokeWeight(2);
        stroke(255);
        fill(col, 32);
        ellipse(pos.x, pos.y, size * 2, size * 2);
    }

    void deleteShot(){
        Stage stage = playingStage;
        Iterator<Shot> it = stage.enemyShots.getShots().iterator();
        while(it.hasNext()){
            Shot s = it.next();
            if(s.collision(this) == true){
                float ransu = random(100);
                if(s.isDeletable && ransu < 1){ //1%の確率でバリアに当たった弾がきえる
                    println("deleteshot");
                    s.isDeleted = true;
                }
            }
        }
    }
}

//見た目はできたんだけどなぜか当たり判定がぬえ
class JikiBlueLaser extends LaserShot{
    JikiBlueLaser(float _x, float _y){
        super(_x, _y, width, 16);
        vel = new PVector(10, 0);
        accel = new PVector(0.1, 0);
        col = color(64, 64, 255, 64);
        delay = 0;
    }

    void updateMe(){
        super.updateMe();
        wid += 64 / (width / 10) * 2;
        if(count > width / 10){
            isDeleted = true;
        }
        if(isHittable){
            deleteShot();
        }
    }

    void drawMe(){
        push();
            blendMode(ADD);
            super.drawMe();
        pop();
    }

    void deleteShot(){
        Stage stage = playingStage;
        Iterator<Shot> it = stage.enemyShots.getShots().iterator();
        while(it.hasNext()){
            Shot s = it.next();
            if(this.collision(s) == true){
                if(s.isDeletable){
                    println("deleteshot");
                    s.isDeleted = true;
                }
            }
        }
    }
}