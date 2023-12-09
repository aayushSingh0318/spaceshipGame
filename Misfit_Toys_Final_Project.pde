import processing.sound.*;
SoundFile theme;
SoundFile shoot;
ArrayList<Enemy> enemies;
int spawnInterval = 240;
int loadingScreenTime = 200;
boolean gameStarted = false;
boolean gameOver = false;  // Add this line to declare gameOver variable
int lives = 3;
PImage heartImage, bg, gameOverImage, loadingScreenImage;
float heartSize = 25;
Spaceship player;
PImage muteImage, unmuteImage;
PImage[] bulletFrames = new PImage[5];

void setup() {
  size(400, 600);
  background(0);
  theme = new SoundFile(this, "theme.mp3");
  println(this);
  shoot = new SoundFile(this, "shoot.mp3");
  theme.loop();
  bg = loadImage("stars.png");
  waterEnemyImage = loadImage("waterenemy.png");
  fireEnemyImage = loadImage("fireenemy.png");
  heartImage = loadImage("heart.png");
  spaceshipImage = loadImage("spaceship.png");
  gameOverImage = loadImage("gameover.jpg");
  loadingScreenImage = loadImage("loadingscreen.jpg");
  muteImage = loadImage("mute.png");
  unmuteImage = loadImage("volume.png");
  enemies = new ArrayList<Enemy>();
  player = new Spaceship();
  for (int i = 0; i < 5; i++) {
    bulletFrames[i] = loadImage("bullet" + i + ".png");
  }
}

void draw() {
  if (!gameStarted) {
    drawLoadingScreen();
  } else {
    if (!gameOver) {
      background(bg);
      
      image(isMuted ? muteImage : unmuteImage, 20, 20, 20, 20);

      player.update();
      player.display();
      
      textSize(20);
      fill(255);
      textAlign(CENTER);
      text("Score: " + player.score, width/2-10, 35);
      text("High Score: " + player.highScore, width/2-10, 55);
      
      for (Bullet bullet : player.bullets) {
        bullet.display(enemies);
      }

      player.bullets.removeIf(bullet -> bullet.offScreen);

      for (Enemy enemy : enemies) {
        enemy.move();
        enemy.display();
      }

      // Draw lives counter with small hearts slightly down in the top right corner
      for (int i = 0; i < player.lives; i++) {
        image(heartImage, width - 30 - i * (heartSize + 5), 30, heartSize, heartSize * heartImage.height / heartImage.width);
      }

      player.checkCollisions(enemies);

      if (player.lives <= 0) {
        gameOver = true;
      } else if (frameCount % spawnInterval == 0) {
        spawnEnemies(int(random(1,4)));
      }
    } else {
      // Game over screen
      background(0);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(40);
      text("GAME OVER", width / 2, height / 3);
      image(gameOverImage, width / 2, height / 2);
      textSize(20);
      text("PRESS ANY KEY TO RESTART", width / 2, 2 * height / 3);

      if (keyPressed) {
        // Reset game state
        player.reset();
        enemies.clear();
        gameStarted = false;
        gameOver = false;
      }
    }
  }
}

void keyPressed() {
  if (!gameStarted) {
    gameStarted = true;
  } else {
    if (key == 'W' || key == 'w' || keyCode == UP) {
      player.movingUp = true;
    }
    if (key == 'S' || key == 's' || keyCode == DOWN) {
      player.movingDown = true;
    }
    if (key == 'A' || key == 'a' || keyCode == LEFT) {
      player.movingLeft = true;
    }
    if (key == 'D' || key == 'd' || keyCode == RIGHT) {
      player.movingRight = true;
    }
    if (key == ' ') {
      player.shoot();

      if (isMuted == false) {shoot.play();};
    }
  }
}

void keyReleased() {
  if (key == 'W' || key == 'w' || keyCode == UP) {
    player.movingUp = false;
  }
  if (key == 'S' || key == 's' || keyCode == DOWN) {
    player.movingDown = false;
  }
  if (key == 'A' || key == 'a' || keyCode == LEFT) {
    player.movingLeft = false;
  }
  if (key == 'D' || key == 'd' || keyCode == RIGHT) {
    player.movingRight = false;
  }
}


void drawLoadingScreen() {
  background(0);  
  fill(255);
  textAlign(CENTER, CENTER);
  
  int smallerDimension = min(width, height);
  int newWidth = (int) (smallerDimension * 0.8); 
  int newHeight = (int) (loadingScreenImage.height * (float)newWidth / loadingScreenImage.width); // Convert to int

  // Center the loading screen image
  int x = (width - newWidth) / 2;
  int y = (height - newHeight) / 2;
  imageMode(CENTER);
  image(loadingScreenImage, x + newWidth / 2, y + newHeight / 2, newWidth, newHeight);

  textSize(20);
  int textY = y + newHeight + 20; 
  text("PRESS ANY KEY TO START", width / 2, textY);


  if (frameCount > loadingScreenTime) {
    gameStarted = true;
  }
}

void spawnEnemies(int count) {
  for (int i = 0; i < count; i++) {
    boolean isWaterEnemy = random(2) > 0.5;
    PImage enemyImage = isWaterEnemy ? waterEnemyImage : fireEnemyImage;

    if (isWaterEnemy) {
      enemies.add(new WaterEnemy(enemyImage));
    } else {
      enemies.add(new FireEnemy(enemyImage));
    }
  }
}

boolean isMuted = false;

void mousePressed() {
  if (mouseX > 10 && mouseX < 40 && mouseY > 10 && mouseY < 40) {
    isMuted = !isMuted;
    if (isMuted) {
      theme.pause();
    } else {
      theme.play();
    }
  }
}
