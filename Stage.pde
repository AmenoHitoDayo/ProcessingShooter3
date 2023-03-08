class Stage{
    Shots jikiShots;
    Shots enemyShots;
    Enemys enemys;
    Jiki jiki;
    int count = 0;

    Stage(){
        jikiShots = new Shots();
        enemyShots = new Shots();
        enemys = new Enemys();
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