class Enemy extends Machine{
    Enemy(float _x, float _y, int _HP){
        super(_x, _y, _HP);
    }

    void updateMe(){
        super.updateMe();
    }

    void drawMe(){
        super.drawMe();
    }

    void Shot(Stage s){

    }
}

class SampleEnemy extends Enemy{
    float angle = 0;
    float rotation = 0;
    int way = 4;
    float hue = 0;

    SampleEnemy(){
        super(width, height / 2, 10);
        vel = new PVector(-1, 0);
        size = 16;
        hue = random(360);
        col = HSVtoRGB(hue, 255, 255);
    }

    void Shot(Stage s){
        if(count % 5 == 0 && count != 0){
            for(int i = 0; i < way; i++){
                rectShot shot = new rectShot(pos.x, pos.y, 15);
                shot.setVelocity(1.75, radians(angle) + TWO_PI / way * i);
                shot.size = 6;
                shot.col = HSVtoRGB(hue, 255 - 32, 255);
                MoveCue cue = new MoveCue(60, 
                    PVector.mult(shot.vel, 4),
                    new PVector(0, 0),
                    HSVtoRGB(hue, 255, 255));
                shot.addCue(cue);
                s.enemyShots.addShot(shot);
            }
            angle += rotation;
            rotation += 0.1;
            hue = (hue + 0.5) % 360;
        }
    }
}