class Jiki extends Machine{
  private float speed = 3.0f;
  private float slowSpeed = 1.5f;
  private int invincibleFrame = 30;
  private int invincibleCount = 0;
  private int absorbFrame = 60;
  private int absorbCount = 0;
  private int absorbArea = 0;
  private int absorbMaxArea = 64;
  private int releaseWaitFrame = 30;
  private int releaseWaitCount = 0;
  private float RedP, GreenP, BlueP;
  private boolean isRelease = false;  //開放しているかどうか
  private float absorbPower = 0;  //吸収は連打できるようにしない。時間で吸収用のパワが増える
  private int totalItem = 0;  //集めたアイテムの総数　特定個でエクステンド

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
    RedP = 0;
    GreenP = 0;
    BlueP = 0;

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
    shot();
    hit();
    absorb(playingStage.buffer);
    release();
    bound();
  }

  @Override
  //ここ醜すぎるので後でなおす
  void drawMe(PGraphics pg){
    pg.beginDraw();

    pg.push();
      pg.blendMode(ADD);
      if(!slow){
        //通常時のエフェクト
        pg.noStroke();
        pg.fill(255, 0, 0, RedP);
        easyTriangle(pg, pos.x + cos(radians(0 + count)) * 8, pos.y + sin(radians(0 + count)) * 8, 0, 16);
        pg.fill(0, 255, 0, GreenP);
        easyTriangle(pg, pos.x + cos(radians(120 + count)) * 8, pos.y + sin(radians(120 + count)) * 8, 0, 16);
        pg.fill(0, 0, 255, BlueP);
        easyTriangle(pg, pos.x + cos(radians(240 + count)) * 8, pos.y + sin(radians(240 + count)) * 8, 0, 16);
      }else{
        if(isRelease){
          //開放中のエフェクト
          pg.noStroke();
          pg.fill(255, 0, 0, RedP / 2);
          easyTriangle(pg, pos.x + cos(radians(0 + count)) * 8, pos.y + sin(radians(0 + count)) * 8, 0, 16);
          pg.fill(0, 255, 0, GreenP / 2);
          easyTriangle(pg, pos.x + cos(radians(120 + count)) * 8, pos.y + sin(radians(120 + count)) * 8, 0, 16);
          pg.fill(0, 0, 255, BlueP / 2);
          easyTriangle(pg, pos.x + cos(radians(240 + count)) * 8, pos.y + sin(radians(240 + count)) * 8, 0, 16);
        }else{
          //低速移動の時のエフェクト
          pg.noFill();
          pg.strokeWeight(1.5);
          pg.stroke(255, 0, 0, RedP);
          easyTriangle(pg, pos.x + cos(radians(0 + count)) * 8, pos.y + sin(radians(0 + count)) * 8, 0, 16);
          pg.stroke(0, 255, 0, GreenP);
          easyTriangle(pg, pos.x + cos(radians(120 + count)) * 8, pos.y + sin(radians(120 + count)) * 8, 0, 16);
          pg.stroke(0, 0, 255, BlueP);
          easyTriangle(pg, pos.x + cos(radians(240 + count)) * 8, pos.y + sin(radians(240 + count)) * 8, 0, 16);
        }
      }
      if((isInvincible() && count % 2 == 0) || isRelease == true){
        //無敵時間さん！？の機体点滅
        pg.fill(0);
      }else if(slow){
        //低速移動の時は機体の色薄くする
        pg.fill(getColor(), 127);
      }else{
        //通常時の機体色
        pg.fill(getColor());
      }
      pg.strokeWeight(1.5);
      pg.stroke(getColor());
      easyTriangle(pg, pos, 0, 16);
    pg.pop();

    pg.endDraw();
    pg.beginDraw();

    pg.noStroke();
    if(isRelease){
      pg.stroke(0);
      pg.strokeWeight(1);
      pg.fill(255);
    }else{
      pg.noStroke();
      pg.fill(0);
    }

    //当たり判定部分
    pg.ellipse(pos.x, pos.y, size * 2, size * 2);

    pg.endDraw();
  }

  void bound(){
    pos = new PVector(min(max(pos.x, 0), width), min(max(pos.y, 0), height));
  }

  void shot(){
    if(z){
      if(count % 8 == 0){
        shotSound.play(0);
        //print("z");
        float kakudo = 10;
        float kyori = 2;
        for(int i = 0; i < 4; i++){
          Shot shot = new Shot(pos.x + 24, pos.y - kyori + i * kyori * 0.75, 0, 0);
          shot.size =(4);
          shot.col = (color(180));
          shot.accel =(new PVector(0.25 * cos(radians(-kakudo + kakudo * 0.75 * i)), 0.25 * sin(radians(-kakudo + kakudo * 0.75 * i))));
          //shot.setBlendStyle(ADD);
          stage.addJikiShot(shot);
        }
      }
    }
  }

  //赤：追尾弾
  //青：デカレーザー、弾消し効果あり
  //緑：自機周りのバリア、確率で弾消し
  void releaseShot(){
    if(RedP > 0){
      if(count % 5 == 0){
        RedP = max(RedP - 30, 0);
        JikiRockOnShot redShot = new JikiRockOnShot(pos.x, pos.y);
        redShot.setSize(10);

        stage.addJikiShot(redShot);
      }
    }
    if(GreenP > 0){
      GreenP = max(GreenP - 5, 0);
      JikiBarrierShot greenShot = new JikiBarrierShot(pos.x, pos.y);
      stage.addJikiShot(greenShot);
    }
    if(BlueP > 0){
      if(count % 3 == 0){
        BlueP = max(BlueP - 16, 0);
        JikiBlueLaser blueShot = new JikiBlueLaser(pos.x + 10, pos.y);
        stage.addJikiShot(blueShot);
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
      if(s.collision(this) && s.isHittable){
        hitSound.play(0);
        if(s.isDeletable){s.kill();}
        HPDown(1);
        continue; //被弾した弾を吸収しないようにする（この状況は発生するんか？）
      }

      //吸収システム用の判定(吸収円にさわった敵弾をアイテム化)
      if(isAbsorbing()){
        float d = dist(pos.x, pos.y, s.getX(), s.getY());
        if(d < s.getSize() + absorbArea && s.isDeletable == true && s.isHittable){
          Item i = new Item(s.getX(), s.getY(), red(s.getColor()), green(s.getColor()), blue(s.getColor()));
          s.kill();
          stage.addItem(i);
          //print("absorb");
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
      absorbArea += absorbMaxArea / absorbFrame;
      pg.beginDraw();
      pg.stroke(255);
      pg.strokeWeight(1);
      if(gameConfig.isGlow){
        pg.fill(255, 180 / absorbFrame * (absorbCount - count));
      }else{
        pg.noFill();
      }
      pg.ellipse(pos.x, pos.y, absorbArea * 2, absorbArea * 2);
      pg.endDraw();
    }else{
      if(!isInvincible() && !isRelease && c){
        if(absorbArea > 0){
          absorbArea = 0;
        }

        //ここ吸収ボタンおしたときの処理
        absorbSound.play(0);
        absorbCount = count + absorbFrame;
        //print("c");
      }
    }
  }

  //リリース処理とリリース時の挙動が一緒に書いてあるのでわかりづらい・・・
  void release(){
    if(isRelease){
      releaseShot();
      if(!canRelease() || (x && count > releaseWaitCount)){
        isRelease = false;
      }
    }else{
      if(x && canRelease()){
        releaseSound.play(0);
        releaseWaitCount = count + releaseWaitFrame;
        isRelease = true;
      }
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
    if(absorbCount > count){
      return true;
    }else{
      return false;
    }
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
