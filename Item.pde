class Item extends Mover{
    private float RP, GP, BP;
    Item(float _x, float _y, float R, float G, float B){
        super(_x, _y);
        RP = R;
        GP = G;
        BP = B;
        size = 8;
    }

    @Override
    void drawMe(PGraphics pg){
        pg.beginDraw();

        //print("drawme");
        pg.noStroke();
        
        pg.push();
            pg.blendMode(ADD);
            
            pg.noStroke();
            pg.fill(255, 0, 0, RP);
            pg.ellipse(pos.x + 3 * cos(radians(count)), pos.y + 3 * sin(radians(count)), size, size);

            pg.noStroke();
            pg.fill(0, 255, 0, GP);
            pg.ellipse(pos.x + 3 * cos(radians(count + 120)), pos.y + 3 * sin(radians(count + 120)), size, size);

            pg.noStroke();
            pg.fill(0, 0, 255, BP);
            pg.ellipse(pos.x + 3 * cos(radians(count + 240)), pos.y + 3 * sin(radians(count + 240)), size, size);

            pg.noStroke();
            pg.fill(255);
            pg.ellipse(pos.x, pos.y, 6, 6);

        pg.pop();
        
        pg.endDraw();
    }

    @Override 
    void updateMe(Stage _s){
        super.updateMe(_s);
        vel = (PVector.sub(stage.getJiki().getPos(), pos).normalize().mult(5));
    }
}
