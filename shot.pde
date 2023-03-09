class Shot extends Mover{
    color col = color(255);

    Shot(float _x, float _y){
        super(_x, _y);
        vel = new PVector(0, 0);
    }

    Shot(float _x, float _y, float speed, float angle){
        super(_x, _y);
        vel = new PVector(speed * cos(angle), speed * sin(angle));
    }

    void updateMe(){
        super.updateMe();
        vel.add(accel);
    }

    void drawMe(){
        noStroke();
        fill(col);
        ellipse(pos.x, pos.y, size * 2, size * 2);
    }

    boolean collision(Machine m){
        float d = dist(pos.x, pos.y, m.pos.x, m.pos.y);
        if(d < (size + m.size)){
            return true;
        }else{
            return false;
        }
    }
}