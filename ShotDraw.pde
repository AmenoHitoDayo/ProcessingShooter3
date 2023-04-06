public void orbShotDraw(PGraphics pg, Shot shot){
    pg.beginDraw();
        pg.push();
            pg.blendMode(shot.getBlendStyle());
            pg.noStroke();
            pg.fill(shot.getColor());
            pg.ellipse(shot.getX(), shot.getY(), shot.getSize() * 2, shot.getSize() * 2);
        pg.pop();
    pg.endDraw();
}

public void poifulShotDraw(PGraphics pg, Shot shot){
    pg.beginDraw();
        pg.push();
            pg.blendMode(shot.getBlendStyle());
            pg.translate(shot.getX(), shot.getY());
            pg.rotate(shot.getVel().heading());
            pg.noStroke();
            pg.fill(shot.getColor());
            pg.ellipse(0, 0, shot.getSize() * 2, shot.getSize() * 3);
        pg.pop();
    pg.endDraw();
}

public void rectShotDraw(PGraphics pg, Shot shot){
    float lineWeight = shot.getSize() / 3;

    pg.beginDraw();

    pg.strokeWeight(lineWeight);
    pg.stroke(shot.getColor());
    pg.noFill();
    pg.push();
        pg.blendMode(shot.getBlendStyle());
        pg.translate(shot.getX(), shot.getY());
        pg.rotate(shot.getVel().heading() + TWO_PI / 4);
        pg.rect(0, 0, shot.getSize() * 2, shot.getSize() * 2, shot.getSize() / 4);
    pg.pop();

    pg.endDraw();
}

public void glowShotDraw(PGraphics pg, Shot shot){
    pg.beginDraw();
        pg.push();
            pg.blendMode(shot.getBlendStyle());
            pg.noStroke();
            pg.fill(255);
            pg.ellipse(shot.getX(), shot.getY(), shot.getSize() * 2, shot.getSize() * 2);
            for(int i = 1; i <= 3; i++){
                pg.fill(shot.getColor(), 255 / 3);
                float glowSize = shot.getSize() * (1 + 0.25 * i);
                pg.ellipse(shot.getX(), shot.getY(), glowSize * 2, glowSize * 2);
            }
        pg.pop();
    pg.endDraw();
}