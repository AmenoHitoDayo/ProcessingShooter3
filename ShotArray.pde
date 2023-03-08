class Shots{
    ArrayList<Shot> Shots;

    Shots(){
        Shots = new ArrayList<Shot>();
    }

    void updateMe(){
        Iterator<Shot> it = Shots.iterator();
        while(it.hasNext()){
            Shot s = it.next();
            s.updateMe();
            if(s.pos.x < 0 - s.size || s.pos.x > width + s.size || s.pos.y < 0 - s.size || s.pos.y > height + s.size){
                it.remove();
            }
        }
    }

    void addShot(Shot s){
        Shots.add(s);
    }

    ArrayList<Shot> getShots(){
        return Shots;
    }
}

class Enemys{
    ArrayList<Enemy> Enemys;

    Enemys(){
        Enemys = new ArrayList<Enemy>();
    }

    void updateMe(Stage stage){
        Iterator<Enemy> it = Enemys.iterator();
        while(it.hasNext()){
            Enemy e = it.next();
            e.updateMe();
            e.Shot(stage);
            hit(stage, e);
            if(e.pos.x < 0 - e.size || e.pos.x > width + e.size || e.pos.y < 0 - e.size || e.pos.y > height + e.size){
                it.remove();
            }
            if(e.HP <= 0){
                it.remove();
            }
        }
    }

    void hit(Stage stage, Enemy enemy){
        Iterator<Shot> it = stage.jikiShots.getShots().iterator();
        while(it.hasNext()){
            Shot s = it.next();
            if(s.collision(enemy) == true){
                it.remove();
                enemy.HP--;
            }
        }
    }

    void addEnemy(Enemy e){
        print("addenemy");
        Enemys.add(e);
    }

    ArrayList<Enemy> getArray(){
        return Enemys;
    }
}