//★Begindraw/endDraw 問題（どこに書けばいいのか）
//いちいちbegin/endするのはめんどいから、Stage/Title/Config(一番外側)でbegin/endすればいい？
//不用意にenddrawするとその後のものが現れなくなる可能性があるs

//俺より:とりあえず最適化とか、処理効率のことは考えないで作っていいです。
//https://www.ikemo3.com/dic/premature-optimization/

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import java.util.List;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Iterator;
import java.util.Arrays;

public Stage playingStage;
public Title title;
public Config config;
public KeyConfig keyConfig;
public Scene scene = Scene.TitleScene;
public FPSChecker checker;
Minim minim;
public float fps = 60.0f;
public int finalScore = 0;

public PFont kinkakuji;

public final ConfigStruct defaultConfig = new ConfigStruct(); //初期状態コンフィグ
public ConfigStruct gameConfig = new ConfigStruct();        //実際にゲーム内で適用するコンフィぐ

//定数 これ以上増えない残機
public final int maxHP = 30;

void setup() {
    size(640, 480);
    background(0);
    frameRate(fps);
    //smooth();
    kinkakuji = loadFont("Kinkakuji-Normal-48.vlw");

    minim = new Minim(this);
    //playingStage = new Stage01();
    title = new Title();
    config = new Config();
    keyConfig = new KeyConfig();
    checker = new FPSChecker();
}

void draw() {
    //background(0);
    println(checker.getFPS());
    
    switch(scene){
        case TitleScene:
            //title.updateMe();
            title.drawMe();
        break;
        case GameScene:
            playingStage.updateMe();
            playingStage.drawMe();
        break;
        case GameOverScene:
            gameOver();
        break;
        case GameClearScene:
            gameClear();
        break;
        case ConfigScene:
            config.drawMe();
        break;
        case KeyConfigScene:
            keyConfig.drawMe();
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
        case GameClearScene:
            gameOverKeyPressed();
        break;
        case ConfigScene:
            config.keyPressed();
        break;
        case KeyConfigScene:
            keyConfig.keyPressed();
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
