public final int defaultKey[] = {UP, DOWN, LEFT, RIGHT, 'Z', 'X', 'C', SHIFT};
public int gameKey[] = {UP, DOWN, LEFT, RIGHT, 'Z', 'X', 'C', SHIFT};

class KeyConfig extends Menu{
    boolean isKeySelecting = false;

    KeyConfig(){
        super();

        topY = 128;
        margin = 36;
        charSize = 28;

        koumokuText = new ArrayList<>(
            Arrays.asList(
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
            )
        );
    }

    void drawMoji(){
        super.drawMoji();

        buffer.push();

        buffer.textFont(kinkakuji);
        buffer.textAlign(LEFT, CENTER);
        buffer.fill(255);
        buffer.noStroke();

        buffer.textSize(48);
        buffer.text("Key Setting", 32 - 16, 48);

        buffer.textSize(32);
        for(int i = 0; i < koumokuText.size(); i++){
            if(i >= gameKey.length)continue;
            
            //コンフィグ中ならそれわかりやすく
            if(isKeySelecting && selection == i){
                buffer.fill(127);
            }else{
                buffer.fill(255);
            }
            buffer.text(getStringFromCode(gameKey[i]), width / 2, topY + margin * i);
        }

        buffer.pop();
    }

    public void keyPressed(){
        if(isKeySelecting){
            if(selection >= gameKey.length){
                isKeySelecting = false;
                return;
            }
            //同一キー割り当て防止
            for(int i = 0; i < gameKey.length; i++){
                if(i == selection)continue;
                if(keyCode == gameKey[i]) return;
            }
            gameKey[selection] = keyCode;
            isKeySelecting = false;
        }else{
            super.keyPressed();

            if(keyCode == RETURN || keyCode == ENTER || keyCode == gameKey[keyID.shot.getID()]){
                if(selection == 8){
                    for(int i = 0; i < gameKey.length; i++){
                        gameKey[i] = defaultKey[i];
                    }
                }else if(selection == 9){
                    scene = Scene.ConfigScene;
                }else{
                    isKeySelecting = true;
                }
            }
        }
    }
}