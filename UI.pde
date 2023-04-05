class UI{
    private Stage stage;
    private boolean isGaugeUsing = false;
    private HPGauge gauge;
    private PGraphics pg;
    
    UI(){
        stage = playingStage;
    }

    void drawMe(PGraphics _pg){
        pg = _pg;
        drawHP();
        drawColorPoint();
        drawReleaseWaitGauge();
        drawEnemyCount();
        drawTekidanCount();
    }
    
    void updateMe(Stage s){
        stage = s;
    }

    void drawHP(){
        pg.beginDraw();
            if(stage.getJiki().getX() < 32 && stage.getJiki().getY() < 16){
                pg.fill(255, 127);
            }else{
                pg.fill(255);
            }
            pg.textSize(16);
            pg.text("HP : " + stage.jiki.getHP(), 0, 16);
        pg.endDraw();
    }

    void drawColorPoint(){
        pg.beginDraw();
            if(stage.jiki.getX() < 64 && stage.jiki.getY() > height - 16 * 2){
                pg.fill(255, 127);
            }else{
                pg.fill(255);
            }
            pg.textSize(16);
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
            pg.textSize(16);
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
            pg.textSize(16);
            pg.text("Shots : " + stage.getShotCount(), 0, 16 * 3);
        pg.endDraw();
    }

    void getStage(){
        stage = playingStage;
    }
}

class HPGauge{
    private Enemy baseEnemy;
    private float maxHP = 0f;
    private float currentHP = 0f;

    HPGauge(Enemy _e){
        baseEnemy = _e;
        maxHP = baseEnemy.getHP();
        currentHP = maxHP;
    }

    void updateMe(){
        currentHP = baseEnemy.getHP();
    }

    void drawMe(){
        float maxLength = width - 60;
        float rectLength = maxLength * (currentHP / maxHP);

        stroke(255);
        strokeWeight(3);
        noFill();
        rect(30, 10, width - 30, 50);
        stroke(0);
        strokeWeight(2);
        fill(255);
        rect(30, 10, 30 + rectLength, 50);
    }
}