class Mover{
  PVector pos;
  PVector vel;
  PVector accel;
  int count;  //タイマー　寿命計算とかに使う
  float size = 4; //当たり判定の半径

  Mover(float _x, float _y){
    pos = new PVector(_x, _y);
    vel = new PVector(0, 0);
    accel = new PVector(0, 0);
  }

  void updateMe(){
    count++;
    vel.add(accel);
    pos.add(vel);
  }

  void drawMe(PGraphics pg){
    pg.beginDraw();
      pg.fill(255);
      pg.ellipse(pos.x, pos.y, 10, 10);
    pg.endDraw();
  }

    boolean collision(Mover m){
        float d = dist(pos.x, pos.y, m.pos.x, m.pos.y);
        if(d < (size + m.size)){
            return true;
        }else{
            return false;
        }
    }
}

class Machine extends Mover{
  int HP;
  int size;
  color col;
  
  Machine(float _x, float _y, int _HP){
    super(_x, _y);
    HP = _HP;
  }
  
  void updateMe(){
    super.updateMe();
  }

  void drawMe(PGraphics pg){
    pg.beginDraw();
      pg.fill(col);
      pg.stroke(col);
      easyTriangle(pg, pos, radians(180), size);
    pg.endDraw();
    /*
    triangle(pos.x + cos(radians(180)) * size, pos.y + sin(radians(180)) * size,
             pos.x + cos(radians(300)) * size, pos.y + sin(radians(300)) * size,
             pos.x + cos(radians(60)) * size, pos.y + sin(radians(60)) * size);
    */
  }
}
