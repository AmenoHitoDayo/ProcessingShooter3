class Menu{
    int selection = 0;
    PVector pos;

    PGraphics buffer;

    int topY = 128;
    int margin = 48;
    int charSize = 32;

    List<String> koumokuText;

    Menu(){
        koumokuText = new ArrayList<String>();
    }
}