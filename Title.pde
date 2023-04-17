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
            GlowBallParticle gp = new GlowBallParticle(random(width), -100);
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

        drawArrow();
        drawMoji();
    }

    public void drawMoji(){
        buffer.beginDraw();

        buffer.push();

        buffer.textAlign(CENTER, CENTER);
        buffer.textFont(kinkakuji);

        buffer.textSize(64);
        buffer.noStroke();
        buffer.fill(255);
        buffer.text("Shooting of Color", width / 2, height / 2 - 64);

        buffer.textSize(36);
        buffer.text("Start", width / 2, height / 2 + 64);
        buffer.text("Exit", width / 2, height / 2 + 128);

        buffer.pop();

        buffer.endDraw();
    }

    void drawArrow(){
        buffer.beginDraw();
        buffer.fill(255);
        buffer.endDraw();

        easyTriangle(buffer, pos, 0, 16);
        
        buffer.beginDraw();
        buffer.fill(0);
        buffer.ellipse(pos.x, pos.y, 8, 8);

        buffer.endDraw();
    }

    void refreshPos(){
        if(cursorNum < 0)cursorNum = 1;
        if(cursorNum > 1)cursorNum = 0;

        switch(cursorNum){
            case 0:
                pos = new PVector(width / 2 - 96, height / 2 + 64);
                break;
            case 1:
                pos = new PVector(width / 2 - 96, height / 2 + 128);
                break;
        }
    }

    void keyPressed(){
        if(key == 'z' || key == 'Z'){
            if(cursorNum == 0){
                particles.clear();
                playingStage = new Stage01();
                scene = Scene.GameScene;
            }else if(cursorNum == 1){
                exit();
            }
        }

        if(key == 'w' || key == 'W' || keyCode == UP){
            cursorNum--;
            refreshPos();
        }

        if(key == 's' || key == 'S' || keyCode == DOWN){
            println("/o/");
            cursorNum++;
            refreshPos();
        }
    }
}