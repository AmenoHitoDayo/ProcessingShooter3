class Stage{
    Shots jikiShots;
    Shots enemyShots;
    Enemys enemys;
    Items items;
    Jiki jiki;
    int count = 0;

    Stage(){
        jikiShots = new Shots();
        enemyShots = new Shots();
        enemys = new Enemys();
        items = new Items();
        jiki = new Jiki();
        count = 0;
    }

    void updateMe(){
        jikiShots.updateMe();
        enemyShots.updateMe();
        enemys.updateMe(this);
        jiki.updateMe();
        jiki.hit(this);
        jiki.Shot(this);
        items.updateMe(this);
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