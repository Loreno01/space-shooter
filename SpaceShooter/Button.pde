/*
**===========================================================================
 **  @file    Button.pde
 **  @author  Eduardo Lorscheiter e Loreno Enrique Ribeiro
 **  @class   Computação Gráfica
 **  @date    Maio/2026 a Junho/2026
 **  @version 1.0
 **  @brief   Space Shooter
 **===========================================================================
 */

class Button {
  float buttonX;
  float buttonY;
  float buttonWidth;
  float buttonHeight;
  String buttonLabel;

  /**
   * Construtor da classe Button
   *
   * @param buttonX      Posição horizontal do botão
   * @param buttonY      Posição vertical do botão
   * @param buttonWidth  Largura do botão
   * @param buttonHeight Altura do botão
   * @param buttonLabel  Texto exibido no botão
   */
  Button(float buttonX, float buttonY, float buttonWidth, float buttonHeight, String buttonLabel) {
    this.buttonX = buttonX;
    this.buttonY = buttonY;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    this.buttonLabel = buttonLabel;
  }

  /**
   * Desenha o botão na tela.
   *
   * Quando o cursor do mouse está sobre o botão, é aplicado um efeito
   * visual de destaque, aumentando levemente seu tamanho e alterando sua cor
   */
  void display() {
    float scale = isMouseOver() ? 1.05 : 1.0;

    float newWidth = buttonWidth * scale;
    float newHeight = buttonHeight * scale;

    float offsetX = (newWidth - buttonWidth) / 2;
    float offsetY = (newHeight - buttonHeight) / 2;

    fill(isMouseOver() ? color(125) : color(50));

    rect(buttonX - offsetX, buttonY - offsetY, newWidth, newHeight, 10);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(24);

    text(buttonLabel, buttonX + buttonWidth / 2, buttonY + buttonHeight / 2);
  }

  /**
   * Verifica se o botão foi clicado
   *
   * @return true se o cursor estiver dentro dos limites do botão, false caso contrário
   */
  boolean isClicked() {
    return isMouseOver();
  }

  /**
   * Verifica se o cursor do mouse está sobre o botão
   *
   * @return true se o cursor estiver sobre o botão, false caso contrário
   */
  boolean isMouseOver() {
    return mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight;
  }
}
