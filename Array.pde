class Shots{
    ArrayList<Shot> shots;

    Shots(){
        shots = new ArrayList<Shot>();
    }

    void updateMe(){
        Iterator<Shot> it = shots.iterator();
        while(it.hasNext()){
            Shot s = it.next();
            s.updateMe();
            if(s.isDeleted == true){
                it.remove();
            }
        }
    }

    void addShot(Shot s){
        shots.add(s);
    }

    void removeShot(Shot s){
        shots.remove(s);
    }

    ArrayList<Shot> getShots(){
        return shots;
    }
}

class Enemys{
    ArrayList<Enemy> enemys;

    Enemys(){
        enemys = new ArrayList<Enemy>();
    }

    void updateMe(Stage stage){
        Iterator<Enemy> it = enemys.iterator();
        while(it.hasNext()){
            Enemy e = it.next();
            e.updateMe();
            e.shot(stage);
            hit(stage, e);
            if(e.isDead){
                if(e.isOutOfScreen == false){
                    rectParticle r = new rectParticle(e.pos.x, e.pos.y, e.col);
                    stage.particles.addParticle(r);
                }
                it.remove();
            }
        }
    }

    void hit(Stage stage, Enemy enemy){
        Iterator<Shot> it = stage.jikiShots.getShots().iterator();
        while(it.hasNext()){
            Shot s = it.next();
            if(s.collision(enemy)){
                if(s.isHittable){
                    //被弾エフェクト
                    rectParticle r1 = new rectParticle(enemy.pos.x, enemy.pos.y, s.col);
                    stage.particles.addParticle(r1);

                    if(s.isDeletable){
                        s.isDeleted = true;
                    }
                    enemy.HP--;
                }
                continue;
            }
        }
    }

    void addEnemy(Enemy e){
        print("addenemy");
        enemys.add(e);
    }

    ArrayList<Enemy> getArray(){
        return enemys;
    }
}

class Items{
    ArrayList<Item> items;

    Items(){
        items = new ArrayList<Item>();
    }

    void updateMe(Stage stage){
        Iterator<Item> it = items.iterator();
        while(it.hasNext()){
            Item i = it.next();
            i.updateMe(stage);
            if(i.pos.x < 0 - i.size || i.pos.x > width + i.size || i.pos.y < 0 - i.size || i.pos.y > height + i.size){
                it.remove();
            }
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
    ArrayList<Particle> particles;
    
    Particles(){
        particles = new ArrayList<Particle>();
    }
    
    void updateMe(){
            Iterator<Particle> it = particles.iterator();
            while(it.hasNext()){
                Particle p = it.next();
                p.updateMe();
                if(p.count > p.lifeTime){
                    it.remove();
                }
            }
        }
        
    void addParticle(Particle p){
        particles.add(p);
    }
        
    void removeParticle(Particle p){
        particles.remove(p);
    }
}
