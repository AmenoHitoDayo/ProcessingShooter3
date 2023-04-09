//shotクラスのあれをあれにして描画はこれらの関数にやらせるという野望

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

public void ovalShotDraw(PGraphics pg, Shot shot){
    float lineWeight = shot.getSize() / 3;

    pg.beginDraw();
        pg.push();
            pg.blendMode(shot.getBlendStyle());
            pg.translate(shot.getX(), shot.getY());
            pg.rotate(shot.getVel().heading());
            pg.strokeWeight(lineWeight);
            pg.stroke(shot.getColor());
            pg.fill(shot.getColor(), 180);
            pg.ellipse(0, 0, shot.getSize() * 3, shot.getSize() * 2);
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
            for(int i = 1; i <= 3; i++){
                pg.fill(shot.getColor(), 255 / 3);
                float glowSize = shot.getSize() * (pow(1.25, i));
                pg.ellipse(shot.getX(), shot.getY(), glowSize * 2, glowSize * 2);
            }
            pg.fill(255);
            pg.ellipse(shot.getX(), shot.getY(), shot.getSize() * 2, shot.getSize() * 2);
        pg.pop();
    pg.endDraw();
}

public void orbDelayDraw(PGraphics pg, Shot shot){
        pg.beginDraw();

        pg.push();
            pg.blendMode(ADD);
            for(int i = 0; i < 4; i++){
                pg.noStroke();
                pg.fill(shot.getColor(), map(shot.getDelay() - shot.getCount(), 0, shot.getDelay(), 255, 0) / 1.5);
                float delaysize = map(shot.getDelay() - shot.getCount(), 0, shot.getDelay(), shot.getSize(), shot.getSize() * 4);
                pg.ellipse(shot.getX(), shot.getY(), delaysize * 2 * 0.25 * i, delaysize * 2 * 0.25 * i);
            }
        pg.pop();

        pg.endDraw();
}

public void rectDelayDraw(PGraphics pg, Shot shot){
        float lineWeight =  shot.getSize() / 3;

        pg.beginDraw();

        pg.push();
            pg.blendMode(ADD);
            pg.translate(shot.getX(), shot.getY());
            pg.rotate(shot.getVel().heading() + TWO_PI / 4);
            for(int i = 0; i < 4; i++){
                pg.strokeWeight(lineWeight + lineWeight / 2 * i);
                pg.stroke(shot.getColor(), 255 / 4);
                pg.noFill();
                float delaysize = map(shot.getDelay() - shot.getCount(), 0, shot.getDelay(), shot.getSize(), shot.getSize() * 2);
                pg.rect(0, 0, delaysize * 2, delaysize * 2, delaysize / 4);
            }
        pg.pop();

        pg.endDraw();
}