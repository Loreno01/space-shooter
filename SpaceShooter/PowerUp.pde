/*
**===========================================================================
 **  @file    PowerUp.pde
 **  @author  Eduardo Lorscheiter e Loreno Enrique Ribeiro
 **  @class   Computação Gráfica
 **  @date    Maio/2026 a Junho/2026
 **  @version 1.0
 **  @brief   Space Shooter
 **===========================================================================
 */

class PowerUp {
  float positionX;
  float positionY;

  float radius = 35;

  int spawnFrameCount;
  int lifeTimeFrames = 600;

  /**
   * Construtor da classe PowerUp
   *
   * Cria um power-up em uma posição aleatória dentro dos limites da tela
   */
  PowerUp() {
    positionX = random(100, width - 100);
    positionY = random(100, height - 100);
    spawnFrameCount = frameCount;
  }

  /**
   * Desenha o power-up na tela
   *
   * Próximo ao fim de sua vida útil, o power-up passa a piscar para indicar que desaparecerá
   */
  void display() {
    int age = frameCount - spawnFrameCount;

    if (age > lifeTimeFrames - 180 && frameCount % 20 < 10) {
      return;
    }

    noStroke();

    fill(150, 0, 255, 80);
    ellipse(positionX, positionY, 90, 90);

    fill(180, 0, 255);
    ellipse(positionX, positionY, radius * 2, radius * 2);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(20);

    text("2X", positionX, positionY);
  }

  /**
   * Verifica se o power-up foi coletado pela nave
   *
   * @param rocket Nave do jogador.
   * @return true se houve coleta, false caso contrário
   */
  boolean isCollected(Rocket rocket) {
    return dist(positionX, positionY, rocket.positionX, rocket.positionY) < radius + 25;
  }

  /**
   * Verifica se o tempo de vida do power-up expirou
   *
   * @return true se o power-up deve ser removido, false caso contrário
   */
  boolean isExpired() {
    return frameCount - spawnFrameCount >= lifeTimeFrames;
  }
}
