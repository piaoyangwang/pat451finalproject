import processing.serial.*;

float[] x = new float[100];
float[] y = new float[100];
float[] speed = new float[100];
float[] xAsteroid = new float[100];
float[] yAsteroid = new float[100];
float[] speedAsteroid = new float[100];

int hgt = 600; // setting up base height for the game
int wth = 1200;  // base width
String imageArray[] = {"nebula1.jpg", "nebula2.jpg", "nebula3.jpg", "nebula4.jpg"};
PImage backImg[] = new PImage[imageArray.length];
PImage asteroid;
PImage spaceship;
PImage crosshair;
PImage explosion;
PImage missileRegular;
float[] xmissileReg = new float[20];
float[] ymissileReg = new float[20];
float[] speedMissileReg = new float[20];
int spaceshipX = 150;
int spaceshipY = 150;
int initial = this.wth;
int backMove =0;
int currentBack = 0;
int currentMissileCount =0;
int totalMissiles = 20;
int xPos= wth;
int totalAsteroids = 50;
int firePositionX = 150;
int firePositionY = 150;
int asteroidSize = 40;
int missileSize = 30;
int spaceshipSize = 40;

Special addOn;

// connect to serial port
int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;
float a = 0, b=0, r=0;

void setupBackground() {
  for (int i=0; i< imageArray.length; i++) {
    String temp = imageArray[i];
    backImg[i] = loadImage(temp);
    backImg[i].resize(width, height);
  }
}

void setupAsteroid() {
  int i = 0;
  this.asteroid= loadImage("asteroid.png");
  asteroid.resize(40, 40);
  while (i < totalAsteroids) {  
    this.xAsteroid[i] = random(0, width);
    this.yAsteroid[i] = random(0, height);
    this.speedAsteroid[i] = random(1, 9);
    i = i + 1;
  }
}

void shooting() {
  int i= this.currentMissileCount;
  if (i < totalMissiles) {
    this.xmissileReg[i] = this.firePositionX;
    this.ymissileReg[i] = this.firePositionY + this.a;
    this.speedMissileReg[i] = 5.0;
  }
  this.currentMissileCount = this.currentMissileCount +1;
}

void setupSerialPort() {
  println(Serial.list());
  String portName ="/dev/tty.usbmodem14501";
  myPort = new Serial(this, portName, 9600);
  myPort.clear();

  myString = myPort.readStringUntil(lf);
  myString = null;
}

void setupExplosion() {
  this.explosion = loadImage("explosion.png");
  this.explosion.resize(80, 80);
}

void setup() {
  fullScreen();
  background(0);
  setupBackground();
  setupAsteroid();
  setupStars();
  setupSpaceship();
  //for(int i=0; i< 20; i++) {
  //   shooting();
  //}
  setupExplosion();
  setupSerialPort();
  //this.xPos = width;
  //background(backImg);
  stroke(255);
  strokeWeight(5);
  addOn = new Special(100, 100, 15);
}

void setupSpaceship() {
  this.spaceship= loadImage("spaceship.png");
  this.spaceship.resize(70, 70);
  this.crosshair = loadImage("crosshair.png");
  this.crosshair.resize(40, 40);
  this.missileRegular = loadImage("missile-regular.png");
  this.missileRegular.resize(30, 30);
}

void setupStars() {
  int i = 0;
  while (i < 100) {  
    x[i] = random(0, width);
    y[i] = random(0, height);
    speed[i] = random(1, 5);
    i = i + 1;
  }
}

void moveAsteroids() {
  for (int i=0; i < totalAsteroids; i++) {
    image(asteroid, xAsteroid[i], yAsteroid[i]);
    xAsteroid[i] = xAsteroid[i] - speedAsteroid[i];
    if (xAsteroid[i] <= 0) {
      speedAsteroid[i] = random(1, 4);
      xAsteroid[i] = width - speedAsteroid[i];
      yAsteroid[i] = random(1, height);
    } else {
      checkCollision(i);
    }
  }
}

public void checkCollision(int index) {
  for (int i=0; i< this.currentMissileCount; i++) {
    float distance = dist(xAsteroid[index], yAsteroid[index], xmissileReg[i], ymissileReg[i]);
    if (distance < (this.asteroidSize)) {
      missileHit(index, i);
    }
  }
}

void missileHit(int asteroidIndex, int missileIndex) {
  image(this.explosion, xAsteroid[asteroidIndex]- speedMissileReg[missileIndex], yAsteroid[asteroidIndex]- speedMissileReg[missileIndex]);
  xAsteroid[asteroidIndex] = width;
  speedAsteroid[asteroidIndex] = random(1, 5);
  yAsteroid[asteroidIndex] = random(1, height);

  this.xmissileReg[missileIndex] = 0;
  this.ymissileReg[missileIndex] = random(10, height);
}

//float[] removeArrayElement(int position, float []array) {
//  if(array.length < position) {
//    return array.subset(0, array.length);
//  };
//}

void moveMissiles() {
  for (int i= 0; i< this.currentMissileCount; i++) {
    this.xmissileReg[i] = this.speedMissileReg[i] + this.xmissileReg[i];
    this.ymissileReg[i] = this.a + this.ymissileReg[i];
    if (this.xmissileReg[i] > width) {
      this.xmissileReg[i] = 10 + this.speedMissileReg[i];
      image(this.missileRegular, this.xmissileReg[i], this.ymissileReg[i]);
    } else image(this.missileRegular, this.xmissileReg[i], this.ymissileReg[i]);
  }
}

void getDataSerial() {
  while (myPort.available() > 0) {
    String tempString = myPort.readStringUntil(lf);
    myString = myPort.readStringUntil(lf);
    if (myString != null) {
      // println(myString);
      float[] num = float(split(myString, ','));
      if (num.length == 3) {
        int r = (int)num[1];
        this.a = num[0];
        //this.r = num[1];
        float b = num[2];
        if (r > this.r) {
          this.spaceshipY = this.spaceshipY + 5;
          if (this.spaceshipX + (int)r >= width ) {
            this.spaceshipX = 20;
          } else if (this.spaceshipX + (int) r  <=0 ) { 
            this.spaceshipX = width - 20;
          } else {
            this.spaceshipX = this.spaceshipX + 5;
          }
        } else if (r < this.r) {
          this.spaceshipY = this.spaceshipY - 5;
          if (this.spaceshipX + (int)r >= width ) {
            this.spaceshipX = 20;
          } else if (this.spaceshipX + (int) r  <=0 ) { 
            this.spaceshipX = width - 20;
          } else {
            this.spaceshipX = this.spaceshipX - 5;
          }
        }
        if (this.r != r) {
          if (this.spaceshipY >= height) {
            this.spaceshipY = 20;
          } else if (this.spaceshipY <= 0) {
            this.spaceshipY = height - 20;
          }
        }

        //this.spaceshipY = this.spaceshipY + (int)r;
        this.r = r;
        b = num[2];
        if(this.b != b ) {
          this.b = b;
          if(this.b == 0) {
            shooting();
          }
        }
        
        float a = num[0] * 90;
        this.a = a; 
        
        
      }
      

      //   println( a+ r + b);
      println("a" + a+"r" + r+"b" + b);
    }
  }
}

void spaceshipMove() {
  image(this.spaceship, this.spaceshipX, this.spaceshipY);
  image(this.crosshair, this.spaceshipX + 180, this.spaceshipY+ this.a);
  this.firePositionX = this.spaceshipX;
  this.firePositionY = this.spaceshipY;
}

void draw() {
  //background(0);
  moveBackground();
  moveStars();
  spaceshipMove();
  moveMissiles();
  moveAsteroids();
  //image(this.missileRegular, this.firePositionX, this.firePositionY);
  //ellipse(xPos, 200, 40, 40);
  //xPos=xPos-2;

  //image(backImg, backMove, 0);
  //image(backImg, backMove + backImg.width, 0);
  //// pos 
  //backMove--;
  //if (backMove<-backImg.width) {
  //  backMove=0;
  //}
  addOn.live();
  //
  //background(backImg);

  getDataSerial();
}
void moveBackground() {
  image(backImg[currentBack], backMove, 0);
  image(backImg[currentBack], backMove + (backImg[currentBack].width), 0);
  // pos 
  backMove--;
  if (backMove <- backImg[currentBack].width) {
    if (currentBack+1 < 4) { 
      currentBack = currentBack+1;
    } else { 
      currentBack = 0;
    }
    backMove=0;
  }
}

void moveStars() {
  int i = 0;
  while (i < 100) {
    point(x[i], y[i]);
    x[i] = x[i] - speed[i];
    if (x[i] < 0) {
      x[i] = width;
    }
    i = i + 1;
  }
}
