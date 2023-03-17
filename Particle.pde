class Particle extends Mover{
    int lifeTime = 10;
    color col;
    float baseAngle = 0;
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
    
    void drawMe(PGraphics pg){
        pg.beginDraw();

        size += 32 / lifeTime;

        pg.push();
            pg.blendMode(ADD);
            pg.noFill();
            pg.strokeWeight(5);
            pg.stroke(col, 255 - (190 / lifeTime) * count);
            pg.translate(pos.x, pos.y);
            pg.rotate(baseAngle + radians(count * 2 + 45));
            pg.rect(0, 0, size + count, size + count);
        pg.pop();

        pg.endDraw();
    }
}
