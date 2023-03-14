class Stage{
    Shots jikiShots;
    Shots enemyShots;
    Enemys enemys;
    Items items;
    Particles particles;
    Jiki jiki;
    int count = 0;
    boolean isCountUP = true;

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
        if(jiki.HP <= 0) return;
        particles.updateMe();
        enemys.updateMe(this);
        jiki.updateMe(this);
        items.updateMe(this);
        jikiShots.updateMe();
        enemyShots.updateMe();
        if(isCountUP){
            count++;
        }
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
    boolean isMidBossAppeared = false;
    Stage01(){
        super();
        count = 0;
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
        if(count == 400){
            enemys.addEnemy(new Red01(width, height / 2));
        }
        if(count == 500){
            enemys.addEnemy(new Green01(width, height / 2 - height / 3));
        }
        if(count == 600){
            enemys.addEnemy(new Blue01(width, height / 2 + height / 3));
        }
        if(count == 660){
            if(isCountUP == true){
                isCountUP = false;
            }
            if(isCountUP == false && getEnemyCount() == 0){
                if(!isMidBossAppeared){
                    enemys.addEnemy(new MidBoss01(width, height / 2));
                    isMidBossAppeared = true;
                }else{
                    println("countRestart");
                    isCountUP = true;
                }
            }
        }
        if(count == 700){
            enemys.addEnemy(new Circle01(width, height / 2));
        }
        if(count == 760){
            enemys.addEnemy(new ShotGun01(width, 120, radians(180 - 30)));
            enemys.addEnemy(new ShotGun01(width, height - 120, radians(180 + 30)));
        }
    }
}
