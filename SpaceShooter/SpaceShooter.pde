/*
**===========================================================================
 **  @file    SpaceShooter.pde
 **  @author  Eduardo Lorscheiter e Loreno Enrique Ribeiro
 **  @class   Computação Gráfica
 **  @date    Maio/2026 a Junho/2026
 **  @version 1.0
 **  @brief   Space Shooter
 **===========================================================================
 */

import ddf.minim.*;
Minim minim;

AudioPlayer backgroundMusic;
AudioSample shootSound;
AudioSample explosionSound;
//AudioSample powerUpSound;

static final int MENU = 0;
static final int GAME = 1;
static final int LEVELUP = 2;
static final int GAMEOVER = 3;

Rocket rocket;

PImage shipImage;
PImage settingsIcon;
PImage[] asteroidImages;

ArrayList<Bullet> bullets;
ArrayList<Asteroid> asteroids;
ArrayList<PowerUp> powerUps;

Button playButton;
Button exitButton;

boolean showSettings = false;

float masterVolume = 50;
float musicVolume = 100;
float shootVolume = 100;
float explosionVolume = 100;

int draggingSlider = -1;

int state = MENU;

int destroyed = 0;
int shots = 0;
int level = 1;

float xp = 0;
float xpNext = 100;

Upgrade[] currentChoices = new Upgrade[3];

void setup() {
  size(1200, 800);

  minim = new Minim(this);

  backgroundMusic = minim.loadFile("space_battle.mp3");
  shootSound = minim.loadSample("shoot.wav");
  explosionSound = minim.loadSample("explosion.wav");
  //powerUpSound = minim.loadSample("powerup.wav");

  backgroundMusic.setGain(-20);
  backgroundMusic.loop();

  shipImage = loadImage("spaceship.png");
  settingsIcon = loadImage("settingsIcon.PNG");

  asteroidImages = new PImage[4];
  asteroidImages[0] = loadImage("asteroid_1.png");
  asteroidImages[1] = loadImage("asteroid_2.png");
  asteroidImages[2] = loadImage("asteroid_3.png");
  asteroidImages[3] = loadImage("asteroid_4.png");

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
  
  float musicFinal = (masterVolume / 100.0) * (musicVolume / 100.0);
  float shootFinal = (masterVolume / 100.0) * (shootVolume / 100.0);
  float explosionFinal = (masterVolume / 100.0) * (explosionVolume / 100.0);

  backgroundMusic.setGain(volumeToGain(musicFinal * 100));
  shootSound.setGain(volumeToGain(shootFinal * 100));
  explosionSound.setGain(volumeToGain(explosionFinal * 100));

  if (state == MENU) {

    drawMenu();
  } else if (state == GAME) {

    runGame();
  } else if (state == LEVELUP) {

    drawLevelUp();
  } else if (state == GAMEOVER) {

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
  
  drawSettingsButton();

  if (showSettings) {

    fill(0, 150);
    noStroke();
    rect(0, 0, width, height);
    drawSettingsPanel();
  }
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

    if (p.isExpired()) {

      powerUps.remove(i);
      continue;
    }

    p.display();

    if (p.isCollected(rocket)) {

      rocket.activatePower2x();
      powerUps.remove(i);
    }
  }

  for (int i = bullets.size() - 1; i >= 0; i--) {

    Bullet b = bullets.get(i);

    b.update();
    b.display();

    if (b.isOffScreen()) {

      bullets.remove(i);
    }
  }

  for (int i = asteroids.size() - 1; i >= 0; i--) {

    Asteroid a = asteroids.get(i);

    a.update();
    a.display();

    if (!rocket.isInvulnerable() && a.collidesWithRocket(rocket)) {
      state = GAMEOVER;
    }

    for (int j = bullets.size() - 1; j >= 0; j--) {

      Bullet b = bullets.get(j);

      if (a.collidesWithBullet(b)) {

        a.healthPoints -= b.damage;
        bullets.remove(j);

        if (a.healthPoints <= 0) {
          
          explosionSound.trigger();

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

  text("Cadência da arma: " + rocket.shootIntervalFrames, 20, 115);

  text("Velocidade da nave: " + nf(rocket.movementSpeed, 0, 1), 20, 140);

  text("Quantidade de projéteis: " + rocket.projectileCount, 20, 165);

  text("XP Bônus: " + int((rocket.xpMultiplier - 1) * 100) + "%", 20, 190);
}

void generateChoices() {

  ArrayList<Upgrade> pool = new ArrayList<Upgrade>();

  if (rocket.projectileCount < 2 && random(1) < 0.30) {
    pool.add(new Upgrade("TIRO DUPLO", "Dispara 2 projéteis"));
  }

  pool.add(new Upgrade("DANO AUMENTADO", "+1 dano por tiro"));

  pool.add(new Upgrade("CADÊNCIA DA ARMA", "+15% velocidade de disparo"));

  pool.add(new Upgrade("VELOCIDADE DA NAVE", "+20% velocidade da nave"));

  pool.add(new Upgrade("XP BÔNUS", "+10% XP obtido"));

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
    text(currentChoices[i].upgradeTitle, x + 120, 330);

    textSize(15);
    text(currentChoices[i].upgradeDescription, x + 120, 380);
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

  text("Pressione ESC para voltar ao menu principal", width / 2, 530);
}

void drawSettingsButton() {

  boolean hovering = mouseX >= 20 && mouseX <= 70 && mouseY >= 20 && mouseY <= 70;

  fill(hovering ? 90 : 60);
  rect(20, 20, 50, 50, 8);
  imageMode(CENTER);

  float iconSize = hovering ? 40 : 36;
  image(settingsIcon, 45, 45, iconSize, iconSize);
}

void drawSettingsPanel() {

  fill(40);
  stroke(120);
  rect(20, 70, 260, 260, 10);

  fill(255);
  textAlign(LEFT);
  textSize(18);

  text("CONFIGURAÇÕES DE VOLUME", 35, 95);

  drawSlider("Geral", masterVolume, 140);
  drawSlider("Música", musicVolume, 190);
  drawSlider("Tiros", shootVolume, 240);
  drawSlider("Explosão", explosionVolume, 290);
}

void drawSlider(String label, float value, float y) {

  fill(255);
  text(label + " " + int(value), 35, y);
  stroke(200);
  line(35, y + 15, 235, y + 15);

  float knobX = map(value, 0, 100, 35, 235);

  fill(255);
  ellipse(knobX, y + 15, 12, 12);
}

void mouseDragged() {

  if (!showSettings) {
    return;
  }

  float value = map(mouseX, 35, 235, 0, 100);
  value = constrain(value, 0, 100);

  if (mouseY > 140 && mouseY < 165) {
    
    masterVolume = value;
  }

  else if (mouseY > 190 && mouseY < 215) {

    musicVolume = value;
  }

  else if (mouseY > 240 && mouseY < 265) {

    shootVolume = value;
  }

  else if (mouseY > 290 && mouseY < 315) {

    explosionVolume = value;
  }
}

void mousePressed() {

  if (state == MENU) {
    
    if (mouseX >= 20 && mouseX <= 60 && mouseY >= 20 && mouseY <= 60) {

      showSettings = !showSettings;
      return;
    }
    
    if (showSettings) {

      boolean insidePanel = mouseX >= 20 && mouseX <= 280 && mouseY >= 70 && mouseY <= 330;

      if (!insidePanel) {

        showSettings = false;
      }
    }

    if (playButton.isClicked()) {

      initGame();
      state = GAME;
    }

    if (exitButton.isClicked()) {

      exit();
    }
  } else if (state == LEVELUP) {

    for (int i = 0; i < 3; i++) {

      float x = 180 + i * 280;

      if (mouseX > x && mouseX < x + 240 && mouseY > 280 && mouseY < 420) {

        currentChoices[i].apply(rocket);
        rocket.invulnerabilityEndFrame = frameCount + 180;
        state = GAME;
      }
    }
  }
}

void keyPressed() {

  if (state == GAMEOVER) {

    if (key == 'r' || key == 'R') {

      initGame();
      state = GAME;
    }

    if (keyCode == ESC) {

      key = 0;
      initGame();
      state = MENU;
    }
  }
}

void drawStars() {

  stroke(255);

  for (int i = 0; i < 120; i++) {

    point((i * 91) % width, (frameCount + i * 33) % height);
  }
}

void stop() {

  backgroundMusic.close();
  shootSound.close();
  explosionSound.close();
  //powerUpSound.close();

  minim.stop();
  super.stop();
}

float volumeToGain(float volume) {

  if (volume <= 0) {
    return -80;
  }

  return map(volume, 0, 100, -40, 0);
}
