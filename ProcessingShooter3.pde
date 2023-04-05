import java.util.ArrayList;
import java.util.Iterator;

public Stage playingStage;
public UI ui;
boolean right = false, left = false, up = false, down = false, z = false, slow = false, c = false;
public Scene scene = Scene.GameScene;

public enum Scene{
    TitleScene,
    GameScene,
    GameOverScene,
    GameClearScene
}

void setup() {
    size(640, 480);
    background(0);
    //smooth();

    playingStage = new Stage01();
    ui = new UI();
}

void draw() {
    background(0);
    playingStage.updateMe();
    playingStage.drawMe();
    ui.drawMe();
}

void keyPressed(){
    playingStage.jiki.releaseKey();

    if(key == 'w' || keyCode == UP) up = true;
    if(key == 'd' || keyCode == RIGHT) right = true;
    if(key == 's' || keyCode == DOWN) down = true;
    if(key == 'a' || keyCode == LEFT) left = true;
    if(key == 'z' || key == 'Z') z = true;
    if(key == 'c' || key == 'C') c = true;
    if(keyCode == SHIFT) slow = true;
}

void keyReleased() {
    if(key == 'w' || keyCode == UP) up = false;
    if(key == 'd' || keyCode == RIGHT) right = false;
    if(key == 's' || keyCode == DOWN) down = false;
    if(key == 'a' || keyCode == LEFT) left = false;
    if(key == 'z' || key == 'Z') z = false;
    if(key == 'c' || key == 'C') c = false;
    if(keyCode == SHIFT) slow = false;
}
