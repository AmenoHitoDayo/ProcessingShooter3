class Movers{
    private ArrayList<Mover> movers;

    Movers(){
        movers = new ArrayList<Mover>();
    }

    void updateMe(){
        Iterator<Mover> it = movers.iterator();
        while(it.hasNext()){
            Mover m = it.next();
            m.updateMe();
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

//このやり方でやれば、ShotからShotを追加できるんじゃないかなと。
//またこのやり方だとIteratorじゃなくてforでもできるとおもう。
//ゆくゆくはShots以外もこれにしたい
//問題はListが3つもあるので重そうだということ
class Shots{
    protected ArrayList<Shot> shots;
    protected ArrayList<Shot> removedShots;
    protected ArrayList<Shot> addedShots;

    Shots(){
        shots = new ArrayList<Shot>();
        removedShots = new ArrayList<Shot>();
        addedShots = new ArrayList<Shot>();
    }

    void updateMe(){
        Iterator<Shot> it = shots.iterator();
        while(it.hasNext()){
            Shot s = it.next();
            s.updateMe();
            if(s.areYouDead() == true){
                removedShots.add(s);
            }
        }

        //iterator内でshotを追加/削除するのではなく、
        //そのフレーム内で追加された/削除されたリストをつくって
        //フレームの最後にまとめて処理する。
        shots.removeAll(removedShots);
        shots.addAll(addedShots);
        removedShots.clear();
        addedShots.clear();
    }

    void drawMe(PGraphics pg){
        for(int i = 0; i < shots.size(); i++){
            shots.get(i).drawMe(pg);
        }
    }

    void addShot(Shot s){
        addedShots.add(s);
    }

    void removeShot(Shot s){
        removedShots.add(s);
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

    void updateMe(){
        Iterator<Enemy> it = enemys.iterator();
        while(it.hasNext()){
            Enemy e = it.next();
            e.updateMe();
            e.shot();
            hit(playingStage, e);
            if(e.areYouDead()){
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
            if(s.collision(enemy) && s.isHittable){
                enemy.playHitSound();
                if(s.isDeletable){
                    s.kill();
                }
                if(!enemy.invincible){
                    enemy.HPDown(1);
                }
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

    void updateMe(){
        Iterator<Item> it = items.iterator();
        while(it.hasNext()){
            Item i = it.next();
            i.updateMe();
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
    
    void updateMe(){
        Iterator<Particle> it = particles.iterator();
        while(it.hasNext()){
            Particle p = it.next();
            p.updateMe();
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
