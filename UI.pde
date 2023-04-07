class UI{
    private Stage stage;
    private boolean isGaugeUsing = false;
    private HPGauge gauge;
    private PGraphics pg;
    
    UI(){
        stage = playingStage;
        gauge = new HPGauge();
    }

    void drawMe(){
        pg = stage.getBuffer();
        drawHP();
        drawColorPoint();
        drawReleaseWaitGauge();
        drawEnemyCount();
        drawTekidanCount();
        if(isGaugeUsing == true && gauge.getBaseEnemy() != null){
            gauge.drawMe(pg);
        }
    }
    
    void updateMe(){
        if(isGaugeUsing){
            if(gauge.getBaseEnemy().areYouDead() || gauge.getBaseEnemy() == null){
                isGaugeUsing = false;
            }
        }
    }

    void drawHP(){
        pg.beginDraw();
            pg.noStroke();
            if(stage.getJiki().getX() < 32 && stage.getJiki().getY() < 16){
                pg.fill(255, 127);
            }else{
                pg.fill(255);
            }
            pg.textFont(kinkakuji, 16);
            pg.text("HP : ", 0, 16);
            for(int i = 0; i < stage.getJiki().getHP(); i++){
                easyTriangle(pg, 6 * 5 + 8 + 16 * i, 10, 0, 8);
            }
        pg.endDraw();
    }

    void drawColorPoint(){
        pg.beginDraw();
            if(stage.jiki.getX() < 64 && stage.jiki.getY() > height - 16 * 2){
                pg.fill(255, 127);
            }else{
                pg.fill(255);
            }
            pg.textFont(kinkakuji, 16);
            pg.text("RED : " + stage.jiki.RedP, 0, height - 16 * 2);
            pg.text("GREEN : " + stage.jiki.GreenP, 0, height - 16 * 1);
            pg.text("BLUE : " + stage.jiki.BlueP, 0, height - 16 * 0);
        pg.endDraw();
    }

    void drawReleaseWaitGauge(){
        pg.beginDraw();
            if(stage.jiki.releaseWaitCount > stage.jiki.getCount()){
                float length = map(stage.jiki.releaseWaitCount - stage.jiki.getCount(), 0, stage.jiki.releaseWaitFrame, 0, 32);
                pg.noFill();
                pg.stroke(255);
                pg.strokeWeight(3);
                pg.line(stage.jiki.getX() - 16, stage.jiki.getY() - 16 - 8, stage.jiki.getX() - 16 + length, stage.jiki.getY() - 16 - 8);
            }
        pg.endDraw();
    }

    void drawEnemyCount(){
        pg.beginDraw();
            if(stage.jiki.getX() < 32 && stage.jiki.getY() < 32){
                pg.fill(255, 127);
            }else{
                pg.fill(255);
            }
            pg.textFont(kinkakuji, 16);
            pg.text("Enemys : " + stage.getEnemyCount(), 0, 16 * 2);
        pg.endDraw();
    }

    void drawTekidanCount(){
        pg.beginDraw();
            if(stage.jiki.getX() < 32 && stage.jiki.getY() < 16 * 3){
                pg.fill(255, 127);
            }else{
                pg.fill(255);
            }
            pg.textFont(kinkakuji, 16);
            pg.text("Shots : " + stage.getShotCount(), 0, 16 * 3);
        pg.endDraw();
    }

    public void makeGauge(Enemy _e){
        isGaugeUsing = true;
        gauge.makeGauge(_e);
    }

    void getStage(){
        stage = playingStage;
    }
}

class HPGauge{
    private Enemy baseEnemy;
    private float maxHP = 0f;
    private float currentHP = 0f;

    private float gaugeOutMargin = 80;

    HPGauge(){
        baseEnemy = null;
    }

    void drawMe(PGraphics pg){
        currentHP = baseEnemy.getHP();
        float maxLength = width - gaugeOutMargin * 2;
        float rectLength = (maxLength) * (currentHP / maxHP);

        pg.beginDraw();
            pg.push();

            pg.rectMode(CORNERS);
            pg.stroke(255);
            pg.strokeWeight(1);
            pg.noFill();
            pg.rect(gaugeOutMargin, 20, gaugeOutMargin + maxLength, 30);

            pg.noStroke();
            pg.fill(255);
            pg.rect(gaugeOutMargin, 20 , gaugeOutMargin + rectLength, 30 );

            pg.pop();

        pg.endDraw();
    }

    public void makeGauge(Enemy _e){
        baseEnemy = _e;
        maxHP = baseEnemy.getHP();
        currentHP = maxHP;
    }

    //ゲージの元となる敵を作成（敵が死んだかどうかの判定につかう）
    public Enemy getBaseEnemy(){
        return baseEnemy;
    }
}