class PowerUp {

    float x;
    float y;
    float radius = 35;
    int spawnFrame;
    int lifeTime = 600;

    PowerUp() {

        x = random(100, width - 100);
        y = random(100, height - 100);
        
        spawnFrame = frameCount;
    }

    void display() {
      
      int age = frameCount - spawnFrame;

        if (age > lifeTime - 180 && frameCount % 20 < 10) {

            return;
        }

        noStroke();

        fill(150, 0, 255, 80);
        ellipse(x, y, 90, 90);

        fill(180, 0, 255);
        ellipse(x, y, radius * 2, radius * 2);

        fill(255);
        textAlign(CENTER, CENTER);
        textSize(20);

        text("2X", x, y);
    }

    boolean collected(Rocket rocket) {

        return dist(x, y, rocket.x, rocket.y) < radius + 25;
    }
    
    boolean expired() {

        return frameCount - spawnFrame >= lifeTime;
    }
}
