//キーコンも入れたい
class Config{   //設定画面
    int selection = 0;  //何番目の項目を選んでいるか
    ConfigStruct config;    //

    Config(){
        config = new ConfigStruct();
        config.CopyConfig(gameConfig);
    }

    String[] koumokuText = {
        "初期ライフ",   //みたまんま
        "操作説明", //ゲーム画面に操作説明を出すか
        "BGM音量",  
        "効果音音量",
        "グロウ効果"    
    };

    Option(){
        selection = 0;
    }

    //画面遷移してきたらコンフィグの設定をgameConfigからコピーして表示
    //左右キーで設定変更
}

public class ConfigStruct{
    int defaultLife;
    boolean  isControlAssist;
    int bgmSize;
    int seSize;
    boolean isGlow = true;

    ConfigStruct(){
        defaultLife = 10;
        isControlAssist = false;
        bgmSize = 10;
        seSize = 10;
        isGlow = true;
    }

    public void CopyConfig(ConfigStruct baseConfig){
        this.defaultLife = baseConfig.defaultLife;
        this.isControlAssist = baseConfig.isControlAssist;
        this.bgmSize = baseConfig.bgmSize;
        this.seSize = baseConfig.seSize;
        this.isGlow = baseConfig.isGlow;
    }
}