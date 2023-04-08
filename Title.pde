class Title{
    private int cursorNum = 0;
    ArrayList<Particle> particles;

    PGraphics buffer;
    int count = 0;

    Title(){
        particles = new ArrayList<Particle>();

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

        drawMoji();
    }

    public void drawMoji(){
        buffer.beginDraw();

        buffer.push();

        buffer.textAlign(CENTER);
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

    void keyPressed(){
        if(key == 'z' || key == 'Z'){
            particles.clear();
            playingStage = new Stage01();
            scene = Scene.GameScene;
        }
    }
}