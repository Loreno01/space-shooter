class Rocket {

    float x;
    float y;
    float damage = 1;
    float moveSpeed = 1;
    float fireRate = 30;
    float bulletSpeed = 10;
    float xpMultiplier = 1;
    
    boolean power2xActive = false;
    int power2xUntil = 0;

    int projectileCount = 1;
    int lastShot = 0;
    int invulnerableUntil = 0;

    Rocket() {
      
        x = width / 2;
        y = height / 2;
    }
    
    boolean isInvulnerable() {
      
        return frameCount < invulnerableUntil;
    }

    void update() {

        x = lerp(x, mouseX, moveSpeed * 0.01);
        y = lerp(y, mouseY, moveSpeed * 0.01);
        
        if (power2xActive && frameCount > power2xUntil) {

            power2xActive = false;
        }
    }

    void display() {

        pushMatrix();

        translate(x, y);

        rotate(atan2(mouseY - y, mouseX - x));

        imageMode(CENTER);
        
        if (power2xActive) {

            noStroke();

            fill(180, 0, 255, 40);
            ellipse(0, 0, 110, 110);

            fill(180, 0, 255, 70);
            ellipse(0, 0, 90, 90);
        }
        
        if (!isInvulnerable() || frameCount % 10 < 5) {
          
            image(shipImage, 0, 0, 70, 70);
        }

        popMatrix();
    }

    void tryShoot() {

        if (mousePressed && frameCount - lastShot >= fireRate) {
          
            shoot();
            lastShot = frameCount;
        }
    }

    void shoot() {

        shots++;

        bullets.add(
            new Bullet(
                x,
                y,
                mouseX,
                mouseY,
                power2xActive ? damage * 2 : damage,
                bulletSpeed,
                power2xActive ? 16 : 8
            )
        );

        if (projectileCount > 1) {

            bullets.add(
                new Bullet(
                    x,
                    y + 10,
                    mouseX,
                    mouseY + 10,
                    power2xActive ? damage * 2 : damage,
                    bulletSpeed,
                    power2xActive ? 16 : 8
                )
            );
        }
    }
    
    void activatePower2x() {

        power2xActive = true;
        power2xUntil = frameCount + 600;
    }
}
