/*
**===========================================================================
 **  @file    Upgrade.pde
 **  @author  Eduardo Lorscheiter e Loreno Enrique Ribeiro
 **  @class   Computação Gráfica
 **  @date    Maio/2026 a Junho/2026
 **  @version 1.0
 **  @brief   Space Shooter
 **===========================================================================
 */

class Upgrade {
  String upgradeTitle;
  String upgradeDescription;

  /**
   * Construtor da classe Upgrade
   *
   * @param upgradeTitle       Nome da melhoria
   * @param upgradeDescription Descrição da melhoria
   */
  Upgrade(String upgradeTitle, String upgradeDescription) {
    this.upgradeTitle = upgradeTitle;
    this.upgradeDescription = upgradeDescription;
  }

  /**
   * Aplica os efeitos da melhoria na nave
   *
   * @param rocket Nave do jogador
   */
  void apply(Rocket rocket) {
    if (upgradeTitle.equals("DANO AUMENTADO")) {
      rocket.damage += 1;
    } else if (upgradeTitle.equals("CADÊNCIA DA ARMA")) {
      rocket.shootIntervalFrames = max(5, rocket.shootIntervalFrames - 3);
    } else if (upgradeTitle.equals("VELOCIDADE DA NAVE")) {
      rocket.movementSpeed += 0.2;
    } else if (upgradeTitle.equals("TIRO DUPLO")) {
      rocket.projectileCount = 2;
    } else if (upgradeTitle.equals("XP BÔNUS")) {
      rocket.xpMultiplier += 0.10;
    }
  }
}
