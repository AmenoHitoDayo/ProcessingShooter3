class Movers{
    protected List<Mover> movers;
    protected List<Mover> removedMovers;
    protected List<Mover> addedMovers;

    Movers(){
        movers = new ArrayList<Mover>();
        removedMovers = new ArrayList<Mover>();
        addedMovers = new ArrayList<Mover>();
    }

    void updateMe(){
        for(int i = 0; i < movers.size(); i++){
            process(movers.get(i));
        }

        movers.removeAll(removedMovers);
        movers.addAll(addedMovers);
        removedMovers.clear();
        addedMovers.clear();
    }

    void drawMe(PGraphics pg){
        for(int i = 0; i < movers.size(); i++){
            movers.get(i).drawMe(pg);
        }
    }

    void process(Mover m){
        m.updateMe();
        if(m.areYouDead()){
            removedMovers.add(m);
        }
    }

    //弾とかを追加
    public void addMover(Mover m){
        addedMovers.add(m);
    }

    //弾とかを削除
    public void removeMover(Mover m){
        removedMovers.add(m);
    }

    public List<Mover> getArray(){
        return movers;
    }
}

//このやり方でやれば、ShotからShotを追加できるんじゃないかなと。
//またこのやり方だとIteratorじゃなくてforでもできるとおもう。
//ゆくゆくはShots以外もこれにしたい
//問題はListが3つもあるので重そうだということ
class Shots extends Movers{

}

//敵にもこれをやる
class Enemys extends Movers{
    @Override
    void process(Mover m){
        super.process(m);
        if(m instanceof Enemy){
            Enemy e = (Enemy)m;
            hit(playingStage, e);
            e.shot();
        }
    }

    void hit(Stage stage, Enemy enemy){
        Iterator<Mover> it = stage.jikiShots.getArray().iterator();
        while(it.hasNext()){
            //子クラスにキャストしていいっぽいけど、こわいなこれ
            Mover m = it.next();
            if(!(m instanceof Shot))continue;
            Shot s = (Shot)m;

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

}

class Items extends Movers{

}

class Particles extends Movers{
    @Override
    void process(Mover m){
        super.process(m);
        if(!(m instanceof Particle)) return;
        Particle p = (Particle)m;
        if(p.getCount() > p.getLifeTime()){
            removedMovers.add(p);
        }
    }
}