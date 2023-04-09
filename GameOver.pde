boolean isGameOverAppeard = false;

void gameOver(){
    if(isGameOverAppeard == false){
        noStroke();
        fill(0, 127);
        rect(0, 0, width, height);

        push();
            textFont(kinkakuji);
            textAlign(CENTER);
            fill(255);
            textSize(48);
            text("Game Over", width / 2, height / 2);
            textSize(24);
            text("Zキーでタイトルにもどります", width / 2, height / 2 + 52);
        pop();
        isGameOverAppeard = true;
    }
}

void gameOverKeyPressed(){
    if(key == 'Z' || key == 'z'){
        scene = Scene.TitleScene;
        isGameOverAppeard = false;
    }
}

void gameClear(){
    background(0);
    noStroke();
    fill(0, 127);
    rect(0, 0, width, height);

    push();
        textFont(kinkakuji);
        textAlign(CENTER);
        fill(255);
        textSize(48);
        text("Game Clear!", width / 2, height / 2);
        textSize(24);
        text("Zキーでタイトルにもどります", width / 2, height / 2 + 52);
    pop();
}