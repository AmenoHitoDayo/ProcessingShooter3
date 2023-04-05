class Movers{
    private ArrayList<Mover> movers;

    Movers(){
        movers = new ArrayList<Mover>();
    }

    void updateMe(Stage stage){
        Iterator<Mover> it = movers.iterator();
        while(it.hasNext()){
            Mover m = it.next();
            m.updateMe(stage);
            if(m.areYouDead()){
                it.remove();
            }
        }
    }

    void drawMe(PGraphics pg){
        for(int i = 0; i < movers.size(); i++){
            movers.get(i).drawMe(pg);
        }
    }

    //弾とかを追加
    public void addMover(Mover m){
        movers.add(m);
    }

    //弾とかを削除
    public void removeMover(Mover m){
        movers.remove(m);
    }

    public ArrayList<Mover> getArray(){
        return movers;
    }
}

class Shots{
    private ArrayList<Shot> shots;

    Shots(){
        shots = new ArrayList<Shot>();
    }

    void updateMe(Stage stage){
        Iterator<Shot> it = shots.iterator();
        while(it.hasNext()){
            Shot s = it.next();
            s.updateMe(stage);
            if(s.areYouDead() == true){
                it.remove();
            }
        }
    }

    void drawMe(PGraphics pg){
        for(int i = 0; i < shots.size(); i++){
            shots.get(i).drawMe(pg);
        }
    }

    void addShot(Shot s){
        shots.add(s);
    }

    void removeShot(Shot s){
        shots.remove(s);
    }

    ArrayList<Shot> getArray(){
        return shots;
    }
}

class Enemys{
    private ArrayList<Enemy> enemys;

    Enemys(){
        enemys = new ArrayList<Enemy>();
    }

    void updateMe(Stage stage){
        Iterator<Enemy> it = enemys.iterator();
        while(it.hasNext()){
            Enemy e = it.next();
            e.updateMe(stage);
            e.shot(stage);
            hit(stage, e);
            if(e.areYouDead()){
                if(e.isOutOfScreen() == false){
                    rectParticle r = new rectParticle(e.getPos().x, e.getPos().y, e.getColor());
                    stage.particles.addParticle(r);
                }
                it.remove();
            }
        }
    }

    void drawMe(PGraphics pg){
        for(int i = 0; i < enemys.size(); i++){
            enemys.get(i).drawMe(pg);
        }
    }

    void hit(Stage stage, Enemy enemy){
        Iterator<Shot> it = stage.jikiShots.getArray().iterator();
        while(it.hasNext()){
            Shot s = it.next();
            if(s.collision(enemy)){
                if(s.isHittable){
                    //被弾エフェクト
                    rectParticle r1 = new rectParticle(enemy.getPos().x, enemy.getPos().y, s.col);
                    stage.particles.addParticle(r1);

                    if(s.isDeletable){
                        s.kill();
                    }
                    enemy.HPDown(1);
                }
                continue;
            }
        }
    }

    public void addEnemy(Enemy e){
        print("addenemy");
        enemys.add(e);
    }

    public void removeEnemy(Enemy e){
        enemys.remove(e);
    }

    ArrayList<Enemy> getArray(){
        return enemys;
    }
}

class Items{
    private ArrayList<Item> items;

    Items(){
        items = new ArrayList<Item>();
    }

    void updateMe(Stage stage){
        Iterator<Item> it = items.iterator();
        while(it.hasNext()){
            Item i = it.next();
            i.updateMe(stage);
            if(i.getPos().x < 0 - i.getSize() || i.getPos().x > width + i.getSize() || i.getPos().y < 0 - i.getSize() || i.getPos().y > height + i.getSize()){
                it.remove();
            }
        }
    }

    void drawMe(PGraphics pg){
        for(int i = 0; i < items.size(); i++){
            items.get(i).drawMe(pg);
        }
    }

    void addItem(Item i){
        items.add(i);
    }

    ArrayList<Item> getArray(){
        return items;
    }
}

class Particles{
    private ArrayList<Particle> particles;
    
    Particles(){
        particles = new ArrayList<Particle>();
    }
    
    void updateMe(Stage stage){
        Iterator<Particle> it = particles.iterator();
        while(it.hasNext()){
            Particle p = it.next();
            p.updateMe(stage);
            if(p.getCount() > p.lifeTime){
                it.remove();
            }
        }
    }
        

    void drawMe(PGraphics pg){
        for(int i = 0; i < particles.size(); i++){
            particles.get(i).drawMe(pg);
        }
    }
        
    void addParticle(Particle p){
        particles.add(p);
    }
        
    void removeParticle(Particle p){
        particles.remove(p);
    }
}
