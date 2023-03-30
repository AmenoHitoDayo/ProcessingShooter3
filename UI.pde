class UI{
    private Stage stage;
    
    UI(){
        stage = playingStage;
    }

    void drawMe(){
        drawHP();
        drawColorPoint();
        drawReleaseWaitGauge();
    }
    
    void updateMe(){

    }

    void drawHP(){
        if(stage.jiki.getX() < 32 && stage.jiki.getY() < 32){
            fill(255, 127);
        }else{
            fill(255);
        }
        textSize(16);
        text("HP : " + stage.jiki.getHP(), 0, 16);
    }

    void drawColorPoint(){
        if(stage.jiki.getX() < 64 && stage.jiki.getY() > height - 16 * 2){
            fill(255, 127);
        }else{
            fill(255);
        }
        textSize(16);
        text("RED : " + stage.jiki.RedP, 0, height - 16 * 2);
        text("GREEN : " + stage.jiki.GreenP, 0, height - 16 * 1);
        text("BLUE : " + stage.jiki.BlueP, 0, height - 16 * 0);
    }

    void drawReleaseWaitGauge(){
        if(stage.jiki.releaseWaitCount > stage.jiki.getCount()){
            float length = map(stage.jiki.releaseWaitCount - stage.jiki.getCount(), 0, stage.jiki.releaseWaitFrame, 0, 32);
            noFill();
            stroke(255);
            strokeWeight(3);
            line(stage.jiki.getX() - 16, stage.jiki.getY() - 16 - 8, stage.jiki.getX() - 16 + length, stage.jiki.getY() - 16 - 8);
        }
    }

    void getStage(){
        stage = playingStage;
    }
}