/*
**===========================================================================
 **  @file    Bullet.pde
 **  @author  Eduardo Lorscheiter e Loreno Enrique Ribeiro
 **  @class   Computação Gráfica
 **  @date    Maio/2026 a Junho/2026
 **  @version 1.0
 **  @brief   Space Shooter
 **===========================================================================
 */

class Bullet {
  float positionX;
  float positionY;

  float velocityX;
  float velocityY;

  float damage;
  float size;

  /**
   * Construtor da classe Bullet
   *
   * Cria um projétil que se desloca em direção às coordenadas informadas como alvo
   *
   * @param positionX Posição inicial no eixo X
   * @param positionY Posição inicial no eixo Y
   * @param targetX   Coordenada X do alvo
   * @param targetY   Coordenada Y do alvo
   * @param damage    Dano causado pelo projétil
   * @param speed     Velocidade de deslocamento
   * @param size      Tamanho visual do projétil
   */
  Bullet(float positionX, float positionY, float targetX, float targetY, float damage, float speed, float size) {
    this.positionX = positionX;
    this.positionY = positionY;
    this.damage = damage;
    this.size = size;

    float angle = atan2(targetY - positionY, targetX - positionX);
    velocityX = cos(angle) * speed;
    velocityY = sin(angle) * speed;
  }

  /**
   * Atualiza a posição do projétil
   */
  void update() {
    positionX += velocityX;
    positionY += velocityY;
  }

  /**
   * Desenha o projétil na tela
   */
  void display() {
    fill(255, 255, 0);
    ellipse(positionX, positionY, size, size);
  }

  /**
   * Verifica se o projétil saiu dos limites da tela
   *
   * @return true se o projétil estiver fora da área visível, false caso contrário
   */
  boolean isOffScreen() {
    return positionX < 0 || positionX > width || positionY < 0 || positionY > height;
  }
}
