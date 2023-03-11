class Particle extends Mover{
    int lifeTime = 10;
    color col;
    Particle(float _x, float _y, color _c){
        super(_x, _y);
        col = _c;
    }
}

class rectParticle extends Particle{
    rectParticle(float _x, float _y, color _c){
        super(_x, _y, _c);
        size = 16;
    }
    
    void drawMe(){
        size += 32 / lifeTime;
        push();
        noFill();
        strokeWeight(5);
        stroke(col, 255 - (190 / lifeTime) * count);
        translate(pos.x, pos.y);
        rotate(radians(count * 2 + 45));
        rect(0, 0, size + count, size + count);
        pop();
    }
}
