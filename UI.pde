class UI{
    Stage stage;
    
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
        if(stage.jiki.pos.x < 32 && stage.jiki.pos.y < 32){
            fill(255, 127);
        }else{
            fill(255);
        }
        textSize(16);
        text("HP : " + stage.jiki.HP, 0, 16);
    }

    void drawColorPoint(){
        if(stage.jiki.pos.x < 64 && stage.jiki.pos.y > height - 16 * 2){
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
        if(stage.jiki.releaseWaitCount > stage.jiki.count){
            float length = map(stage.jiki.releaseWaitCount - stage.jiki.count, 0, stage.jiki.releaseWaitFrame, 0, 32);
            noFill();
            stroke(255);
            strokeWeight(3);
            line(stage.jiki.pos.x - 16, stage.jiki.pos.y - 16 - 8, stage.jiki.pos.x - 16 + length, stage.jiki.pos.y - 16 - 8);
        }
    }

    void getStage(){
        stage = playingStage;
    }
}