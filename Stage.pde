class Stage{
    Shots jikiShots;
    Shots enemyShots;
    Enemys enemys;
    Items items;
    Particles particles;
    Jiki jiki;
    int count = 0;

    Stage(){
        enemyShots = new Shots();
        enemys = new Enemys();
        items = new Items();
        jiki = new Jiki();
        particles = new Particles();
        jikiShots = new Shots();
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
        if(count == 300){
            Aim01 aim01_1 = new Aim01(width, height - 120);
            aim01_1.setHue(205);
            enemys.addEnemy(aim01_1);
        }
        if(count == 360){
            enemys.addEnemy(new Circle01(width, height / 2));
        }
        if(count == 500){
            enemys.addEnemy(new ShotGun01(width, 120, 180 - 30));
            enemys.addEnemy(new ShotGun01(width, height - 120, 180 + 30));
        }
    }
}
