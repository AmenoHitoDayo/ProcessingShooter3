class Item extends Mover{
    private float RP, GP, BP;
    Item(float _x, float _y, float R, float G, float B){
        super(_x, _y);
        RP = R;
        GP = G;
        BP = B;
        setSize(8);
    }

    void drawMe(PGraphics pg){
        pg.beginDraw();

        //print("drawme");
        pg.noStroke();
        
        pg.push();
            pg.blendMode(ADD);
            
            pg.noStroke();
            pg.fill(255, 0, 0, RP);
            pg.ellipse(getX() + 3 * cos(radians(getCount())), getY() + 3 * sin(radians(getCount())), getSize(), getSize());

            pg.noStroke();
            pg.fill(0, 255, 0, GP);
            pg.ellipse(getX() + 3 * cos(radians(getCount() + 120)), getY() + 3 * sin(radians(getCount() + 120)), getSize(), getSize());

            pg.noStroke();
            pg.fill(0, 0, 255, BP);
            pg.ellipse(getX() + 3 * cos(radians(getCount() + 240)), getY() + 3 * sin(radians(getCount() + 240)), getSize(), getSize());

            pg.noStroke();
            pg.fill(255);
            pg.ellipse(getX(), getY(), 6, 6);


        pg.pop();
        
        pg.endDraw();
    }

    void updateMe(Stage stage){
        super.updateMe();
        //drawMe();
        setVel(PVector.sub(stage.jiki.getPos(), this.getPos()).normalize().mult(5));
    }
}