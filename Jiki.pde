class Jiki extends Machine{
  private float speed = 3.0f;
  private float slowSpeed = 1.5f;
  private int invincibleFrame = 30;
  private int invincibleCount = 0;
  private int absorbFrame = 60;
  private int absorbCount = 0;
  private int absorbArea = 0;
  private int absorbMaxArea = 150;
  private int releaseWaitFrame = 30;
  private int releaseWaitCount = 0;
  private float RedP, GreenP, BlueP;
  private boolean isRelease = false;  //開放しているかどうか
  private float absorbPower = 0;  //吸収は連打できるようにしない。時間で吸収用のパワが増える

  private AudioPlayer shotSound;
  private AudioPlayer hitSound;
  private AudioPlayer absorbSound;
  private AudioPlayer itemSound;

  Jiki(){
    super(width / 2, height / 2, defaultHP);
    setColor(color(255, 255, 255, 255));
    setSize(4);
    RedP = 0;
    GreenP = 0;
    BlueP = 0;

    shotSound = minim.loadFile("maou_se_battle11.mp3");
    shotSound.setGain(-30f);
    hitSound = minim.loadFile("魔王魂 効果音 システム09.mp3");
    hitSound.setGain(-10f);
    absorbSound = minim.loadFile("魔王魂  マジカル15.mp3");
    absorbSound.setGain(-10f);
    itemSound = minim.loadFile("魔王魂 効果音 ジッポ-開ける音.mp3");
    itemSound.setGain(-10f);
  }

  void updateMe(Stage stage){
    setVel(new PVector(0, 0));
    if(keyPressed){
      if(up){
          getVel().add(VectorUP());
      }
      if(left){
          getVel().add(VectorLeft());
      }
      if(down){
          getVel().add(VectorDown());
      }
      if(right){
          getVel().add(VectorRight());
      }
    }
    getVel().normalize();
    if(slow){
      getVel().mult(slowSpeed);
    }else{
      getVel().mult(speed);
    }
    shot(stage);
    hit(stage);
    absorb(playingStage.buffer);
    release(stage);
    super.updateMe(stage);
    bound();
  }

  void drawMe(PGraphics pg){
    pg.beginDraw();

    pg.push();
      pg.blendMode(ADD);
      if(!slow){
        //通常時のエフェクト
        pg.noStroke();
        pg.fill(255, 0, 0, RedP);
        easyTriangle(pg, getX() + cos(radians(0 + getCount())) * 8, getY() + sin(radians(0 + getCount())) * 8, 0, 16);
        pg.fill(0, 255, 0, GreenP);
        easyTriangle(pg, getX() + cos(radians(120 + getCount())) * 8, getY() + sin(radians(120 + getCount())) * 8, 0, 16);
        pg.fill(0, 0, 255, BlueP);
        easyTriangle(pg, getX() + cos(radians(240 + getCount())) * 8, getY() + sin(radians(240 + getCount())) * 8, 0, 16);
      }else{
        if(isRelease){
          //開放中のエフェクト
          pg.noStroke();
          pg.fill(255, 0, 0, RedP / 2);
          easyTriangle(pg, getX() + cos(radians(0 + getCount())) * 8, getY() + sin(radians(0 + getCount())) * 8, 0, 16);
          pg.fill(0, 255, 0, GreenP / 2);
          easyTriangle(pg, getX() + cos(radians(120 + getCount())) * 8, getY() + sin(radians(120 + getCount())) * 8, 0, 16);
          pg.fill(0, 0, 255, BlueP / 2);
          easyTriangle(pg, getX() + cos(radians(240 + getCount())) * 8, getY() + sin(radians(240 + getCount())) * 8, 0, 16);
        }else{
          //低速移動の時のエフェクト
          pg.noFill();
          pg.strokeWeight(1.5);
          pg.stroke(255, 0, 0, RedP);
          easyTriangle(pg, getX() + cos(radians(0 + getCount())) * 8, getY() + sin(radians(0 + getCount())) * 8, 0, 16);
          pg.stroke(0, 255, 0, GreenP);
          easyTriangle(pg, getX() + cos(radians(120 + getCount())) * 8, getY() + sin(radians(120 + getCount())) * 8, 0, 16);
          pg.stroke(0, 0, 255, BlueP);
          easyTriangle(pg, getX() + cos(radians(240 + getCount())) * 8, getY() + sin(radians(240 + getCount())) * 8, 0, 16);
        }
      }
      if((isInvincible() && getCount() % 2 == 0) || isRelease == true){
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
      easyTriangle(pg, getPos(), 0, 16);
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
    pg.ellipse(getX(), getY(), getSize() * 2, getSize() * 2);

    pg.endDraw();
  }

  void bound(){
    setPos(min(max(getX(), 0), width), min(max(getY(), 0), height));
  }

  void shot(Stage stage){
    if(z){
      if(getCount() % 8 == 0){
        shotSound.play(0);
        print("z");
        float kakudo = 10;
        float kyori = 2;
        for(int i = 0; i < 4; i++){
          Shot shot = new Shot(getX() + 24, getY() - kyori + i * kyori * 0.75, 0, 0);
          shot.setSize(4);
          shot.setColor(color(255, 180));
          shot.setAccel(new PVector(0.25 * cos(radians(-kakudo + kakudo * 0.75 * i)), 0.25 * sin(radians(-kakudo + kakudo * 0.75 * i))));
          shot.setBlendStyle(ADD);
          stage.addJikiShot(shot);
        }
      }
    }
  }

  //赤：追尾弾
  //青：デカレーザー、弾消し効果あり
  //緑：自機周りのバリア、確率で弾消し
  void releaseShot(Stage stage){
    if(RedP > 0){
      if(getCount() % 5 == 0){
        RedP = max(RedP - 30, 0);
        JikiRockOnShot redShot = new JikiRockOnShot(getX(), getY());
        redShot.setSize(10);

        stage.addJikiShot(redShot);
      }
    }
    if(GreenP > 0){
      GreenP = max(GreenP - 5, 0);
      JikiBarrierShot greenShot = new JikiBarrierShot(getX(), getY());
      stage.addJikiShot(greenShot);
    }
    if(BlueP > 0){
      if(getCount() % 3 == 0){
        BlueP = max(BlueP - 16, 0);
        JikiBlueLaser blueShot = new JikiBlueLaser(getX() + 10, getY());
        stage.addJikiShot(blueShot);
      }
    }
  }

  void hit(Stage stage){
    Iterator<Shot> it = stage.enemyShots.getArray().iterator();
    while(it.hasNext()){
      if(isInvincible()) break;
      Shot s = it.next();
      //被弾判定
      //collision関数はmoverのデフォであったほうがいいね多分これ・・・
      if(s.collision(this)){
        if(s.isHittable){
          if(s.isDeletable){
            //被弾エフェクト
            hitSound.play(0);
            circleParticle r1 = new circleParticle(s.getX(), s.getY(), s.col);
            stage.addParticle(r1);
            s.kill();
          }else{
            //被弾エフェクト
            circleParticle r1 = new circleParticle(getX(), getY(), s.col);
            stage.addParticle(r1);
          }
        }
        HPDown(1);
        continue;
      }

      //吸収システム用の判定
      if(isAbsorbing()){
        float d = dist(getX(), getY(), s.getX(), s.getY());
        if(d < s.getSize() + absorbArea && s.isDeletable == true && s.isHittable){
          Item i = new Item(s.getX(), s.getY(), red(s.col), green(s.col), blue(s.col));
          it.remove();
          stage.items.addItem(i);
          print("absorb");
        }
      }
    }
  
    Iterator<Enemy> it2 = stage.enemys.getArray().iterator();
    //敵との接触判定
    while(it2.hasNext()){
      Enemy e = it2.next();
      if(e.collision(this)){
        if(!isInvincible()){
          e.HPDown(1);
          HPDown(1);

          //被弾エフェクト
          hitSound.play(0);
          circleParticle r1 = new circleParticle(e.getX(), e.getY(), e.getColor());
          stage.addParticle(r1);
        }
      }
    }

    //アイテム取得判定
    Iterator<Item> it3 = stage.items.getArray().iterator();
    while(it3.hasNext()){
      Item i = it3.next();
      if(i.collision(this)){
        itemSound.play(0);
        getColorP(i.RP / 30, i.GP / 30, i.BP / 30);
        it3.remove();
      }
    }
  }

  void absorb(PGraphics pg){
    if(isAbsorbing()){
      absorbArea += absorbMaxArea / absorbFrame;
      pg.beginDraw();
      pg.stroke(255);
      pg.strokeWeight(1);
      pg.fill(255, 180 / absorbFrame * (absorbCount - getCount()));
      pg.ellipse(getX(), getY(), absorbArea * 2, absorbArea * 2);
      pg.endDraw();
    }else{
      if(!isInvincible() && !isRelease && c){
        if(absorbArea > 0){
          absorbArea = 0;
        }

        //ここ吸収ボタンおしたときの処理
        absorbSound.play(0);
        absorbCount = getCount() + absorbFrame;
        print("c");
      }
    }
  }

  //これだとX長押しで無限切り替えできてしまいます・・・連続発動不可能なフレームを作るのが手っ取り早いと思う
  void release(Stage stage){
    if(isRelease){
      releaseShot(stage);
      if(!canRelease()){
        isRelease = false;
      }
    }
  }

  void releaseKey(){
    if(key == 'x' || key == 'X'){
      if(isRelease){
        if(getCount() > releaseWaitCount){
          releaseWaitCount = getCount() + releaseWaitFrame;
          isRelease = false;
        }
      }else{
        if(getCount() > releaseWaitCount){
          if(canRelease()){
            releaseWaitCount = getCount() + releaseWaitFrame;
            isRelease = true;
          }
        }
      }
    }
  }

  void HPDown(int i){
    if(!isInvincible()){
      super.HPDown(i);
      invincibleCount = getCount() + invincibleFrame;
    }
  }

  void getColorP(float R, float G, float B){
    RedP = min(255, RedP + R);
    GreenP = min(255, GreenP + G);
    BlueP = min(255, BlueP + B);
  }

  boolean isInvincible(){
    if(invincibleCount > getCount()){
      return true;
    }else{
      return false;
    }
  }

  boolean isAbsorbing(){
    if(absorbCount > getCount()){
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
}
//てすと02
