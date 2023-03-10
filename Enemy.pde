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

    SampleEnemy(){
        super(width, height / 2, 10);
        col = color(255, 0, 0);
        vel = new PVector(-1, 0);
        size = 16;
    }

    void Shot(Stage s){
        if(count % 10 == 0 && count != 0){
            for(int i = 0; i < way; i++){
                Shot shot = new Shot(pos.x, pos.y, 2, radians(angle) + TWO_PI / way * i);
                shot.size = 6;
                shot.col = HSVtoRGB(random(360), 255, 255);
                s.enemyShots.addShot(shot);
            }
            angle += rotation;
            rotation += 0.1;
        }
    }
}