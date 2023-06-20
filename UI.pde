class UI{
    private boolean isGaugeUsing = false;
    private HPGauge gauge;
    private PGraphics pg;
    
    UI(){
        gauge = new HPGauge();
    }

    void drawMe(PGraphics _pg){
        pg = _pg;
        drawHP();
        drawColorPoint();
        drawReleaseWaitGauge();
        //drawEnemyCount();
        //drawTekidanCount();
        drawScoreCount();
        if(gameConfig.isControlAssist)drawControlAssist();
        if(isGaugeUsing == true && gauge.getBaseEnemy() != null){
            gauge.drawMe(_pg);
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
            if(playingStage.getJiki().getX() < 32 && playingStage.getJiki().getY() < 16){
                pg.fill(255, 127);
            }else{
                pg.fill(255);
            }
            pg.textFont(kinkakuji, 16);
            pg.text("HP : ", 0, 16);
            for(int i = 0; i < playingStage.getJiki().getHP(); i++){
                easyTriangle(pg, 6 * 5 + 8 + 16 * i, 10, 0, 8);
            }
        pg.endDraw();
    }

    void drawColorPoint(){
        pg.beginDraw();
            if(playingStage.jiki.getX() < 64 && playingStage.jiki.getY() > height - 16 * 2){
                pg.fill(255, 127);
            }else{
                pg.fill(255);
            }
            pg.textFont(kinkakuji, 16);
            pg.text("RED : " + playingStage.jiki.RedP, 0, height - 16 * 2);
            pg.text("GREEN : " + playingStage.jiki.GreenP, 0, height - 16 * 1);
            pg.text("BLUE : " + playingStage.jiki.BlueP, 0, height - 16 * 0);
        pg.endDraw();
    }

    void drawReleaseWaitGauge(){
        pg.beginDraw();
            if(playingStage.jiki.releaseWaitCount > playingStage.jiki.getCount()){
                float length = map(playingStage.jiki.releaseWaitCount - playingStage.jiki.getCount(), 0, playingStage.jiki.releaseWaitFrame, 0, 32);
                pg.noFill();
                pg.stroke(255);
                pg.strokeWeight(3);
                pg.line(playingStage.jiki.getX() - 16, playingStage.jiki.getY() - 16 - 8, playingStage.jiki.getX() - 16 + length, playingStage.jiki.getY() - 16 - 8);
            }
        pg.endDraw();
    }

    void drawEnemyCount(){
        pg.beginDraw();
            if(playingStage.jiki.getX() < 32 && playingStage.jiki.getY() < 32){
                pg.fill(255, 127);
            }else{
                pg.fill(255);
            }
            pg.textFont(kinkakuji, 16);
            pg.text("Enemys : " + playingStage.getEnemyCount(), 0, 16 * 2);
        pg.endDraw();
    }

    void drawTekidanCount(){
        pg.beginDraw();
            if(playingStage.jiki.getX() < 32 && playingStage.jiki.getY() < 16 * 3){
                pg.fill(255, 127);
            }else{
                pg.fill(255);
            }
            pg.textFont(kinkakuji, 16);
            pg.text("Shots : " + playingStage.getShotCount(), 0, 16 * 3);
        pg.endDraw();
    }

    void drawScoreCount(){
        pg.beginDraw();
            if(playingStage.jiki.getX() < 32 && playingStage.jiki.getY() < 16 * 3){
                pg.fill(255, 127);
            }else{
                pg.fill(255);
            }
            pg.textFont(kinkakuji, 16);
            pg.text("Score : " + playingStage.getJiki().getScore(), 0, 16 * 3);
        pg.endDraw();
    }


    int cTextSize = 16;
    int cTextSize2 = 20;
    void drawControlAssist(){
        pg.beginDraw();

        pg.push();
        pg.noStroke();
        pg.fill(255);
        pg.textSize(cTextSize);
        pg.textAlign(RIGHT, BOTTOM);
        pg.text(getStringFromCode(gameKey[keyID.shot.getID()]) + ": Shot", width, height - cTextSize * 2);
        pg.text(getStringFromCode(gameKey[keyID.special.getID()]) + ": Special", width, height - cTextSize);
        pg.text(getStringFromCode(gameKey[keyID.absorb.getID()]) + ": Absorb", width, height);

        pg.textSize(cTextSize2);
        pg.text(getStringFromCode(gameKey[keyID.up.getID()]), width - cTextSize * 6, height - cTextSize2);
        pg.text(getStringFromCode(gameKey[keyID.down.getID()]), width - cTextSize * 6, height);
        pg.text(getStringFromCode(gameKey[keyID.right.getID()]), width - cTextSize * 6 + cTextSize2, height);
        pg.text(getStringFromCode(gameKey[keyID.left.getID()]), width - cTextSize * 6 - cTextSize2, height);

        pg.pop();

        pg.endDraw();
    }

    public void makeGauge(Enemy _e){
        isGaugeUsing = true;
        gauge.makeGauge(_e);
    }

    void getStage(){
        playingStage = playingStage;
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