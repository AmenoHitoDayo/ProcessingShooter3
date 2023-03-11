class Stage{
    Shots jikiShots;
    Shots enemyShots;
    Enemys enemys;
    Items items;
    Particles particles;
    Jiki jiki;
    int count = 0;

    Stage(){
        jikiShots = new Shots();
        enemyShots = new Shots();
        enemys = new Enemys();
        items = new Items();
        particles = new Particles();
        jiki = new Jiki();
        count = 0;
    }

    void updateMe(){
        particles.updateMe();
        enemys.updateMe(this);
        jiki.updateMe(this);
        items.updateMe(this);
        jikiShots.updateMe();
        enemyShots.updateMe();
        count++;
        enemySpawn();
    }

    void enemySpawn(){

    };

    Jiki getJiki(){
        return jiki;
    }

    int getEnemyCount(){
        return enemys.getArray().size();
    }

    void startNewStage(Stage s){
        s.jiki = this.jiki;
        playingStage = s;
    }
}

class SampleStage extends Stage{
    SampleStage(){
        super();
    }

    void enemySpawn(){
        if(count % 10 == 0 && getEnemyCount() <= 0){
            enemys.addEnemy(new SampleEnemy());
        }
    }
}

class Stage01 extends Stage{
    Stage01(){
        super();
    }

    void enemySpawn(){
        if(count == 30 || count == 60 || count == 90){
            enemys.addEnemy(new March01(width - 120, 0));
        }
        if(count == 60 || count == 90 || count == 120){
            enemys.addEnemy(new March02(width - 180, height));
        }
        if(count == 180){
            enemys.addEnemy(new Aim01(width, 120));
        }
    }
}
