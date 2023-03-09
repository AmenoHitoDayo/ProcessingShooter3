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
    SampleEnemy(){
        super(width, height / 2, 10);
        col = color(255, 0, 0);
        vel = new PVector(-1, 0);
        size = 16;
    }

    void Shot(Stage s){
        if(count % 60 == 0 && count != 0){
            for(int i = 0; i < 12; i++){
                Shot shot = new Shot(pos.x, pos.y, 1, TWO_PI / 12 * i);
                shot.size = 8;
                shot.col = HSVtoRGB(random(360), 255, 255);
                s.enemyShots.addShot(shot);
            }
        }
    }
}