class Mover{
  PVector pos;
  PVector vel;
  PVector accel;
  int count;  //タイマー　寿命計算とかに使う
  float size = 4; //当たり判定の半径
  color col;
  ArrayList<MoveCue> cues;

  Mover(float _x, float _y){
    pos = new PVector(_x, _y);
    vel = new PVector(0, 0);
    accel = new PVector(0, 0);
    cues = new ArrayList<MoveCue>();
  }

  void updateMe(){
    count++;
    drawMe();
    vel.add(accel);
    pos.add(vel);
    
    if(cues.size() > 0){
      for(int i = 0; i < cues.size(); i++){
        MoveCue cue = cues.get(i);
        if(cue.count == this.count){
          this.vel = cue.vel;
          this.accel = cue.accel;
          this.col = cue.col;
        }
      }
    }
  }

  void drawMe(){
    fill(255);
    ellipse(pos.x, pos.y, 10, 10);
  }

    boolean collision(Mover m){
        float d = dist(pos.x, pos.y, m.pos.x, m.pos.y);
        if(d < (size + m.size)){
            return true;
        }else{
            return false;
        }
    }

  void addCue(MoveCue cue){
      cues.add(cue);
  }
}

class Machine extends Mover{
  int HP;
  int size;
  
  Machine(float _x, float _y, int _HP){
    super(_x, _y);
    HP = _HP;
  }
  
  void updateMe(){
    super.updateMe();
  }

  void drawMe(){
    fill(col);
    stroke(col);
    easyTriangle(pos, radians(180), size);
    /*
    triangle(pos.x + cos(radians(180)) * size, pos.y + sin(radians(180)) * size,
             pos.x + cos(radians(300)) * size, pos.y + sin(radians(300)) * size,
             pos.x + cos(radians(60)) * size, pos.y + sin(radians(60)) * size);
    */
  }
}

class MoveCue{
    int count;
    PVector vel;
    PVector accel;
    color col;

    MoveCue(int _c, PVector _v, PVector _a, int _col){
      count = _c;
      vel = _v;
      accel = _a;
      col = _col;
    }
}
