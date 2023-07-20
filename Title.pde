class Title extends Menu{
    List<Particle> particles;
    int count = 0;

    Title(){
        super();

        topY = height / 2 + 64;
        charSize = 24;

        koumokuText = new ArrayList<>(
            Arrays.asList(
                "Start",
                "Config",
                "Exit"
            )
        );

        particles = new LinkedList<Particle>();
        refreshPos();
    }

    public void drawMe(){
        super.drawMe();

        if(count % 10 == 0){
            GlowBallParticle gp = new GlowBallParticle(random(width), -50);
            particles.add(gp);
        }

        Iterator<Particle> it = particles.iterator();
        while(it.hasNext()){
            Particle p = it.next();
            p.updateMe();
            p.drawMe(buffer);
            if(p.areYouDead())it.remove();
        }

        count++;
    }

    public void drawMoji(){
        buffer.push();

        buffer.textAlign(CENTER, CENTER);
        buffer.textFont(kinkakuji);

        buffer.textSize(64);
        buffer.noStroke();
        buffer.fill(255);
        buffer.text("Shooting of Color", width / 2, height / 2 - 64);

        buffer.pop();

        super.drawMoji();
    }

    void keyPressed(){
        super.keyPressed();

        if(keyCode == gameKey[keyID.shot.getID()]){
            switch(selection){
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
    }
}