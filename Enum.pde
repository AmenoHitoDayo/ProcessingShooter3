
public enum Scene{
    TitleScene,
    GameScene,
    GameOverScene,
    GameClearScene,
    ConfigScene,
    KeyConfigScene
}

public enum ShotStyle{
    Orb,
    Oval,
    Rect,
    Glow
}

public enum JikiState{
    normal,
    absorbing,
    releasing,
    invincible,
}

public enum keyID{
    up(0),
    down(1),
    left(2),
    right(3),
    shot(4),
    special(5),
    absorb(6),
    slow(7);

    private int id;
    keyID(int id){
        this.id = id;
    }

    public int getID(){
        return this.id;
    }
}