class Stage{
    private Shots jikiShots;
    private Shots enemyShots;
    private Enemys enemys;
    private Items items;
    private Particles particles;
    private Jiki jiki;
    private Particles particles_zenkei;
    private UI ui;

    protected boolean isCountUP = true;
    protected int count = 0;
    protected AudioPlayer bgm;

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
        ui = new UI();

        buffer = createGraphics(width, height);
        setBGM("sol_battle047.mp3");
        bgm.printControls();
    }

    void updateMe(){

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
        stageStructure();
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

        if(jiki.getHP() <= 0){
            bgm.pause();

            buffer.beginDraw();

                buffer.noStroke();
                buffer.fill(0, 127);
                buffer.rect(width / 2, height / 2, width, height);
                buffer.fill(255);
                
                buffer.textSize(16);
                buffer.text("Game Over", width / 2 - 8 * 4.5, height / 2 - 16);

            buffer.endDraw();
        }
    }

    //名前がわかりにくい・・・ステージの構成を書くところです（何Fで何の敵がでるかとか）
    void stageStructure(){

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

    public void addItem(Item i){
        items.addItem(i);
    }

    public void removeEnemyShot(Shot s){
        enemyShots.removeShot(s);
    }

    void startNewStage(Stage stage){
        stage.jiki = this.jiki;
        playingStage = stage;
    }

    //以下getter/setter
    public Jiki getJiki(){
        return jiki;
    }

    public AudioPlayer getBGM(){
        return bgm;
    }

    public UI getUI(){
        return ui;
    }

    public ArrayList<Shot> getEnemyShots(){
        return enemyShots.getArray();
    }

    public ArrayList<Enemy> getEnemys(){
        return enemys.getArray();
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
        if(count % 10 == 0 && getEnemyCount() <= 0){
            addEnemy(new SampleEnemy());
        }
    }
}

class Stage01 extends Stage{
    boolean isMidBossAppeared = false;
    boolean isBossAppeared = false;

    private String stageBGM = "sol_battle047.mp3";
    private String bossBGM = "sol_battle046.mp3";

    Stage01(){
        super();
        setBGM(stageBGM);
        getBGM().setGain(-10f);
        bgm.loop();
        count = 10;
    }

    void stageStructure(){
        if(count == 30 || count == 60 || count == 90){
            addEnemy(new March01(width - 120, 0));
        }
        if(count == 60 || count == 90 || count == 120){
            addEnemy(new March02(width - 180, height));
        }
        if(count == 180){
            addEnemy(new Aim01(width, 120));
        }
        if(count == 300){
            Aim01 aim01_1 = new Aim01(width, height - 120);
            aim01_1.setHue(205);
            addEnemy(aim01_1);
        }
        if(count == 500){
            addEnemy(new Red01(width, height / 2));
        }
        if(count == 600){
            addEnemy(new Green01(width, height / 2 - height / 3));
        }
        if(count == 700){
            addEnemy(new Blue01(width, height / 2 + height / 3));
        }
        if(count == 760){
            //ここに来たらいったんカウンタとめる
            if(isCountUP){
                isCountUP = false;
            }else{
                //他に敵がいなくなったら中ボス出す
                if(getEnemyCount() == 0 && getShotCount() == 0){
                    if(!isMidBossAppeared){
                        Enemy e = new MidBoss01(width, height / 2);
                        addEnemy(e);
                        getUI().makeGauge(e);
                        //中ボス出たフラグ
                        isMidBossAppeared = true;
                    }else{
                        //中ボス出たあとに敵数が0になった=中ボスが倒れたのでカウント再開
                        println("CountRestart");
                        isCountUP = true;
                    }
                }
            }
        }
        
        if(count == 860){
            addEnemy(new Missile01(width, height / 7));
        }
        if(count == 870){
            addEnemy(new Missile01(width, height / 7 * 2));
        }
        if(count == 880){
            addEnemy(new Missile01(width, height / 7 * 3));
        }
        if(count == 890){
            addEnemy(new Missile01(width, height / 7 * 4));
        }
        //ここにミサイルウェーブもう1個

        if(count == 960){
            addEnemy(new Fountain01(200, height, radians(-90)));
        }
        if(count == 970){
            addEnemy(new Fountain01(300, height, radians(-90)));
        }
        if(count == 980){
            addEnemy(new Fountain01(400, height, radians(-90)));
        }

        if(count == 1000 || count == 1030 || count == 1060){
            addEnemy(new MarchLaser01(width, height - 100));
        }
        if(count == 1015 || count == 1045 || count == 1075){
            addEnemy(new MarchLaser01(width, 100));
        }

        if(count == 1120){
            addEnemy(new Fountain01(250, 0, radians(90)));
        }
        if(count == 1130){
            addEnemy(new Fountain01(350, 0, radians(90)));
        }
        if(count == 1140){
            addEnemy(new Fountain01(450, 0, radians(90)));
        }

        if(count == 1200){
            addEnemy(new Circle01(width, height / 2));
        }
        
        if(count == 1260){
            addEnemy(new ShotGun01(width, 120, radians(180 - 30)));
            addEnemy(new ShotGun01(width, height - 120, radians(180 + 30)));
        }

        if(count == 1400){
            addEnemy(new Lissajous01(width, height  /2));
        }

        if(count == 1600){
            //ここに来たらいったんカウンタとめる
            if(isCountUP){
                isCountUP = false;
            }else{
                //他に敵がいなくなったら中ボス出す
                if(getEnemyCount() == 0 && getShotCount() == 0){
                    if(!isBossAppeared){
                        //音楽を変える
                        bgm.pause();
                        setBGM(bossBGM);
                        getBGM().setGain(-10f);
                        bgm.loop(0);

                        Enemy e = new Boss_Mauve(width, height / 2);
                        addEnemy(e);
                        getUI().makeGauge(e);
                        //中ボス出たフラグ
                        isBossAppeared = true;
                    }else{
                        //中ボス出たあとに敵数が0になった=中ボスが倒れたのでカウント再開
                        println("CountRestart");
                        isCountUP = true;
                    }
                }
            }
        }
    }
}
