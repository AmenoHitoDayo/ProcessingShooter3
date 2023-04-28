public final int defaultKey[] = {UP, DOWN, LEFT, RIGHT, 'Z', 'X', 'C', SHIFT};
public int gameKey[] = {UP, DOWN, LEFT, RIGHT, 'Z', 'X', 'C', SHIFT};

class KeyConfig{
    boolean isKeySelecting = false;
    int selection = 0;
    PGraphics buffer;
    PVector pos;

    final int topY = 128;
    final int margin = 36;
    
    final String[] koumokuText = {
        "Move UP",
        "Move Down",
        "Move Left",
        "Move Right",
        "Shot",
        "Special",
        "Absorb",
        "Slow",
        "Default",
        "Back"
    };

    KeyConfig(){
        buffer = createGraphics(width, height);
        refreshPos();
    }

    public void drawMe(){
        image(buffer, 0, 0);

        buffer.beginDraw();
            buffer.background(0);
            drawMoji();
            drawArrow(buffer, pos);
        buffer.endDraw();
    }

    void drawMoji(){
        buffer.push();

        buffer.textFont(kinkakuji);
        buffer.textAlign(LEFT, CENTER);
        buffer.fill(255);
        buffer.noStroke();

        buffer.textSize(48);
        buffer.text("Key Setting", 32 - 16, 48);

        buffer.textSize(32);
        for(int i = 0; i < koumokuText.length; i++){
            buffer.text(koumokuText[i], 64, topY + margin * i);

            if(i >= gameKey.length)continue;
            buffer.text(getStringFromCode(gameKey[i]), width / 2, topY + margin * i);
        }

        buffer.pop();
    }

    void refreshPos(){
        if(selection < 0)selection = 0;
        if(selection > koumokuText.length - 1)selection = koumokuText.length - 1;

        pos = new PVector(32, topY + margin * selection);
    }

    public void KeyPressed(){
        if(keyCode == UP){
            selection--;
        }
        if(keyCode == DOWN){
            selection++;
        }
        refreshPos();
    }
}
