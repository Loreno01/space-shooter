class Asteroid {
  
    PImage sprite;

    float x;
    float y;
    float vx;
    float vy;

    float radius;
    float hp;
    float maxHp;

    Asteroid(int level) {

        radius = random(20, 50);
        maxHp = 1 + level * 0.5;
        hp = maxHp;
        
        sprite = asteroidImages[int(random(asteroidImages.length))];

        int side = int(random(4));

        if (side == 0) {

            x = random(width);
            y = -50;
        }
        else if (side == 1) {

            x = width + 50;
            y = random(height);
        }
        else if (side == 2) {

            x = random(width);
            y = height + 50;
        }
        else {

            x = -50;
            y = random(height);
        }

        float angle = atan2(height / 2 - y, width / 2 - x);
        float speed = random(1.0, 2.0 + level * 0.15);

        vx = cos(angle) * speed;
        vy = sin(angle) * speed;
    }

    void update() {

        x += vx;
        y += vy;
    }

    void display() {
      
        imageMode(CENTER);
        image(sprite, x, y, radius * 2, radius * 2);
        drawHealthBar();
    }

    void drawHealthBar() {
      
        if (rocket.power2xActive) {

            noStroke();
        }
        else {

            stroke(255);
        }

        float widthBar = radius * 2;

        fill(80);
        rect(x - radius, y - radius - 15, widthBar, 5);
        
        fill(220, 50, 50);
        rect(x - radius, y - radius - 15, widthBar * (hp / maxHp), 5);
    }

    boolean hitBullet(Bullet bullet) {

        return dist(x, y, bullet.x, bullet.y) < radius;
    }

    boolean hitRocket(Rocket rocket) {

        return dist(x, y, rocket.x, rocket.y) < radius + 15;
    }
}
