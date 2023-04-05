class Particle extends Mover{
    private int lifeTime = 10;
    Particle(float _x, float _y, color _c){
        super(_x, _y);
        setColor(_c);
    }

    public float getLifeTime(){
        return lifeTime;
    }
}

class rectParticle extends Particle{
    private float baseAngle = 0;
    rectParticle(float _x, float _y, color _c){
        super(_x, _y, _c);
        setSize(16);
    }
    
    void drawMe(PGraphics pg){
        pg.beginDraw();

        this.setSize(getSize() + 32 / getLifeTime());

        pg.push();
            pg.blendMode(ADD);
            pg.noFill();
            pg.strokeWeight(5);
            pg.stroke(getColor(), 255 - (190 / getLifeTime()) * getCount());
            pg.translate(getX(), getY());
            pg.rotate(baseAngle + radians(getCount() * 2 + 45));
            pg.rect(0, 0, getSize() + getCount(), getSize() + getCount());
        pg.pop();

        pg.endDraw();
    }
}

class circleParticle extends Particle{
    private float baseAngle = 0;
    circleParticle(float _x, float _y, color _c){
        super(_x, _y, _c);
        setSize(16);
    }
    
    void drawMe(PGraphics pg){
        pg.beginDraw();

        this.setSize(getSize() + 32 / getLifeTime());

        pg.push();
            pg.blendMode(ADD);
            pg.noFill();
            pg.strokeWeight(5);
            pg.stroke(getColor(), 255 - (190 / getLifeTime()) * getCount());
            pg.ellipse(getX(), getY(), getSize() + getCount(), getSize() + getCount());
        pg.pop();

        pg.endDraw();
    }
}
