class Jiki extends Machine{
  private float speed = 3.0f;
  private float slowSpeed = 1.5f;
  private final int invincibleFrame = 30;  //無敵時間さん！？の長さ
  private int invincibleCount = 0;
  private final int absorbMaxFrame = 240; //何Fまで吸収フィールドを開けていられるか
  private int absorbFrame = absorbMaxFrame;
  private int absorbArea = 64;
  private final int absorbMaxArea = 128;
  private final int releaseWaitFrame = 30;
  private int releaseWaitCount = 0;
  private float RedP, GreenP, BlueP;
  private boolean isRelease = false;  //開放しているかどうか
  private float absorbPower = 0;  //吸収は連打できるようにしない。時間で吸収用のパワが増える
  private int totalItem = 0;  //集めたアイテムの総数　特定個でエクステンド
  private int absorbForbidCount = 0;

  private AudioPlayer shotSound;
  private AudioPlayer hitSound;
  private AudioPlayer absorbSound;
  private AudioPlayer itemSound;
  private AudioPlayer extendSound;
  private AudioPlayer releaseSound;

  private Stage stage;


  //キー操作用のbool群
  private boolean right = false, left = false, up = false, down = false, slow = false, z = false, x = false, c = false;

  Jiki(){
    super(width / 2, height / 2, gameConfig.defaultLife);
    col = (color(255, 255, 255, 255));
    size =(4);
    RedP = 127;
    GreenP = 127;
    BlueP = 127;

    shotSound = minim.loadFile("maou_se_battle11.mp3");
    setSEGain(shotSound, -20f);
    hitSound = minim.loadFile("魔王魂 効果音 システム09.mp3");
    setSEGain(hitSound, 0f);
    absorbSound = minim.loadFile("魔王魂  マジカル15.mp3");
    setSEGain(absorbSound, 0f);
    itemSound = minim.loadFile("魔王魂 効果音 ジッポ-開ける音.mp3");
    setSEGain(itemSound, 0f);
    extendSound = minim.loadFile("maou_se_magical14.mp3");
    setSEGain(extendSound, 0f);
    releaseSound = minim.loadFile("maou_se_magical14.mp3");
    setSEGain(releaseSound, 0f);
  }

  void updateMe(Stage _s){
    super.updateMe();
    stage = _s;
    vel = (new PVector(0, 0));
    if(keyPressed){
      if(up){
          vel.add(VectorUP());
      }
      if(left){
          vel.add(VectorLeft());
      }
      if(down){
          vel.add(VectorDown());
      }
      if(right){
          vel.add(VectorRight());
      }
    }
    vel.normalize();
    if(slow){
      vel.mult(slowSpeed);
    }else{
      vel.mult(speed);
    }
    bound();

    shot();
    hit();
    absorb(playingStage.buffer);
    release();
  }

  @Override
  void drawMe(PGraphics pg){
    pg.beginDraw();

    pg.strokeWeight(1);
    pg.stroke(255);
    pg.fill(RedP, GreenP, BlueP);
    easyTriangle(pg, pos.x, pos.y, 0, 16);

    //当たり判定部分
    pg.strokeWeight(0.5);
    pg.stroke(255);
    pg.fill(0);
    pg.circle(pos.x, pos.y, size * 2);

    pg.endDraw();
  }

  void bound(){
    pos = new PVector(min(max(pos.x, 0), width), min(max(pos.y, 0), height));
  }

  void shot(){  //通常ショットを、色パワーを消費して射撃するものに
    if(z){
      if(count % 8 == 0){
        shotSound.play(0);

        if(RedP > 0){
          JikiRedShot rs = new JikiRedShot(pos.x + 24, pos.y - 16);
          stage.addJikiShot(rs);
          RedP--;
        }

        if(GreenP > 0){
          JikiGreenShot gs = new JikiGreenShot(pos.x + 24, pos.y);
          stage.addJikiShot(gs);
          GreenP--;
        }

        if(BlueP > 0){
          JikiBlueShot bs = new JikiBlueShot(pos.x + 24, pos.y + 16);
          stage.addJikiShot(bs);
          BlueP--;
        }
      }
    }
  }

  void hit(){
    List<Mover> shots = stage.enemyShots.getArray();
    Iterator<Mover> it = shots.iterator();
    
    while(it.hasNext()){
      
      if(isInvincible()) break;

      Mover m = it.next();
      if(!(m instanceof Shot))continue;
      Shot s = (Shot)m;

      //被弾判定
      //collision関数はmoverのデフォであったほうがいいね多分これ・・
      if(s.collision(this) && s.isHittable()){
        hitSound.play(0);
        if(s.isDeletable()){s.kill();}
        HPDown(1);
        continue; //被弾した弾を吸収しないようにする（この状況は発生するんか？）
      }

      //吸収システム用の判定(吸収円にさわった敵弾をアイテム化)
      if(isAbsorbing()){
        float d = dist(pos.x, pos.y, s.getX(), s.getY());
        //absorbedがtrue = hittableがfalse になるはずなんで、absorbedでの分岐は書いてないが、変だったらその分岐も書く。
        if(d < s.getSize() + absorbArea && s.isDeletable == true && s.isHittable()){
          Item i = new Item(s.getX(), s.getY(), red(s.getColor()), green(s.getColor()), blue(s.getColor()));
          s.absorbed();
          stage.addItem(i);
        }
      }
      
    }
  
    Iterator<Mover> it2 = stage.getEnemys().iterator();
    //敵との接触判定
    while(it2.hasNext()){
      Mover m = it2.next();
      if(!(m instanceof Enemy))continue;
      Enemy e = (Enemy)m;
      if(e.collision(this) && !isInvincible()){
        e.HPDown(1);
        HPDown(1);

        hitSound.play(0);

        continue;
      }
    }

    //アイテム取得判定
    List<Mover> items = stage.getItems();
    for(int i = 0; i < items.size(); i++){
      Mover m = items.get(i);
      if(!(m instanceof Item))continue;
      Item item = (Item)m;

      if(item.collision(this)){
        totalItem++;
        if(totalItem % 255 == 0){
          extendSound.play(0);
          HP++;
        }
        float[] colorPoints = item.getColorPoints();
        itemSound.play(0);
        getColorPoint(colorPoints[0] / 30, colorPoints[1] / 30, colorPoints[2] / 30);

        stage.removeItem(item);
      }
    }
  }

  void absorb(PGraphics pg){
    if(isAbsorbing()){
      absorbArea = floor(map(absorbFrame, 0, absorbMaxFrame, size * 2, absorbMaxArea));

      pg.beginDraw();
        pg.stroke(255);
        pg.strokeWeight(1);
        pg.fill(255, 64);
        pg.circle(pos.x, pos.y, absorbArea * 2);
      pg.endDraw();

      absorbFrame--;

      if(absorbFrame == 0)absorbForbidCount = 60;
    }else{
      if(count % 2 == 0)absorbFrame = min(absorbFrame + 1, absorbMaxFrame);
      if(absorbForbidCount > 0)absorbForbidCount--;
    }
  }

  //リリース処理とリリース時の挙動が一緒に書いてあるのでわかりづらい・・・
  void release(){
    if(x){
      if(RedP > 1 && GreenP > 1 && BlueP > 1 && releaseWaitCount == 0){
        //全弾削除処理
        //全敵にダメージ処理
        //エフェクト処理
        RedP = GreenP = BlueP = 0;
        releaseWaitCount = releaseWaitFrame;
      }
    }else{
      releaseWaitCount = max(0, releaseWaitCount - 1);
    }
  }

  void keyPressed(){
    if(keyCode == gameKey[keyID.up.getID()]) up = true;
    if(keyCode == gameKey[keyID.right.getID()]) right = true;
    if(keyCode == gameKey[keyID.down.getID()]) down = true;
    if(keyCode == gameKey[keyID.left.getID()]) left = true;
    if(keyCode == gameKey[keyID.shot.getID()]) z = true;
    if(keyCode == gameKey[keyID.special.getID()]) x = true;
    if(keyCode == gameKey[keyID.absorb.getID()]) c = true;
    if(keyCode == gameKey[keyID.slow.getID()]) slow = true;
  }

  void keyReleased(){
    if(keyCode == gameKey[keyID.up.getID()]) up = false;
    if(keyCode == gameKey[keyID.right.getID()]) right = false;
    if(keyCode == gameKey[keyID.down.getID()]) down = false;
    if(keyCode == gameKey[keyID.left.getID()]) left = false;
    if(keyCode == gameKey[keyID.shot.getID()]) z = false;
    if(keyCode == gameKey[keyID.special.getID()]) x = false;
    if(keyCode == gameKey[keyID.absorb.getID()]) c = false;
    if(keyCode == gameKey[keyID.slow.getID()]) slow = false;
  }

  @Override
  void HPDown(int i){
    if(!isInvincible()){
      super.HPDown(i);
      invincibleCount = count + invincibleFrame;
    }
  }

  public void getColorPoint(float R, float G, float B){
    RedP = min(255, RedP + R);
    GreenP = min(255, GreenP + G);
    BlueP = min(255, BlueP + B);
  }

  public int getScore(){
    return totalItem;
  }

  boolean isInvincible(){
    if(invincibleCount > count){
      return true;
    }else{
      return false;
    }
  }

  boolean isAbsorbing(){
    return c && (absorbFrame >= 0) && (absorbForbidCount == 0);
  }

  boolean canRelease(){
    if(RedP > 0 || GreenP > 0 || BlueP > 0){
      return true;
    }else{
      return false;
    }
  }

  public void setHP(int _HP){
    HP = min(maxHP, _HP);
  }
}
//てすと02
