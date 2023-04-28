//キーコンも入れたい
class Config{   //設定画面
    int selection = 0;  //何番目の項目を選んでいるか
    ConfigStruct struct;    //

    PGraphics buffer;
    PVector pos;

    final int topY = 128;
    final int margin = 40;

    final String[] koumokuText = {
        "Default Life",   //みたまんま
        "Controll Assist", //ゲーム画面に操作説明を出すか
        "BGM Volume",  
        "SE Volume",
        "Glow Effect",
        "Key Setting",
        "Default",
        "Back"
    };

    Config(){
        struct = new ConfigStruct();
        struct.CopyConfig(gameConfig);

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

    public void KeyPressed(){
        if(keyCode == UP){
            selection--;
        }
        if(keyCode == DOWN){
            selection++;
        }
        if(keyCode == LEFT){
            switch(selection){
                case(0):
                    struct.defaultLife = max(--struct.defaultLife, 1);
                break;
                case(1):
                    struct.isControlAssist = !struct.isControlAssist;
                break;
                case(2):
                    struct.bgmVolume = max(--struct.bgmVolume, 0);
                break;
                case(3):
                    struct.seVolume = max(--struct.seVolume, 0);
                break;
                case(4):
                    struct.isGlow = !struct.isGlow;
                break;
            }
        }
        if(keyCode == RIGHT){
            switch(selection){
                case(0):
                    struct.defaultLife = min(++struct.defaultLife, maxHP);
                break;
                case(1):
                    struct.isControlAssist = !struct.isControlAssist;
                break;
                case(2):
                    struct.bgmVolume = min(++struct.bgmVolume, 10);
                break;
                case(3):
                    struct.seVolume = min(++struct.seVolume, 10);
                break;
                case(4):
                    struct.isGlow = !struct.isGlow;
                break;
            }
        }
        if(keyCode == RETURN || keyCode == ENTER || key == 'Z' || key == 'z'){
            if(selection < 5){
                selection = 7;
            }else if(selection == 5){
                gameConfig.CopyConfig(struct);
                scene = Scene.KeyConfigScene;
            }else if(selection == 6){
                struct.CopyConfig(defaultConfig);
            }else if(selection == 7){
                gameConfig.CopyConfig(struct);
                scene = Scene.TitleScene;
            }
        }
        
        refreshPos();
    }

    void refreshPos(){
        if(selection < 0)selection = 0;
        if(selection > koumokuText.length - 1)selection = koumokuText.length - 1;

        pos = new PVector(32, topY + margin * selection);
    }

    void drawMoji(){
        buffer.push();

        buffer.textFont(kinkakuji);
        buffer.textAlign(LEFT, CENTER);
        buffer.fill(255);
        buffer.noStroke();

        buffer.textSize(48);
        buffer.text("Config", 32 - 16, 48);

        buffer.textSize(32);
        for(int i = 0; i < koumokuText.length; i++){
            buffer.text(koumokuText[i], 64, topY + margin * i);
            //すごい無意味を感じる
            switch(i){
                case(0):    //life
                    buffer.text(Integer.toString(struct.defaultLife) , width / 2, topY + margin * i);
                break;
                case(1):    //assist
                    buffer.text(Boolean.toString(struct.isControlAssist), width / 2, topY + margin * i);
                break;
                case(2):    //bgm
                    buffer.text(Integer.toString(struct.bgmVolume), width / 2, topY + margin * i);
                break;
                case(3):    //se
                    buffer.text(Integer.toString(struct.seVolume), width / 2, topY + margin * i);
                break;
                case(4):    //glow
                    buffer.text(Boolean.toString(struct.isGlow), width / 2, topY + margin * i);
                break;
            }
        }

        buffer.pop();
    }

    void initConfig(){
        selection = 0;
        refreshPos();
        struct.CopyConfig(gameConfig);
    }

    //画面遷移してきたらコンフィグの設定をgameConfigからコピーして表示
    //左右キーで設定変更
}

public class ConfigStruct{
    int defaultLife;
    boolean  isControlAssist;
    int bgmVolume;
    int seVolume;
    boolean isGlow = true;

    ConfigStruct(){
        defaultLife = 10;
        isControlAssist = false;
        bgmVolume = 10;
        seVolume = 10;
        isGlow = true;
    }

    public void CopyConfig(ConfigStruct baseConfig){
        this.defaultLife = baseConfig.defaultLife;
        this.isControlAssist = baseConfig.isControlAssist;
        this.bgmVolume = baseConfig.bgmVolume;
        this.seVolume = baseConfig.seVolume;
        this.isGlow = baseConfig.isGlow;
    }
}