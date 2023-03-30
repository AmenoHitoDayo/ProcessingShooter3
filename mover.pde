class Mover{
  private PVector pos;
  private PVector vel;
  private PVector accel;
  private int count;  //タイマー　寿命計算とかに使う
  private float size = 4; //当たり判定の半径

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

  public PVector getPos(){
    return pos;
  }

  public float getX(){
    return pos.x;
  }

  public float getY(){
    return pos.y;
  }

  public PVector getVel(){
    return vel;
  }

  public PVector getAccel(){
    return accel;
  }

  public float getSize(){
    return size;
  }

  public int getCount(){
    return count;
  }

  public void setPos(PVector _p){
    pos = _p;
  }

  public void setPos(float _x, float _y){
    pos = new PVector(_x, _y);
  }

  public void setVel(PVector _v){
    vel = _v;
  }

  public void setVel(float _x, float _y){
    vel = new PVector(_x, _y);
  }

  public void setAccel(PVector _a){
    accel = _a;
  }

  public void Accel(float _x, float _y){
    accel = new PVector(_x, _y);
  }


  public void setSize(float _s){
    size = _s;
  }
}

class Machine extends Mover{
  private int HP;
  private color col;
  
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
      easyTriangle(pg, getPos(), radians(180), getSize());
    pg.endDraw();
    /*
    triangle(pos.x + cos(radians(180)) * size, pos.y + sin(radians(180)) * size,
             pos.x + cos(radians(300)) * size, pos.y + sin(radians(300)) * size,
             pos.x + cos(radians(60)) * size, pos.y + sin(radians(60)) * size);
    */
  }

  public int getHP(){
    return HP;
  }

  public color getColor(){
    return col;
  }

  public void setColor(color _c){
    col = _c;
  }

  void HPDown(int down){
    HP -= down;
  }
}
