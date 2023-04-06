class Mover{
  protected boolean isDead = false;

  protected PVector pos;
  protected PVector vel;
  protected PVector accel;
  protected int count;  //タイマー　寿命計算とかに使う
  protected float size = 4; //当たり判定の半径
  protected color col;

  Mover(float _x, float _y){
    pos = new PVector(_x, _y);
    vel = new PVector(0, 0);
    accel = new PVector(0, 0);
    col = color(255);
  }

  void updateMe(Stage stage){
    //制動用のカウンター
    count++;

    //移動
    vel.add(accel);
    pos.add(vel);
  }

  //PGraphicsつかう
  void drawMe(PGraphics pg){
    pg.beginDraw();
      pg.fill(col);
      pg.stroke(col);
      pg.ellipse(pos.x, pos.y, 10, 10);
    pg.endDraw();
  }

  //衝突判定
  boolean collision(Mover m){
      float d = dist(pos.x, pos.y, m.pos.x, m.pos.y);
      if(d < (size + m.size)){
          return true;
      }else{
          return false;
      }
  }

  //画面外判定
  public boolean isOutOfScreen(){
    if(pos.x < 0 - size || pos.x > width + size || pos.y < 0 - size || pos.y > height + size){
      return true;
    }else{
      return false;
    }
  }

  //ステージから削除（できるようにする）
  public void kill(){
    isDead = true;
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

  public color getColor(){
    return col;
  }

  public boolean areYouDead(){
    return isDead;
  }

  public void setColor(color _c){
    col = _c;
  }

  public void setColor(float r, float g, float b){
    col = color(r, g, b);
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

  public void setAccel(float _x, float _y){
    accel = new PVector(_x, _y);
  }


  public void setSize(float _s){
    size = _s;
  }
}

class Machine extends Mover{
  private int HP;
  
  Machine(float _x, float _y, int _HP){
    super(_x, _y);
    HP = _HP;
  }
  
  void updateMe(Stage stage){
    super.updateMe(stage);
  }

  void drawMe(PGraphics pg){
    pg.beginDraw();
      pg.fill(col);
      pg.stroke(col);
      easyTriangle(pg, pos, radians(180), size);
    pg.endDraw();
  }

  public int getHP(){
    return HP;
  }

  void HPDown(int down){
    HP -= down;
    if(HP <= 0){kill();}
  }
}
