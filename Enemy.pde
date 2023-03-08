class Enemy extends Machine{
    Enemy(float _x, float _y){
        super(_x, _y);
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
        super(width, height / 2);
        col = color(255, 0, 0);
        vel = new PVector(-1, 0);
        size = 16;
        HP = 10;
    }

    void Shot(Stage s){
        if(count % 60 == 0 && count != 0){
            for(int i = 0; i < 12; i++){
                Shot shot = new Shot(pos.x, pos.y, 1, TWO_PI / 12 * i);
                shot.size = 16;
                shot.col = color(255, 0, 0);
                s.enemyShots.addShot(shot);
            }
        }
    }
}