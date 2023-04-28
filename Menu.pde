class Menu{
    int selection = 0;//何番目の項目を選んでいるか
    PVector pos;

    PGraphics buffer;

    int topY = 128;
    int margin = 48;
    int charSize = 32;

    List<String> koumokuText;

    Menu(){
        buffer = createGraphics(width, height);

        koumokuText = new ArrayList<>(
            Arrays.asList(
                "これは",
                "テスト",
                "だよ",
                "おい見ろよ、あいつは確か・・・"
            )
        );

        refreshPos();
    }

    public void drawMe(){
        image(buffer, 0, 0);

        buffer.beginDraw();

        buffer.background(0);
        drawMoji();
        drawArrow();

        buffer.endDraw();
    }

    void drawArrow(){
        buffer.fill(255);
        easyTriangle(buffer, pos, 0, 16);
        buffer.fill(0);
        buffer.ellipse(pos.x, pos.y, 8, 8);
    }

    void drawMoji(){
        buffer.push();

        buffer.textAlign(LEFT, CENTER);
        buffer.noStroke();
        buffer.fill(255);
        buffer.textFont(kinkakuji);
        buffer.textSize(charSize);
        for(int i = 0; i < koumokuText.size(); i++){
            buffer.text(koumokuText.get(i), 64, topY + margin * i);
        }

        buffer.pop();
    }

    void keyPressed(){
        if(keyCode == gameKey[keyID.down.getID()]){
            selection++;
        }else if(keyCode == gameKey[keyID.up.getID()]){
            selection--;
        }
        refreshPos();
    }

    void refreshPos(){
        if(selection < 0)selection = 0;
        if(selection > koumokuText.size() - 1)selection = koumokuText.size() - 1;

        pos = new PVector(32, topY + margin * selection);
    }
}