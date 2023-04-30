class Title{
    private int cursorNum = 0;
    ArrayList<Particle> particles;

    PGraphics buffer;
    PVector pos;
    int count = 0;

    Title(){
        particles = new ArrayList<Particle>();
        refreshPos();
        buffer = createGraphics(width, height);
    }

    public void updateMe(){
        if(count % 10 == 0){
            GlowBallParticle gp = new GlowBallParticle(random(width), -50);
            particles.add(gp);
        }

        Iterator<Particle> it = particles.iterator();
        while(it.hasNext()){
            Particle p = it.next();
            p.updateMe();
            if(p.areYouDead())it.remove();
        }

        count++;
    }

    public void drawMe(){
        image(buffer, 0, 0);

        buffer.beginDraw();
            buffer.background(0);
        buffer.endDraw();

        for(Particle p: particles){
            p.drawMe(buffer);
        }

        buffer.beginDraw();
            drawArrow(buffer, pos);
            drawMoji();
        buffer.endDraw();
    }

    public void drawMoji(){
        buffer.push();

        buffer.textAlign(CENTER, CENTER);
        buffer.textFont(kinkakuji);

        buffer.textSize(64);
        buffer.noStroke();
        buffer.fill(255);
        buffer.text("Shooting of Color", width / 2, height / 2 - 64);

        buffer.textSize(24);
        buffer.text("Start", width / 2, height / 2 + 64);
        buffer.text("Config", width / 2, height / 2 + 64 + 48);
        buffer.text("Exit", width / 2, height / 2 + 64 + 48 * 2);

        buffer.pop();
    }

    void refreshPos(){
        if(cursorNum < 0)cursorNum = 2;
        if(cursorNum > 2)cursorNum = 0;

        pos = new PVector(width / 2 - 96, height / 2 + 64 + 48 * cursorNum);
    }

    void keyPressed(){
        if(keyCode == gameKey[keyID.shot.getID()]){
            switch(cursorNum){
                case 0:
                    particles.clear();
                    playingStage = new Stage01();
                    scene = Scene.GameScene;
                    break;
                case 1:
                    config.initConfig();
                    scene = Scene.ConfigScene;
                    break;
                case 2:
                    exit();
                    break;
            }
        }

        if(keyCode == gameKey[keyID.up.getID()]){
            cursorNum--;
            refreshPos();
        }

        if(keyCode == gameKey[keyID.down.getID()]){
            //println("/o/");
            cursorNum++;
            refreshPos();
        }
    }
}