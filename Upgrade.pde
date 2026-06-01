class Upgrade {

    String title;
    String description;

    Upgrade(String title, String description) {
      
        this.title = title;
        this.description = description;
    }

    void apply(Rocket rocket) {

        if (title.equals("DANO AUMENTADO")) {
            rocket.damage += 1;
        }

        else if (title.equals("CADÊNCIA DA ARMA")) {
            rocket.fireRate = max(5, rocket.fireRate - 3);
        }

        else if (title.equals("VELOCIDADE DA NAVE")) {
            rocket.moveSpeed += 0.2;
        }

        else if (title.equals("TIRO DUPLO")) {
            rocket.projectileCount = 2;
        }

        else if (title.equals("XP BÔNUS")) {
            rocket.xpMultiplier += 0.10;
        }
    }
}
