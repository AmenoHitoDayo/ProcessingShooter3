class Particle extends Mover{
    protected int lifeTime = 10;
    Particle(float _x, float _y, color _c){
        super(_x, _y);
        col =(_c);
    }
    
    @Override
    void updateMe(){
        super.updateMe();
        if(lifeTime != 0 && count > lifeTime){kill();}
    }
    
    public int getLifeTime(){
        return lifeTime;
    }
}

class RectParticle extends Particle{
    private float baseAngle = 0;
    private float maxSize;
    RectParticle(float _x, float _y, color _c, float _s){
        super(_x, _y, _c);
        size = _s;
        maxSize = size * 2;
    }
    
    @Override 
    void drawMe(PGraphics pg){
        pg.beginDraw();

        this.size =(size + maxSize / lifeTime);

        pg.push();
            if(gameConfig.isGlow){
                pg.blendMode(ADD);
                pg.stroke(col, 255 - (190 / lifeTime) * count);
            }else{
                pg.stroke(col);
            }
            pg.noFill();
            pg.strokeWeight(5);
            pg.translate(pos.x, pos.y);
            pg.rotate(baseAngle + radians(count * 2 + 45));
            pg.rect(0, 0, size + count, size + count);
        pg.pop();

        pg.endDraw();
    }
}

class CircleParticle extends Particle{
    private float baseAngle = 0;
    private float maxSize;
    CircleParticle(float _x, float _y, color _c, float _s){
        super(_x, _y, _c);
        size = _s;
        maxSize = size * 2;
    }
    
    @Override 
    void drawMe(PGraphics pg){
        pg.beginDraw();

        this.size =(size + maxSize / lifeTime);

        pg.push();
            if(gameConfig.isGlow){
                pg.blendMode(ADD);
                pg.stroke(col, 255 - (190 / lifeTime) * count);
            }else{
                pg.stroke(col);
            }
            pg.noFill();
            pg.strokeWeight(5);
            pg.ellipse(pos.x, pos.y, size + count, size + count);
        pg.pop();

        pg.endDraw();
    }
}

class GlowBallParticle extends Particle{
    GlowBallParticle(float _x, float _y){
        super(_x, _y, HSVtoRGB(random(360), 255, 255));
        size = random(10, 100);
        vel = new PVector(random(-0.25, 0.25), random(1));
        lifeTime = 0;
    }

    @Override
    void updateMe(){
        super.updateMe();
        size -= 0.01;
        if(count > 60 && (size <= 0 || isOutOfScreen()))kill();
    }

    @Override
    void drawMe(PGraphics pg){
        if(gameConfig.isGlow){
            pg.beginDraw();
                pg.push();
                pg.blendMode(SCREEN);
                for(int i = 0; i < 10; i++){
                    pg.fill(col, 10);
                    pg.noStroke();
                    pg.ellipse(pos.x, pos.y, size * pow(0.95, i), size * pow(0.95, i));
                }
                pg.pop();
            pg.endDraw();
        }else{
            /*
            pg.beginDraw();
                pg.push();
                pg.blendMode(BLEND);
                    pg.fill(col);
                    pg.noStroke();
                    pg.circle(pos.x, pos.y, size);
                pg.pop();
            pg.endDraw();
            */
        }
    }
}
