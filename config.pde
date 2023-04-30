//キーコンも入れたい
class Config extends Menu{   //設定画面
    ConfigStruct struct;    //

    Config(){
        super();

        struct = new ConfigStruct();
        struct.CopyConfig(gameConfig);

        topY = 128;
        margin = 40;

        koumokuText = new ArrayList<>(
            Arrays.asList(
                "Default Life",   //みたまんま
                "Controll Assist", //ゲーム画面に操作説明を出すか
                "BGM Volume",  
                "SE Volume",
                "Glow Effect",
                "Key Setting",
                "Default",
                "Back"
            )
        );
    }

    public void keyPressed(){
        super.keyPressed();
        if(keyCode == gameKey[keyID.left.getID()]){
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
        if(keyCode == gameKey[keyID.right.getID()]){
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
        if(keyCode == RETURN || keyCode == ENTER || keyCode == gameKey[keyID.shot.getID()]){
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

    void drawMoji(){
        super.drawMoji();

        buffer.push();

        buffer.textFont(kinkakuji);
        buffer.textAlign(LEFT, CENTER);
        buffer.fill(255);
        buffer.noStroke();

        buffer.textSize(48);
        buffer.text("Config", 32 - 16, 48);

        buffer.textSize(charSize);
        for(int i = 0; i < koumokuText.size(); i++){
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