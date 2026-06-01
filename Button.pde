class Button {

    float x;
    float y;
    float w;
    float h;
    String label;

    Button(float x, float y, float w, float h, String l) {
      
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        label = l;
    }

    void display() {

        fill(50);
        rect(x, y, w, h, 10);
        fill(255);

        textAlign(CENTER, CENTER);
        textSize(24);
        text(label, x + w / 2, y + h / 2);
    }

    boolean isClicked() {

        return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
    }
}
