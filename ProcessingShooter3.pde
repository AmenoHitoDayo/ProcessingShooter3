import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import java.util.ArrayList;
import java.util.Iterator;

public Stage playingStage;
public Title title;
public Scene scene = Scene.TitleScene;
Minim minim;
public int defaultHP = 10;
public float fps = 60.0f;

public PFont kinkakuji;

void setup() {
    size(640, 480);
    background(0);
    frameRate(fps);
    //smooth();
    kinkakuji = loadFont("Kinkakuji-Normal-48.vlw");

    minim = new Minim(this);
    //playingStage = new Stage01();
    title = new Title();
}

void draw() {
    //background(0);
    
    switch(scene){
        case TitleScene:
            title.updateMe();
            title.drawMe();
        break;
        case GameScene:
            playingStage.updateMe();
            playingStage.drawMe();
        break;
        case GameOverScene:
            gameOver();
        break;
    }
}

void keyPressed(){
    switch(scene){
        case TitleScene:
            title.keyPressed();
        break;
        case GameScene:
            playingStage.keyPressed();
        break;
        case GameOverScene:
            gameOverKeyPressed();
        break;
    }
}

void keyReleased() {
    switch(scene){
        case TitleScene:

        break;
        case GameScene:
            playingStage.keyReleased();
        break;
    }
}
