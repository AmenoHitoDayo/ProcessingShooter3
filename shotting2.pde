import java.util.ArrayList;
import java.util.Iterator;

Stage stage;
boolean right = false, left = false, up = false, down = false, z = false, slow = false;

void setup() {
    size(640, 480);
    background(0);
    stage = new SampleStage();
}

void draw() {
    background(0);
    stage.updateMe();
}

void keyPressed(){
    if(key == 'w' || keyCode == UP) up = true;
    if(key == 'd' || keyCode == RIGHT) right = true;
    if(key == 's' || keyCode == DOWN) down = true;
    if(key == 'a' || keyCode == LEFT) left = true;
    if(key == 'z') z = true;
    if(keyCode == SHIFT) slow = true;
}

void keyReleased() {
    if(key == 'w' || keyCode == UP) up = false;
    if(key == 'd' || keyCode == RIGHT) right = false;
    if(key == 's' || keyCode == DOWN) down = false;
    if(key == 'a' || keyCode == LEFT) left = false;
    if(key == 'z') z = false;
    if(keyCode == SHIFT) slow = false;
}
