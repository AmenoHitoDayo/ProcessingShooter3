class Item extends Mover{
    float RP, GP, BP;
    Item(float _x, float _y, float R, float G, float B){
        super(_x, _y);
        RP = R;
        GP = G;
        BP = B;
        size = 8;
    }

    void drawMe(){
        //print("drawme");
        noStroke();
        
        push();
            blendMode(ADD);
            
            noStroke();
            fill(255, 0, 0, RP);
            ellipse(pos.x + 3 * cos(radians(count)), pos.y + 3 * sin(radians(count)), size, size);

            noStroke();
            fill(0, 255, 0, GP);
            ellipse(pos.x + 3 * cos(radians(count + 120)), pos.y + 3 * sin(radians(count + 120)), size, size);

            noStroke();
            fill(0, 0, 255, BP);
            ellipse(pos.x + 3 * cos(radians(count + 240)), pos.y + 3 * sin(radians(count + 240)), size, size);

            noStroke();
            fill(255);
            ellipse(pos.x, pos.y, 6, 6);


        pop();
        
    }

    void updateMe(Stage stage){
        super.updateMe();
        //drawMe();
        vel = PVector.sub(stage.jiki.pos, this.pos).normalize().mult(5);
    }
}