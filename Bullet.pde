class Bullet {

    float x;
    float y;
    float vx;
    float vy;
    float damage;
    float size;

    Bullet(float x, float y, float tx, float ty, float damage, float speed, float size) {

        this.x = x;
        this.y = y;
        this.damage = damage;
        this.size = size;

        float angle = atan2(ty - y, tx - x);
        vx = cos(angle) * speed;
        vy = sin(angle) * speed;
    }

    void update() {
      
        x += vx;
        y += vy;
    }

    void display() {
      
        fill(255, 255, 0);
        ellipse(x, y, size, size);
    }

    boolean offscreen() {

        return x < 0 || x > width || y < 0 || y > height;
    }
}
