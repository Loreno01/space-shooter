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

// Imports
import ddf.minim.*;

// Constantes
static final int MENU = 0;
static final int GAME = 1;
static final int LEVELUP = 2;
static final int GAMEOVER = 3;
static final int STARS = 120;
static final int MAX_VOLUME = 100;
static final int SETTINGS_WIDTH = 250;
static final int SETTINGS_HEIGHT = 260;

// Áudio
Minim minim;

AudioPlayer backgroundMusic;
AudioSample shootSound;
AudioSample explosionSound;

boolean showSettings = false;

float masterVolume = MAX_VOLUME / 2;
float musicVolume = MAX_VOLUME;
float shootVolume = MAX_VOLUME;
float explosionVolume = MAX_VOLUME;

int draggingSlider = -1;

// Recursos gráficos
PImage settingsIcon;
PImage shipImage;
PImage[] asteroidImages;

// Entidades do jogo
Rocket rocket;
ArrayList<Bullet> bullets;
ArrayList<Asteroid> asteroids;
ArrayList<PowerUp> powerUps;

// Interface
Button playButton;
Button exitButton;

// Progressão
int state = MENU;

int destroyed = 0;
int shots = 0;
int level = 1;

float xp = 0;
float xpNext = 100;

Upgrade[] currentChoices = new Upgrade[3];

void setup() {
  size(1200, 800);

  initializeAudio();
  initializeGraphics();
  initializeUI();
  initializeGame();
}

/**
 * Inicializa o sistema de áudio do jogo
 */
void initializeAudio() {
  minim = new Minim(this);

  backgroundMusic = minim.loadFile("space_battle.mp3");
  shootSound = minim.loadSample("shoot.wav");
  explosionSound = minim.loadSample("explosion.wav");

  backgroundMusic.setGain(volumeToGain(musicVolume));
  backgroundMusic.loop();
}

/**
 * Inicializa todas as imagens utilizadas pelo jogo
 */
void initializeGraphics() {
  settingsIcon = loadImage("settings_icon.png");
  shipImage = loadImage("spaceship.png");

  asteroidImages = new PImage[4];
  asteroidImages[0] = loadImage("asteroid_1.png");
  asteroidImages[1] = loadImage("asteroid_2.png");
  asteroidImages[2] = loadImage("asteroid_3.png");
  asteroidImages[3] = loadImage("asteroid_4.png");
}

/**
 * Inicializa os componentes da interface
 */
void initializeUI() {
  playButton = new Button(width / 2 - 100, 300, 200, 60, "JOGAR");
  exitButton = new Button(width / 2 - 100, 390, 200, 60, "SAIR");
}

/**
 * Inicializa todos os dados da partida
 */
void initializeGame() {
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
  drawStars();

  backgroundMusic.setGain(volumeToGain(musicVolume));
  shootSound.setGain(volumeToGain(shootVolume));
  explosionSound.setGain(volumeToGain(explosionVolume));

  switch(state) {
  case MENU:
    drawMenu();
    break;
  case GAME:
    runGame();
    break;
  case LEVELUP:
    drawLevelUp();
    break;
  case GAMEOVER:
    drawGameOver();
    break;
  }
}

/**
 * Desenha o céu estrelado como plano de fundo
 */
void drawStars() {
  background(0);
  stroke(255);

  for (int star = 0; star < STARS; star++) {
    point((star * 91) % width, (frameCount + star * 33) % height);
  }
}

/**
 * Converte um valor percentual de volume para ganho em decibéis utilizado pelo Minim
 *
 * @param volume valor entre 0 e 100
 * @return ganho em dB
 */
float volumeToGain(float volume) {
  float volumeFinal = ((masterVolume / 100.0) * (volume / 100.0)) * 100;

  if (volumeFinal <= 0) {
    return -80;
  }

  return map(volumeFinal, 0, 100, -40, 0);
}

/**
 * Exibe a tela inicial do jogo
 */
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

  fill(120);
  textAlign(RIGHT, BOTTOM);
  textSize(16);
  text("Desenvolvido por Eduardo Lorscheiter e Loreno Enrique Ribeiro", width - 15, height - 10);
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
  rect(20, 70, SETTINGS_WIDTH, SETTINGS_HEIGHT, 10);

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

void runGame() {
  spawnAsteroids();
  spawnPowerUps();

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

  drawHUD();
}

void spawnAsteroids() {
  if (frameCount % max(15, 60 - level * 2) == 0) {
    asteroids.add(new Asteroid(level));
  }
}

void spawnPowerUps() {
  if (frameCount % 1200 == 0 && powerUps.size() == 0 && random(1) < 0.20) {
    powerUps.add(new PowerUp());
  }
}

/**
 * Desenha as informações da partida na tela
 */
void drawHUD() {
  fill(255);
  textAlign(LEFT);
  textSize(18);
  text("Nível: " + level, 20, 30);

  stroke(255);
  
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

/**
 * Exibe a tela de seleção de melhorias
 */
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

void mouseDragged() {
  if (!showSettings) {
    return;
  }

  float value = map(mouseX, 35, 235, 0, 100);
  value = constrain(value, 0, 100);

  if (mouseY > 140 && mouseY < 165) {
    masterVolume = value;
  } else if (mouseY > 190 && mouseY < 215) {
    musicVolume = value;
  } else if (mouseY > 240 && mouseY < 265) {
    shootVolume = value;
  } else if (mouseY > 290 && mouseY < 315) {
    explosionVolume = value;
  }
}

void mousePressed() {
  if (state == MENU) {
    if (mouseX >= 20 && mouseX <= 70 && mouseY >= 20 && mouseY <= 70) {
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
      initializeGame();
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
      initializeGame();
      state = GAME;
    }

    if (keyCode == ESC) {
      key = 0;
      initializeGame();
      state = MENU;
    }
  }
}

void stop() {
  backgroundMusic.close();
  shootSound.close();
  explosionSound.close();

  minim.stop();

  super.stop();
}
