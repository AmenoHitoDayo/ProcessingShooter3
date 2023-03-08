class Jiki extends Machine{
  float speed = 3.0f;
  float slowSpeed = 1.5f;

  Jiki(){
    super(width / 2, height / 2);
    col = color(255, 255, 255, 255);
    size = 8;
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

  void drawMe(){
    fill(col);
    stroke(col);
    triangle(pos.x + cos(0) * size * 2, pos.y + sin(0) * size * 2,
             pos.x + cos(radians(120)) * size * 2, pos.y + sin(radians(120)) * size * 2,
             pos.x + cos(radians(240)) * size * 2, pos.y + sin(radians(240)) * size * 2);
    noStroke();
    fill(0);
    ellipse(pos.x, pos.y, size, size);
  }

  void bound(){
    pos.x = min(max(pos.x, 0), width);
    pos.y = min(max(pos.y, 0), height);
  }

  void hit(Stage stage){
    Iterator<Shot> it = stage.enemyShots.getShots().iterator();
    while(it.hasNext()){
      Shot s = it.next();
      if(s.collision(this) == true){
          it.remove();
          this.HP--;
      }
    }
  
    Iterator<Enemy> it2 = stage.enemys.getArray().iterator();
    while(it2.hasNext()){
      Enemy e = it2.next();
      float d = dist(pos.x, pos.y, e.pos.x, e.pos.y);
      if(d < e.size + size){
          e.HP--;
          this.HP--;
      }
    }
  }
}
//てすと02