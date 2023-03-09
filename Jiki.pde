class Jiki extends Machine{
  float speed = 3.0f;
  float slowSpeed = 1.5f;
  int invincibleFrame = 30;
  int invincibleCount = 0;
  int absorbFrame = 60;
  int absorbCount = 0;
  int absorbArea = 0;
  int absorbMaxArea = 150;
  float RedP, GreenP, BlueP;
  boolean isRelease = false;  //開放しているかどうか

  Jiki(){
    super(width / 2, height / 2, 10);
    col = color(255, 255, 255, 255);
    size = 4;
    HP = 10;
    RedP = 0;
    GreenP = 0;
    BlueP = 0;
  }

  void updateMe(){
    vel = new PVector(0, 0);
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
    super.updateMe();
    bound();
    absorb();
  }

  void drawMe(){
    push();
      blendMode(ADD);
      if(!slow){
        noStroke();
        fill(255, 0, 0, RedP);
        easyTriangle(pos.x + cos(radians(0 + count)) * 8, pos.y + sin(radians(0 + count)) * 8, 0, 16);
        fill(0, 255, 0, GreenP);
        easyTriangle(pos.x + cos(radians(120 + count)) * 8, pos.y + sin(radians(120 + count)) * 8, 0, 16);
        fill(0, 0, 255, BlueP);
        easyTriangle(pos.x + cos(radians(240 + count)) * 8, pos.y + sin(radians(240 + count)) * 8, 0, 16);
      }
      if(isInvincible()){
        fill(col, 127);
      }else{
        fill(col);
      }
      strokeWeight(1.5);
      stroke(col);
      easyTriangle(pos, 0, 16);
    pop();
    noStroke();
    fill(0);
    ellipse(pos.x, pos.y, size * 2, size * 2);
  }

  void bound(){
    pos.x = min(max(pos.x, 0), width);
    pos.y = min(max(pos.y, 0), height);
  }

  void Shot(Stage stage){
    if(z){
      if(count % 8 == 0){
        print("z");
        float kakudo = 15;
        float kyori = 4;
        for(int i = 0; i < 4; i++){
          Shot shot = new Shot(pos.x + 24, pos.y - kyori + i * kyori * 0.75, 0, 0);
          shot.size = 6;
          shot.col = color(255, 180);
          shot.accel = new PVector(0.25 * cos(radians(-kakudo + kakudo * 0.75 * i)), 0.25 * sin(radians(-kakudo + kakudo * 0.75 * i)));
          stage.jikiShots.addShot(shot);
        }
      }
    }
  }

  void hit(Stage stage){
    Iterator<Shot> it = stage.enemyShots.getShots().iterator();
    while(it.hasNext()){
      Shot s = it.next();
      if(s.collision(this) == true){
          it.remove();
          HPDown(1);
          continue;
      }
      if(isAbsorbing()){
        float d = dist(pos.x, pos.y, s.pos.x, s.pos.y);
        if(d < s.size + absorbArea){
          Shot explode = new Shot(s.pos.x, s.pos.y);
          explode.col = color(255, 127);
          explode.size = s.size * 2;
          explode.vel = new PVector(1, 0);
          it.remove();  //多重削除になることがあるなこれ
          stage.jikiShots.addShot(explode);
          print("absorb");
        }
      }
    }
  
    Iterator<Enemy> it2 = stage.enemys.getArray().iterator();
    while(it2.hasNext()){
      Enemy e = it2.next();
      float d = dist(pos.x, pos.y, e.pos.x, e.pos.y);
      if(d < e.size + size){
          //e.HP--;
          HPDown(1);
      }
    }

    Iterator<Item> it3 = stage.items.getArray().iterator();
    while(it3.hasNext()){
      Item i = it3.next();
      float d = dist(pos.x, pos.y, i.pos.x, i.pos.y);
      if(d < i.size + size * 3){
        getColorP(i.RP / 30, i.GP / 30, i.BP / 30);
        it3.remove();
      }
    }
  }

  void absorb(){
    if(isAbsorbing()){
      absorbArea += absorbMaxArea / absorbFrame;
      stroke(255);
      strokeWeight(1);
      fill(255, 180 / absorbFrame * (absorbCount - count));
      ellipse(pos.x, pos.y, absorbArea * 2, absorbArea * 2);
    }else{
      if(!isInvincible() && c){
        if(absorbArea > 0){
          absorbArea = 0;
        }
        absorbCount = count + absorbFrame;
        print("c");
      }
    }
  }

  void HPDown(int i){
    if(!isInvincible()){
      this.HP -= i;
      invincibleCount = count + invincibleFrame;
    }
  }

  void getColorP(float R, float G, float B){
    RedP = min(255, RedP + R);
    GreenP = min(255, GreenP + G);
    BlueP = min(255, BlueP + B);
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
}
//てすと02