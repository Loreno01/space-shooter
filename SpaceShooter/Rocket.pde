/*
**===========================================================================
 **  @file    Rocket.pde
 **  @author  Eduardo Lorscheiter e Loreno Enrique Ribeiro
 **  @class   Computação Gráfica
 **  @date    Maio/2026 a Junho/2026
 **  @version 1.0
 **  @brief   Space Shooter
 **===========================================================================
 */

class Rocket {
  float positionX;
  float positionY;

  float damage = 1;
  float movementSpeed = 1;
  float shootIntervalFrames = 30;
  float bulletSpeed = 10;
  float xpMultiplier = 1;

  boolean power2xActive = false;
  int power2xEndFrame = 0;

  int projectileCount = 1;
  int lastShotFrame = 0;
  int invulnerabilityEndFrame = 0;

  /**
   * Construtor da classe Rocket
   *
   * Inicializa a nave na posição central da tela
   */
  Rocket() {
    positionX = width / 2;
    positionY = height / 2;
  }

  /**
   * Verifica se a nave está invulnerável
   *
   * @return true se a invulnerabilidade estiver ativa, false caso contrário
   */
  boolean isInvulnerable() {
    return frameCount < invulnerabilityEndFrame;
  }

  /**
   * Atualiza a posição da nave e o estado dos efeitos temporários ativos
   */
  void update() {
    positionX = lerp(positionX, mouseX, movementSpeed * 0.01);
    positionY = lerp(positionY, mouseY, movementSpeed * 0.01);

    if (power2xActive && frameCount > power2xEndFrame) {
      power2xActive = false;
    }
  }

  /**
   * Desenha a nave na tela
   *
   * Quando o bônus 2X está ativo, um efeito* visual é exibido ao redor da nave.
   * Durante a invulnerabilidade, a nave pisca para indicar proteção temporária.
   */
  void display() {

    pushMatrix();

    translate(positionX, positionY);

    rotate(atan2(mouseY - positionY, mouseX - positionX));

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

  /**
   * Verifica se a nave pode disparar de acordo com a cadência configurada
   */
  void tryShoot() {
    if (mousePressed && frameCount - lastShotFrame >= shootIntervalFrames) {
      shoot();
      lastShotFrame = frameCount;
    }
  }

  /**
   * Cria um ou mais projéteis de acordo com os atributos atuais da nave
   *
   * Caso o bônus de tiro duplo esteja ativo, projéteis adicionais serão disparados
   */
  void shoot() {
    shootSound.play();
    
    shots++;

    bullets.add(
      new Bullet(
      positionX,
      positionY,
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
        positionX,
        positionY + 10,
        mouseX,
        mouseY + 10,
        power2xActive ? damage * 2 : damage,
        bulletSpeed,
        power2xActive ? 16 : 8
        )
        );
    }
  }

  /**
   * Ativa temporariamente o bônus de dano e tamanho dos projéteis
   */
  void activatePower2x() {
    power2xActive = true;
    power2xEndFrame = frameCount + 600;
  }
}
