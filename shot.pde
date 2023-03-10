class Shot extends Mover{
    color col = color(255);
    int delay = 0;

    Shot(float _x, float _y){
        super(_x, _y);
        vel = new PVector(0, 0);
        delay = 0;
    }

    Shot(float _x, float _y, int _delay){
        super(_x, _y);
        vel = new PVector(0, 0);
        delay = _delay;
    }

    Shot(float _x, float _y, float speed, float angle){
        super(_x, _y);
        vel = new PVector(speed * cos(angle), speed * sin(angle));
        delay = 0;
    }

    void updateMe(){
        super.updateMe();
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
}

class rectShot extends Shot{
    rectShot(float _x, float _y){
        super(_x, _y);
    }

    rectShot(float _x, float _y, int _delay){
        super(_x, _y, _delay);
    }

    rectShot(float _x, float _y, float speed, float angle){
        super(_x, _y, speed, angle);
    }

    void shotDraw(){
        strokeWeight(2);
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
                strokeWeight(2 + 1 * i);
                stroke(col, 255 / 4);
                noFill();
                float delaysize = map(delay - count, 0, delay, size, size * 2);
                rect(0, 0, delaysize * 2, delaysize * 2, delaysize / 4);
            }
        pop();
    }
}