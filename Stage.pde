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
    private UI ui;

    private PGraphics buffer;
    private AudioPlayer bgm;

    Stage(){
        enemyShots = new Shots();
        enemys = new Enemys();
        items = new Items();
        jiki = new Jiki();
        particles = new Particles();
        particles_zenkei = new Particles();
        jikiShots = new Shots();
        count = 0;
        ui = new UI();

        buffer = createGraphics(width, height);
        setBGM("sol_battle047.mp3");
        bgm.printControls();
    }

    void updateMe(){
        if(!bgm.isPlaying())bgm.loop();

        if(jiki.getHP() <= 0) return;
        particles.updateMe(this);
        enemys.updateMe(this);
        jiki.updateMe(this);
        items.updateMe(this);
        jikiShots.updateMe(this);
        enemyShots.updateMe(this);
        particles_zenkei.updateMe(this);
        if(isCountUP){
            count++;
        }
        ui.updateMe(this);
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
        ui.drawMe(buffer);
        
        buffer.endDraw();
    }

    //名前がわかりにくい・・・ステージの構成を書くところです（何Fで何の敵がでるか）
    void enemySpawn(){

    }

    public void setBGM(String bgmFileName){
        bgm = minim.loadFile(bgmFileName);
    }

    public void addEnemy(Enemy e){
        enemys.addEnemy(e);
    }

    public void addEnemyShot(Shot s){
        enemyShots.addShot(s);
    }

    public void addJikiShot(Shot s){
        jikiShots.addShot(s);
    }

    public void addParticle(Particle p){
        particles.addParticle(p);
    }

    void startNewStage(Stage stage){
        stage.jiki = this.jiki;
        playingStage = stage;
    }

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

    public AudioPlayer getBGM(){
        return bgm;
    }

    int getEnemyCount(){
        return enemys.getArray().size();
    }

    int getShotCount(){
        return enemyShots.getArray().size();
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
        setBGM("sol_battle047.mp3");
        getBGM().setGain(-10f);
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
            }else{
                if(getEnemyCount() == 0){
                    if(!isMidBossAppeared){
                        addEnemy(new MidBoss01(width, height / 2));
                        isMidBossAppeared = true;
                    }else{
                        println("CountRestart");
                        setCountUP(true);
                    }
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
        if(getCount() == 820 || getCount() == 850 || getCount() == 880){
            addEnemy(new MarchLaser01(width, height - 100));
        }
        if(getCount() == 840 || getCount() == 870 || getCount() == 900){
            addEnemy(new MarchLaser01(width, 100));
        }
    }
}
