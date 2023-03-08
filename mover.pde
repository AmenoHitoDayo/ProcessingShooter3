class Mover{
  PVector pos;
  PVector vel;
  int count;

  Mover(float _x, float _y){
    pos = new PVector(_x, _y);
    vel = new PVector(0, 0);
  }

  void updateMe(){
    count++;
    drawMe();
    pos.add(vel);
  }

  void drawMe(){
    fill(255);
    ellipse(pos.x, pos.y, 10, 10);
  }
}

class Machine extends Mover{
  int HP;
  int size;
  color col;
  
  Machine(float _x, float _y){
    super(_x, _y);
  }
  
  void updateMe(){
    super.updateMe();
  }

  void drawMe(){
    fill(col);
    stroke(col);
    triangle(pos.x + cos(radians(180)) * size, pos.y + sin(radians(180)) * size,
             pos.x + cos(radians(300)) * size, pos.y + sin(radians(300)) * size,
             pos.x + cos(radians(60)) * size, pos.y + sin(radians(60)) * size);
  }
}
