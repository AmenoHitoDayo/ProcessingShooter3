class Title{
    private int cursorNum = 0;

    Title(){

    }

    public void drawMe(){
        textSize(64);
        fill(255);
        noStroke();
        text("Shooting of Color", width / 2, height / 2);
    }
}