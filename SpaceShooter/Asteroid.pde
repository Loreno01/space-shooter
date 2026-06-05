/*
**===========================================================================
 **  @file    Asteroid.pde
 **  @author  Eduardo Lorscheiter e Loreno Enrique Ribeiro
 **  @class   Computação Gráfica
 **  @date    Maio/2026 a Junho/2026
 **  @version 1.0
 **  @brief   Space Shooter
 **===========================================================================
 */

class Asteroid {
  PImage sprite;

  float positionX;
  float positionY;

  float velocityX;
  float velocityY;

  float radius;
  float healthPoints;
  float maxHealthPoints;

  /**
   * Construtor da classe Asteroid
   *
   * Cria um asteroide com tamanho, vida e velocidade proporcionais ao nível atual do jogador
   *
   * @param level Nível atual do jogo
   */
  Asteroid(int level) {
    radius = random(20, 50);
    maxHealthPoints = 1 + level * 0.5;
    healthPoints = maxHealthPoints;

    sprite = asteroidImages[int(random(asteroidImages.length))];

    int side = int(random(4));

    if (side == 0) {
      positionX = random(width);
      positionY = -50;
    } else if (side == 1) {
      positionX = width + 50;
      positionY = random(height);
    } else if (side == 2) {
      positionX = random(width);
      positionY = height + 50;
    } else {
      positionX = -50;
      positionY = random(height);
    }

    float angle = atan2(height / 2 - positionY, width / 2 - positionX);
    float speed = random(1.0, 2.0 + level * 0.15);

    velocityX = cos(angle) * speed;
    velocityY = sin(angle) * speed;
  }

  /**
   * Atualiza a posição do asteroide
   */
  void update() {
    positionX += velocityX;
    positionY += velocityY;
  }

  /**
   * Desenha o asteroide e sua barra de vida
   */
  void display() {
    imageMode(CENTER);
    image(sprite, positionX, positionY, radius * 2, radius * 2);
    drawHealthBar();
  }

  /**
   * Desenha a barra de vida do asteroide
   */
  void drawHealthBar() {
    if (rocket.power2xActive) {
      noStroke();
    } else {
      stroke(255);
    }

    float widthBar = radius * 2;

    fill(80);
    rect(positionX - radius, positionY - radius - 15, widthBar, 5);

    fill(220, 50, 50);
    rect(positionX - radius, positionY - radius - 15, widthBar * (healthPoints / maxHealthPoints), 5);
  }

  /**
   * Verifica se um projétil atingiu o asteroide
   *
   * @param bullet Projétil a ser verificado
   * @return true se houve colisão, false caso contrário
   */
  boolean collidesWithBullet(Bullet bullet) {
    return dist(positionX, positionY, bullet.positionX, bullet.positionY) < radius;
  }

  /**
   * Verifica se o asteroide colidiu com a nave
   *
   * @param rocket Nave do jogador
   * @return true se houve colisão, false caso contrário
   */
  boolean collidesWithRocket(Rocket rocket) {
    return dist(positionX, positionY, rocket.positionX, rocket.positionY) < radius + 15;
  }
}
