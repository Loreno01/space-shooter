# Space Shooter
Projeto desenvolvido para a disciplina de Computação Gráfica utilizando Processing. O jogo consiste em controlar uma nave espacial que deve sobreviver ao avanço contínuo de asteroides, destruindo inimigos para acumular experiência, evoluir de nível e adquirir melhorias.

### Autores
- Eduardo Lorscheiter
- Loreno Enrique Ribeiro

### Descrição do Jogo
O jogador controla uma nave espacial utilizando o mouse. A nave se desloca suavemente em direção ao cursor e dispara automaticamente enquanto o botão esquerdo ou direito do mouse estiver pressionado.
Ao destruir asteroides, o jogador recebe experiência (XP). Sempre que a barra de experiência é preenchida, o jogador sobe de nível e pode escolher uma entre três melhorias aleatórias.
Além disso, ocasionalmente surge um bônus especial **2X** no mapa. Ao coletá-lo, a nave recebe melhorias temporárias que aumentam significativamente seu poder de combate.
O objetivo é sobreviver o maior tempo possível enquanto enfrenta uma quantidade crescente de asteroides cada vez mais resistentes e rápidos.

### Objetivo do Jogo
Sobreviver o máximo possível, destruir asteroides, evoluir sua nave e alcançar níveis cada vez mais altos enfrentando uma dificuldade crescente.

---

## Requisitos
- Processing
- Java (incluído no Processing)
- Biblioteca **Minim** para reprodução e controle de áudio (Deve ser instalado no processing)

### Instalação da Biblioteca Minim
1. Abra o Processing.
2. Acesse:
   ```
   Sketch → Import Library → Add Library
   ```
3. Pesquise por:
   ```
   Minim
   ```
4. Clique em **Install**.
5. Pronto, o projeto está pronto para ser executado.
   
---

## Como Executar
1. Clone ou baixe este repositório.
2. Abra o arquivo principal do projeto no Processing.
3. Certifique-se de que a biblioteca Minim está instalada.
4. Execute o projeto pressionando o botão **Run** do Processing.
   
---

## Estrutura do Projeto
Todos os arquivos `.pde` devem permanecer na pasta raiz do projeto e todos os recursos visuais e sonoros devem permanecer dentro da pasta `data`, conforme exigido pelo Processing.

``` text
SpaceShooter/
│
├── SpaceShooter.pde
├── Rocket.pde
├── Asteroid.pde
├── Bullet.pde
├── Button.pde
├── PowerUp.pde
├── Upgrade.pde
│
└── data/
    │
    ├── spaceship.png
    ├── asteroid_1.png
    ├── asteroid_2.png
    ├── asteroid_3.png
    ├── asteroid_4.png
    ├── settings_icon.png
    ├── space_battle.mp3
    ├── shoot.wav
    └── explosion.wav
```

---

## Controles
### Menu Principal
- **Jogar**: inicia uma nova partida.
- **Sair**: encerra o jogo.
- **Configuração**: permite configurar os volumes do jogo.

### Durante o Jogo
- **Mouse**: movimenta a nave.
- **Botão esquerdo ou direito do mouse**: dispara projéteis.

### Game Over
- **R**: reinicia a partida.
- **ESC**: retorna ao menu principal.
  
---

## Sistema de Progressão do jogo
### Experiência (XP)
Cada asteroide destruído concede 25 XP e o XP necessário para subir de nível cresce progressivamente.

``` text
Nível 1 → 100 XP
Nível 2 → 140 XP
Nível 3 → 196 XP
Nível 4 → 274 XP
```

### Vida dos Asteroides
A vida dos asteroides aumenta conforme o jogador sobe de nível:

``` text
Nível 1 → 1.5 HP
Nível 5 → 3.5 HP
Nível 10 → 6 HP
Nível 20 → 11 HP
```

### Velocidade dos Asteroides
A velocidade dos Asteroides aumenta conforme o jogador sobe de nível:

``` text
Nível 1 → até 2.15
Nível 5  → até 2.75
Nível 10 → até 3.50
Nível 20 → até 5.00
```

### Frequência de Spawn dos Asteroides
Os asteroides aparecem cada vez mais rápido, existe uma limitação de gerar no máximo 1 asteroide a cada 0,25 segundos, isso impede que a frequência continue aumentando indefinidamente:

``` text
Nível 1  → 58 frames (~1 asteroide a cada 0,97 segundos)
Nível 5  → 50 frames (~1 asteroide a cada 0,83 segundos)
Nível 10 → 40 frames (~1 asteroide a cada 0,67 segundos)
Nível 20 → 20 frames (~1 asteroide a cada 0,33 segundos)
```

---

## Melhorias Disponíveis do Jogo
Ao subir de nível, o jogador recebe três opções aleatórias.

### DANO AUMENTADO
Aumenta o dano causado por cada projétil.
Dano base da nave: 1

``` text
Base        → 1 de dano
1 melhoria  → 2 de dano
3 melhorias → 4 de dano
5 melhorias → 6 de dano
```

### CADÊNCIA DA ARMA
Reduz o intervalo de espera entre os disparos, considera a cadência base para realizar o aumento, foi adicionado um limite de alcançar no máximo 5 frames.
Cadência base da nave: 30 frames

``` text
+10% de cadência da arma por melhoria
```

``` text
Base        → 30 frames (~0,50 s entre tiros)
1 melhoria  → 27 frames (~0,45 s entre tiros)
3 melhorias → 21 frames (~0,35 s entre tiros)
5 melhorias → 15 frames (~0,25 s entre tiros)
```

### VELOCIDADE DA NAVE
Aumenta a velocidade de movimentação da nave, considera a velocidade base da nave para o aumento.
Velocidade base da nave: 1

``` text
+20% de velocidade da nave por melhoria
```

``` text
Base        → 1,0
1 melhoria  → 1,2
3 melhorias → 1,6
5 melhorias → 2,0
```

### XP BÔNUS
Aumenta permanentemente a quantidade de experiência recebida ao eliminar os asteroides.
XP Bônus base: +0%

``` text
+10% XP Bônus por melhoria
```

``` text
Base        → +0% XP Bônus
1 melhoria  → +10% XP Bônus
3 melhorias → +30% XP Bônus
5 melhorias → +50% XP Bônus
```

### TIRO DUPLO
Desbloqueia um segundo projétil por disparo.

Características únicas dessa melhoria:
- Pode ser obtido apenas uma vez.
- Possui aproximadamente 30% de chance de aparecer quando ainda não foi adquirido.
- Depois de obtido não irá mais aparecer entre as opções de melhorias.
  
---

## Power-Up 2X
Durante a partida, existe uma chance de surgir um bônus especial no mapa.

Características:
- Surge periodicamente.
- Permanece disponível por 10 segundos.
- Pisca nos últimos 3 segundos antes de desaparecer.

Ao coletá-lo, a nave recebe um efeito visual roxo indicando que o bônus está ativo e recebee os seguintes efeitos:

```text
XP recebido ×2
Dano dos projéteis ×2
Tamanho dos projéteis ×2
```

---
