class Stage{
    private Shots jikiShots;
    private Shots enemyShots;
    private Enemys enemys;
    private Items items;
    private Particles particles;
    private Jiki jiki;
    private Particles particles_zenkei;
    private int count = 0;
    private boolean isCountUP = true;

    private PGraphics buffer;

    Stage(){
        enemyShots = new Shots();
        enemys = new Enemys();
        items = new Items();
        jiki = new Jiki();
        particles = new Particles();
        particles_zenkei = new Particles();
        jikiShots = new Shots();
        count = 0;

        buffer = createGraphics(width, height);
    }

    void updateMe(){
        if(jiki.getHP() <= 0) return;
        particles.updateMe();
        enemys.updateMe(this);
        jiki.updateMe(this);
        items.updateMe(this);
        jikiShots.updateMe();
        enemyShots.updateMe();
        particles_zenkei.updateMe();
        if(isCountUP){
            count++;
        }
        enemySpawn();
    }

    void drawMe(){
        image(buffer, 0, 0);

        buffer.beginDraw();
        buffer.background(0);
        buffer.rectMode(CENTER);

        particles.drawMe(buffer);
        enemys.drawMe(buffer);
        jiki.drawMe(buffer);
        items.drawMe(buffer);
        jikiShots.drawMe(buffer);
        enemyShots.drawMe(buffer);
        particles_zenkei.drawMe(buffer);
        
        buffer.endDraw();
    }

    void enemySpawn(){

    }

    void addEnemy(Enemy e){
        enemys.addEnemy(e);
    };

    public int getCount(){
        return count;
    }

    public Jiki getJiki(){
        return jiki;
    }

    public boolean getCountUP(){
        return isCountUP;
    }

    public void setCountUP(boolean _b){
        isCountUP = _b;
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
        if(getCount() % 10 == 0 && getEnemyCount() <= 0){
            addEnemy(new SampleEnemy());
        }
    }
}

class Stage01 extends Stage{
    boolean isMidBossAppeared = false;
    Stage01(){
        super();
    }

    void enemySpawn(){
        if(getCount() == 30 || getCount() == 60 || getCount() == 90){
            addEnemy(new March01(width - 120, 0));
        }
        if(getCount() == 60 || getCount() == 90 || getCount() == 120){
            addEnemy(new March02(width - 180, height));
        }
        if(getCount() == 180){
            addEnemy(new Aim01(width, 120));
        }
        if(getCount() == 300){
            Aim01 aim01_1 = new Aim01(width, height - 120);
            aim01_1.setHue(205);
            addEnemy(aim01_1);
        }
        if(getCount() == 400){
            addEnemy(new Red01(width, height / 2));
        }
        if(getCount() == 500){
            addEnemy(new Green01(width, height / 2 - height / 3));
        }
        if(getCount() == 600){
            addEnemy(new Blue01(width, height / 2 + height / 3));
        }
        if(getCount() == 660){
            if(getCountUP() == true){
                setCountUP(false);
            }
            if(getCountUP() == false && getEnemyCount() == 0){
                if(!isMidBossAppeared){
                    addEnemy(new MidBoss01(width, height / 2));
                    isMidBossAppeared = true;
                }else{
                    println("CountRestart");
                    setCountUP(true);
                }
            }
        }
        if(getCount() == 700){
            addEnemy(new Circle01(width, height / 2));
        }
        if(getCount() == 760){
            addEnemy(new ShotGun01(width, 120, radians(180 - 30)));
            addEnemy(new ShotGun01(width, height - 120, radians(180 + 30)));
        }
    }
}
