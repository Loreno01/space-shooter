Rocket rocket;

PImage shipImage;
PImage[] asteroidImages;

ArrayList<Bullet> bullets;
ArrayList<Asteroid> asteroids;
ArrayList<PowerUp> powerUps;

Button playButton;
Button exitButton;

int MENU = 0;
int GAME = 1;
int LEVELUP = 2;
int GAMEOVER = 3;

int state = MENU;

int destroyed = 0;
int shots = 0;
int level = 1;

float xp = 0;
float xpNext = 100;

Upgrade[] currentChoices = new Upgrade[3];

void setup() {

    size(1200, 800);
    
    shipImage = loadImage("naveEspacial.PNG");

    asteroidImages = new PImage[4];
    asteroidImages[0] = loadImage("asteroide1.PNG");
    asteroidImages[1] = loadImage("asteroide2.PNG");
    asteroidImages[2] = loadImage("asteroide3.PNG");
    asteroidImages[3] = loadImage("asteroide4.PNG");

    initGame();

    playButton = new Button(width / 2 - 100, 300, 200, 60, "JOGAR");
    exitButton = new Button(width / 2 - 100, 390, 200, 60, "SAIR");
}

void initGame() {

    rocket = new Rocket();
    bullets = new ArrayList<Bullet>();
    asteroids = new ArrayList<Asteroid>();
    powerUps = new ArrayList<PowerUp>();

    destroyed = 0;
    shots = 0;
    level = 1;

    xp = 0;
    xpNext = 100;
}

void draw() {

    background(0);
    drawStars();

    if (state == MENU) {
      
        drawMenu();
    }

    else if (state == GAME) {
      
        runGame();
    }

    else if (state == LEVELUP) {
      
        drawLevelUp();
    }

    else if (state == GAMEOVER) {
      
        drawGameOver();
    }
}

void drawMenu() {

    fill(255);
    textAlign(CENTER);
    textSize(48);

    text("SPACE SHOOTER", width / 2, 180);

    playButton.display();
    exitButton.display();
}

void runGame() {

    if (frameCount % max(15, 60 - level * 2) == 0) {

        asteroids.add(new Asteroid(level));
    }
    
    if (frameCount % 1200 == 0 && powerUps.size() == 0 && random(1) < 0.20) {

        powerUps.add(new PowerUp());
    }

    rocket.update();
    rocket.display();
    rocket.tryShoot();
    
    for (int i = powerUps.size() - 1; i >= 0; i--) {

        PowerUp p = powerUps.get(i);
        
        if (p.expired()) {

            powerUps.remove(i);
            continue;
        }
        
        p.display();

        if (p.collected(rocket)) {

            rocket.activatePower2x();
            powerUps.remove(i);
        }
    }

    for (int i = bullets.size() - 1; i >= 0; i--) {

        Bullet b = bullets.get(i);

        b.update();
        b.display();

        if (b.offscreen()) {

            bullets.remove(i);
        }
    }

    for (int i = asteroids.size() - 1; i >= 0; i--) {

        Asteroid a = asteroids.get(i);

        a.update();
        a.display();
        
        if (!rocket.isInvulnerable() && a.hitRocket(rocket)) {
          
            state = GAMEOVER;
        }

        for (int j = bullets.size() - 1; j >= 0; j--) {

            Bullet b = bullets.get(j);

            if (a.hitBullet(b)) {

                a.hp -= b.damage;
                bullets.remove(j);

                if (a.hp <= 0) {

                    destroyed++;
                    xp += 25 * rocket.xpMultiplier * (rocket.power2xActive ? 2 : 1);
                    asteroids.remove(i);
                    break;
                }
            }
        }
    }

    if (xp >= xpNext) {

        xp -= xpNext;

        level++;

        xpNext *= 1.4;

        generateChoices();

        state = LEVELUP;
    }

    fill(255);
    textAlign(LEFT);
    textSize(18);
    text("Nível: " + level, 20, 30);

    fill(60);
    rect(20, 45, 200, 15);

    fill(0, 255, 0);
    rect(20, 45, 200 * (xp / xpNext), 15);

    fill(255);
    textSize(16);

    text("Dano por tiro: " + rocket.damage, 20, 90);

    text("Cadência da arma: " + rocket.fireRate, 20, 115);
    
    text("Velocidade da nave: " + nf(rocket.moveSpeed, 0, 1), 20, 140);

    text("Quantidade de projéteis: " + rocket.projectileCount, 20, 165);

    text("XP Bônus: " + int((rocket.xpMultiplier - 1) * 100) + "%", 20, 190);
}

void generateChoices() {

    ArrayList<Upgrade> pool = new ArrayList<Upgrade>();
    
    if (rocket.projectileCount < 2 && random(1) < 0.30) {

        pool.add(
            new Upgrade(
                "TIRO DUPLO",
                "Dispara 2 projéteis"
            )
        );
    }

    pool.add(
        new Upgrade(
            "DANO AUMENTADO",
            "+1 dano por tiro"
        )
    );

    pool.add(
        new Upgrade(
            "CADÊNCIA DA ARMA",
            "+15% velocidade de disparo"
        )
    );

    pool.add(
        new Upgrade(
            "VELOCIDADE DA NAVE",
            "+20% velocidade da nave"
        )
    );
    
    pool.add(
        new Upgrade(
            "XP BÔNUS",
            "+10% XP obtido"
        )
    );

    for (int i = 0; i < 3; i++) {

        int index = int(random(pool.size()));
        currentChoices[i] = pool.get(index);
        pool.remove(index);
    }
}

void drawLevelUp() {

    fill(255);
    textAlign(CENTER);
    textSize(32);
    text("ESCOLHA UMA MELHORIA", width / 2, 150);

    for (int i = 0; i < 3; i++) {

        float x = 180 + i * 280;

        fill(60);
        rect(x, 280, 240, 140, 15);

        fill(255);
        
        textSize(22);
        text(currentChoices[i].title, x + 120, 330);

        textSize(15);
        text(currentChoices[i].description, x + 120, 380);
    }
}

void drawGameOver() {

    fill(255, 0, 0);
    textAlign(CENTER);
    textSize(48);
    text("GAME OVER", width / 2, 180);

    fill(255);
    textSize(24);

    text("Nível alcançado: " + level, width / 2, 250);

    text("Asteroides destruídos: " + destroyed, width / 2, 290);

    text("Disparos efetuados: " + shots, width / 2, 330);

    textSize(18);
    
    text("Pressione R para reiniciar", width / 2, 500);

}

void mousePressed() {

    if (state == MENU) {

        if (playButton.isClicked()) {

            initGame();
            state = GAME;
        }

        if (exitButton.isClicked()) {

            exit();
        }
    }

    else if (state == LEVELUP) {

        for (int i = 0; i < 3; i++) {

            float x = 180 + i * 280;

            if (mouseX > x && mouseX < x + 240 && mouseY > 280 && mouseY < 420) {

                currentChoices[i].apply(rocket);
                rocket.invulnerableUntil = frameCount + 180;
                state = GAME;
            }
        }
    }
}

void keyPressed() {

    if (state == GAMEOVER && (key == 'r' || key == 'R')) {

        initGame();
        state = GAME;
    }
}

void drawStars() {

    stroke(255);

    for (int i = 0; i < 120; i++) {

        point((i * 91) % width, (frameCount + i * 33) % height);
    }
}
