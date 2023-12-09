PImage waterEnemyImage, fireEnemyImage;

class Enemy {
  float x, y, speed, size, xSpeed;
  PImage enemyImage;

  Enemy(PImage img) {
    respawn();
    size = random(20, 60);
    xSpeed = random(-1, 1);
    enemyImage = img;
  }

  void respawn() {
    x = random(width);
    y = -random(100, 500);
    speed = random(1, 3);
  }

  void move() {
    y += speed;
    x += xSpeed;
    if (x < 0 || x > width) xSpeed *= -1;
    if (y > height) respawn();
  }

  void display() {
    image(enemyImage, x, y, size, size);
  }

  void shoot() {}
}

class WaterEnemy extends Enemy {
  ArrayList<WaterParticle> waterParticles;
  int lastShotTime, shootInterval;

  WaterEnemy(PImage img) {
    super(img);
    waterParticles = new ArrayList<WaterParticle>();
    lastShotTime = millis();
    shootInterval = 3000;
  }

  void move() {
    super.move();
    if (millis() - lastShotTime > shootInterval) {
      shoot();
      lastShotTime = millis();
    }
  }

  void shoot() {
    waterParticles.add(new WaterParticle(x + size / 2, y + size / 2));
  }

  void display() {
    super.display();
    for (WaterParticle particle : waterParticles) {
      particle.move();
      particle.display();
    }
  }
}

class FireEnemy extends Enemy {
  ArrayList<FireParticle> fireParticles;
  int lastShotTime, shootInterval;

  FireEnemy(PImage img) {
    super(img);
    fireParticles = new ArrayList<FireParticle>();
    lastShotTime = millis();
    shootInterval = 5000;
  }

  void move() {
    super.move();
    if (millis() - lastShotTime > shootInterval) {
      shoot();
      lastShotTime = millis();
    }
  }

  void shoot() {
    fireParticles.add(new FireParticle(x + size / 2, y + size / 2));
  }

  void display() {
    super.display();
    for (FireParticle particle : fireParticles) {
      particle.move();
      particle.display();
    }
  }
}

class WaterParticle {
  float x, y, speed;
  PImage[] waterFrames = new PImage[3];
  int currentFrame = 0;

  WaterParticle(float startX, float startY) {
    x = startX;
    y = startY;
    speed = 5;
    
    for (int i = 0; i < 3; i++) {
      String filename = "water" + i + ".png";
      waterFrames[i] = loadImage(filename);
    }
  }

  void move() {
    y += speed; 
  }

  void display() {
   image(waterFrames[currentFrame], x, y, 35, 35);
    if (frameCount % 5 == 0) {
      currentFrame = (currentFrame + 1) % 3;
    }
  }
}

class FireParticle {
  float x, y, speed;
  PImage[] fireFrames = new PImage[3];
  int currentFrame = 0;

  FireParticle(float startX, float startY) {
    x = startX;
    y = startY;
    speed = 5;
    for (int i = 0; i < 3; i++) {
      String filename = "fire" + i + ".png";
      fireFrames[i] = loadImage(filename);
    }
  }

  void move() {
    y += speed; 
  }

  void display() {
    image(fireFrames[currentFrame], x, y, 35, 35);
    if (frameCount % 5 == 0) {
      currentFrame = (currentFrame + 1) % 3;
    }
  }
}
