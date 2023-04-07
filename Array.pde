class Movers{
    private ArrayList<Mover> movers;

    Movers(){
        movers = new ArrayList<Mover>();
    }

    void updateMe(Stage _s){
        Iterator<Mover> it = movers.iterator();
        while(it.hasNext()){
            Mover m = it.next();
            m.updateMe(_s);
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

    void updateMe(Stage _s){
        Iterator<Shot> it = shots.iterator();
        while(it.hasNext()){
            Shot s = it.next();
            s.updateMe(_s);
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
    private Stage stage;

    Enemys(){
        enemys = new ArrayList<Enemy>();
    }

    void updateMe(Stage _s){
        Iterator<Enemy> it = enemys.iterator();
        while(it.hasNext()){
            Enemy e = it.next();
            e.updateMe(_s);
            e.shot();
            hit(_s, e);
            if(e.areYouDead()){
                if(e.isOutOfScreen() == false){
                    e.playDeadSound();
                    circleParticle r = new circleParticle(e.getX(), e.getY(), e.getColor());
                    stage.addParticle(r);
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
                    enemy.playHitSound();
                    rectParticle r1 = new rectParticle(s.getX(), s.getY(), s.col);
                    stage.addParticle(r1);
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

    void updateMe(Stage _s){
        Iterator<Item> it = items.iterator();
        while(it.hasNext()){
            Item i = it.next();
            i.updateMe(_s);
            if(i.isOutOfScreen()){
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
    
    void updateMe(Stage _s){
        Iterator<Particle> it = particles.iterator();
        while(it.hasNext()){
            Particle p = it.next();
            p.updateMe(_s);
            if(p.getCount() > p.getLifeTime()){
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
