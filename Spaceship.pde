PImage spaceshipImage;

class Spaceship {
  float x, y, speed, maxY;
  boolean movingUp, movingDown, movingLeft, movingRight;
  ArrayList<Bullet> bullets;
  int lives;
  int score;
  int highScore;

  Spaceship() {
    x = width / 2;
    y = height - 50;
    maxY = height / 2;
    speed = 4;
    movingUp = false;
    movingDown = false;
    movingLeft = false;
    movingRight = false;
    bullets = new ArrayList<Bullet>();
    spaceshipImage = loadImage("spaceship.png");
    lives = 3; // Initial number of lives
    highScore = loadHighScore();
  }

  void update() {
    if (movingUp && y > maxY) {
      y -= speed;
    }
    if (movingDown && y < height - 20) {
      y += speed;
    }
    if (movingLeft && x > 20) {
      x -= speed;
    }
    if (movingRight && x < width - 20) {
      x += speed;
    }

    for (Bullet bullet : bullets) {
      bullet.move();
    }

    bullets.removeIf(bullet -> bullet.y < 0);
  }

  void display() {
    spaceshipImage.resize(50, 50);
    imageMode(CENTER);
    image(spaceshipImage, x, y);
  }

  void shoot() {
    bullets.add(new Bullet(x + spaceshipImage.width / 2, y));
  }

  void checkCollisions(ArrayList<Enemy> enemies) {
    for (Enemy enemy : enemies) {
      if (collision(x, y, spaceshipImage.width, spaceshipImage.height, enemy.x, enemy.y, enemy.size, enemy.size)) {
        handleCollision();
      }
    }

    for (Enemy enemy : enemies) {
      if (enemy instanceof WaterEnemy) {
        WaterEnemy waterEnemy = (WaterEnemy) enemy;
        for (WaterParticle particle : waterEnemy.waterParticles) {
          if (collision(x, y, spaceshipImage.width, spaceshipImage.height, particle.x, particle.y, 5, 5)) {
            handleCollision();
          }
        }
      }
    }

    for (Enemy enemy : enemies) {
      if (enemy instanceof FireEnemy) {
        FireEnemy fireEnemy = (FireEnemy) enemy;
        for (FireParticle particle : fireEnemy.fireParticles) {
          if (collision(x, y, spaceshipImage.width, spaceshipImage.height, particle.x, particle.y, 10, 10)) {
            handleCollision();
          }
        }
      }
    }
  }

  void handleCollision() {
    lives--;
    x = width / 2;
    y = height - 50;
  }
  
  int loadHighScore() {
    String[] lines = loadStrings("highscore.txt");
    if (lines.length > 0) {
      return int(lines[0]);
    }
    return 0;
  }
  
  void saveHighScore(int newHighScore) {
    String[] data = { str(newHighScore) };
    saveStrings("highscore.txt", data);
  }

  boolean collision(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
    return x1 < x2 + w2 &&
      x1 + w1 > x2 &&
      y1 < y2 + h2 &&
      y1 + h1 > y2;
  }

  void reset() {
    lives = 3;
    x = width / 2;
    y = height - 50;
    score = 0;
  }
}

class Bullet {
  float x, y, speed;
  boolean offScreen;
  int frameIndex;
  int frameDelay = 5;
  int frameCount = 0;

  Bullet(float startX, float startY) {
    x = startX - 25;
    y = startY;
    speed = 5;
    offScreen = false;
    frameIndex = 0;
  }

  void move() {
    y -= speed;
  }

  void display(ArrayList<Enemy> enemies) {
    move();
    
    image(bulletFrames[frameIndex], x, y, 20, 20);

    frameCount++;
    if (frameCount >= frameDelay) {
      frameIndex = (frameIndex + 1) % 5;  // Cycle through frames
      frameCount = 0;
    }

    for (int i = enemies.size() - 1; i >= 0; i--) {
      Enemy enemy = enemies.get(i);
      if (collision(x, y, 5, 15, enemy.x, enemy.y, enemy.size, enemy.size)) {
        enemies.remove(i);
        offScreen = true;
        player.score++;
        if (player.score > player.highScore) {
          player.highScore = player.score;
          player.saveHighScore(player.highScore);
        }
        return;
      }
    }

    if (y < 0) {
      offScreen = true;
    }
  }

  boolean collision(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
    return x1 < x2 + w2 &&
           x1 + w1 > x2 - 25 &&
           y1 < y2 + h2 &&
           y1 + h1 > y2;

  }
}
