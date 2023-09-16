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
    protected AudioPlayer clearJingle;

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
        
        clearJingle = minim.loadFile("sol_fanfare002.mp3");
        setBGMGain(clearJingle, 0f);
        
        bgm.printControls();
    }

    void updateMe(){
        if(jiki.getHP() <= 0){
            bgm.pause();
            scene = Scene.GameOverScene;
            return;
        }
        if(count == 0){bgm.loop();}
        particles.updateMe();
        enemys.updateMe();
        jiki.updateMe(this);
        items.updateMe();
        jikiShots.updateMe();
        enemyShots.updateMe();
        particles_zenkei.updateMe();
        if(isCountUP){
            count++;
        }
        ui.updateMe();
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
    }

    void keyPressed(){
        jiki.keyPressed();
    }

    //
    void keyReleased(){
        jiki.keyReleased();
    }

    //名前がわかりにくい・・・ステージの構成を書くところです（何Fで何の敵がでるかとか）
    void stageStructure(){

    }

    public void addEnemy(Enemy e){
        enemys.addMover(e);
    }

    public void addEnemyShot(Shot s){
        enemyShots.addMover(s);
    }

    public void addJikiShot(Shot s){
        jikiShots.addMover(s);
    }

    public void addParticle(Particle p){
        particles.addMover(p);
    }

    public void addItem(Item i){
        items.addMover(i);
    }

    public void removeEnemyShot(Shot s){
        enemyShots.removeMover(s);
    }

    public void removeItem(Item i){
        items.removeMover(i);
    }

    void startNewStage(Stage stage){
        stage.jiki = this.jiki;
        playingStage = stage;
    }

    void endStage(){
        //クリア画面へ移行
        clearJingle.play(0);
        scene = Scene.GameClearScene;
        finalScore = jiki.totalItem;
        bgm.pause();
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

    public List<Mover> getEnemyShots(){
        return enemyShots.getArray();
    }

    public List<Mover> getEnemys(){
        return enemys.getArray();
    }

    public List<Mover> getItems(){
        return items.getArray();
    }

    int getEnemyCount(){
        return enemys.getArray().size();
    }

    int getShotCount(){
        return enemyShots.getArray().size();
    }

    public void setBGM(String bgmFileName){
        bgm = minim.loadFile(bgmFileName);
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

class Stage_Test extends Stage{
    boolean isMidBossAppeared = false;
    boolean isBossAppeared = false;

    private String stageBGM = "sol_battle047.mp3";
    private String bossBGM = "sol_battle046.mp3";

    Stage_Test(){
        super();
        setBGM(stageBGM);
        setBGMGain(getBGM(), 0);
        count = 0;
    }

//これハードコーディングじゃなくてJSONかなんかで制御するようにした方がいいらしいです。やりかたしらべろ
    void stageStructure(){
        if(count == 30 || count == 60 || count == 90 || count == 120 || count == 150){
            addEnemy(new March01(width - 120, 0));
        }
        if(count == 60 || count == 90 || count == 120 || count == 150 || count == 180){
            addEnemy(new March02(width - 180, height));
        }

        if(count == 220){
            addEnemy(new Bomb01(width / 2, height, 2, radians(270)));
        }
        if(count == 240){
            addEnemy(new Bomb01(width / 2, 0, 2, radians(90)));
        }
        if(count == 260){
            addEnemy(new Bomb01(width / 3 * 2, height, 3, radians(270)));
        }
        if(count == 280){
            addEnemy(new Bomb01(width / 3 * 2, 0, 3, radians(90)));
        }
        if(count == 300){
            addEnemy(new Bomb02(width / 6 * 5, height, 3, radians(270)));
        }
        if(count == 320){
            addEnemy(new Bomb02(width / 6 * 5, 0, 3, radians(90)));
        }

        if(count == 480){
            addEnemy(new Aim01(width, 120));
        }
        if(count == 520){
            Aim01 aim01_1 = new Aim01(width, height - 120);
            aim01_1.setHue(205);
            addEnemy(aim01_1);
        }

        if(count == 700){
            addEnemy(new Red01(width, height / 2));
        }
        if(count == 800){
            addEnemy(new Green01(width, height / 2 - height / 3));
        }
        if(count == 900){
            addEnemy(new Blue01(width, height / 2 + height / 3));
        }
        if(count == 1000){
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
                        //println("CountRestart");
                        isCountUP = true;
                    }
                }
            }
        }
        
        if(count == 1010){
            addEnemy(new Missile01(width, height / 7));
        }
        if(count == 1020){
            addEnemy(new Missile01(width, height / 7 * 2));
        }
        if(count == 1030){
            addEnemy(new Missile01(width, height / 7 * 3));
        }
        if(count == 1040){
            addEnemy(new Missile01(width, height / 7 * 4));
        }

        if(count == 1100){
            addEnemy(new Fountain01(200, height, radians(-90)));
        }
        if(count == 1110){
            addEnemy(new Fountain01(300, height, radians(-90)));
        }
        if(count == 1120){
            addEnemy(new Fountain01(400, height, radians(-90)));
        }


        if(count == 1175 || count == 1205 || count == 1235){
            addEnemy(new MarchLaser01(width, height - 100));
        }
        if(count == 1200 || count == 1230 || count == 1260){
            addEnemy(new MarchLaser01(width, 100));
        }
        

        if(count == 1215){
            addEnemy(new Fountain01(250, 0, radians(90)));
        }
        if(count == 1225){
            addEnemy(new Fountain01(350, 0, radians(90)));
        }
        if(count == 1235){
            addEnemy(new Fountain01(450, 0, radians(90)));
        }
        

        if(count == 1400){
            addEnemy(new Circle01(width, height / 2));
        }
        
        if(count == 1460){
            addEnemy(new ShotGun01(width, 120, radians(180 - 30)));
            addEnemy(new ShotGun01(width, height - 120, radians(180 + 30)));
        }

        if(count == 1550){
            addEnemy(new Lissajous01(width, height  /2));
        }

        if(count == 1800){
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
                        setBGMGain(getBGM(), 0f);
                        bgm.loop(0);

                        Enemy e = new Boss_Mauve(width, height / 2);
                        addEnemy(e);
                        getUI().makeGauge(e);
                        //ボス出たフラグ
                        isBossAppeared = true;
                    }else{
                        //ボス出たあとに敵数が0になった=中ボスが倒れたのでカウント再開
                        //println("CountRestart");
                        isCountUP = true;
                    }
                }
            }
        }

        if(count > 1800){
            if(getEnemyCount() == 0 && getShotCount() == 0){
                endStage();
            }
        }
    }
}

class Stage01 extends Stage{
    private String stageBGM = "sol_battle047.mp3";
    private String bossBGM = "sol_battle046.mp3";

    Stage01(){
        super();
        setBGM(stageBGM);
        setBGMGain(getBGM(), 0);
        count = 0;
    }
}