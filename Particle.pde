class Particle extends Mover{
    protected int lifeTime = 10;
    Particle(float _x, float _y, color _c){
        super(_x, _y);
        setColor(_c);
    }
}

class rectParticle extends Particle{
    private float baseAngle = 0;
    rectParticle(float _x, float _y, color _c){
        super(_x, _y, _c);
        setSize(12);
    }
    
    void drawMe(PGraphics pg){
        pg.beginDraw();

        this.setSize(size + 32 / lifeTime);

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

class circleParticle extends Particle{
    private float baseAngle = 0;
    circleParticle(float _x, float _y, color _c){
        super(_x, _y, _c);
        setSize(24);
    }
    
    void drawMe(PGraphics pg){
        pg.beginDraw();

        this.setSize(size + 32 / lifeTime);

        pg.push();
            pg.blendMode(ADD);
            pg.noFill();
            pg.strokeWeight(5);
            pg.stroke(col, 255 - (190 / lifeTime) * count);
            pg.ellipse(pos.x, pos.y, size + count, size + count);
        pg.pop();

        pg.endDraw();
    }
}
