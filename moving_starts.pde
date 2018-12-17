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
int spaceshipX = 150;
int spaceshipY = 150;
int initial = this.wth;
int backMove =0;
int currentBack = 0;
int xPos= wth;
int totalAsteroids = 30;
Special addOn;

// connect to serial port
int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;
float a = 0, b=0, r=0;

void setupBackground() {
  for(int i=0; i< imageArray.length; i++) {
    String temp = imageArray[i];
    backImg[i] = loadImage(temp);
    //if(i%2 == 0) {
    //  backImg[i] = loadImage("nebula1.jpg");
    //} else {
    //backImg[i] = loadImage("nebula2.jpg");
    //}
    backImg[i].resize(width, height);
  }
}

void setupAsteroid(){
  int i = 0;
  while(i < totalAsteroids) {  
    this.asteroid= loadImage("asteroid.png");
    asteroid.resize(40, 40);
    xAsteroid[i] = random(0, width);
    yAsteroid[i] = random(0, height);
    speed[i] = random(1, 5);
    i = i + 1;
  }
}

void setupSerialPort() {
  String portName ="/dev/tty.usbmodem14501";
  myPort = new Serial(this, portName, 9600);
  myPort.clear();

  myString = myPort.readStringUntil(lf);
  myString = null;
}

//void settings() {
//  fullScreen();
//}

void setup() {
  fullScreen();
  //size(500,500);
  background(0);
  setupBackground();
  setupAsteroid();
  setupStars();
  setupSpaceship();
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
}

void setupStars() {
  int i = 0;
  while(i < 100) {  
    x[i] = random(0, width);
    y[i] = random(0, height);
    speed[i] = random(1, 5);
    i = i + 1;
  }
}

void moveAsteroids() {
  for(int i=0; i < totalAsteroids; i++) {
    image(asteroid, xAsteroid[i], yAsteroid[i]);
    xAsteroid[i] = xAsteroid[i] -speed[i];
    if(xAsteroid[i] <= 0) {
      xAsteroid[i] = width;
      yAsteroid[i] = random(1, height);
    }
  }
}

void getDataSerial() {
  while (myPort.available() > 0) {
   String tempString = myPort.readStringUntil(lf);
   myString = myPort.readStringUntil(lf);
    if (myString != null) {
     // println(myString);
      float[] num = float(split(myString,','));
      if(num.length == 3) {
          int r = (int)num[1];
          this.a = num[0];
          //this.r = num[1];
          this.b = num[2];
          if(r > this.r) {
            this.spaceshipY = this.spaceshipY + 5;
            if(this.spaceshipX + (int)r >= width ) {
             this.spaceshipX = 20;          
            } 
            else if(this.spaceshipX + (int) r  <=0 ) { 
              this.spaceshipX = width - 20;
            }else {
              this.spaceshipX = this.spaceshipX + 5;
            }
          } 
          else if(r < this.r){
            this.spaceshipY = this.spaceshipY - 5;
            if(this.spaceshipX + (int)r >= width ) {
             this.spaceshipX = 20;          
            } else if(this.spaceshipX + (int) r  <=0 ) { 
              this.spaceshipX = width - 20;
            } else {
              this.spaceshipX = this.spaceshipX - 5;
            }
          }
          if(this.r != r) {
            if(this.spaceshipY >= height) {
              this.spaceshipY = 20;
            } else if(this.spaceshipY <= 0) {
              this.spaceshipY = height - 20;
            }
          }
          
          //this.spaceshipY = this.spaceshipY + (int)r;
          this.r = r;
          b = num[2];
      }
     
      
   //   println( a+ r + b);
      println("a" + a+"r" + r+"b" + b);
    }
  }
}

void draw() {
  //background(0);
  moveBackground();
  moveAsteroids();
  image(this.spaceship, this.spaceshipX, this.spaceshipY);
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
  int i = 0;
  while(i < 100) {
    point(x[i], y[i]);
  
    x[i] = x[i] - speed[i];
    if(x[i] < 0) {
      x[i] = width;
    }
    i = i + 1;
  }
  getDataSerial();
}
void moveBackground() {
  image(backImg[currentBack], backMove, 0);
  image(backImg[currentBack], backMove + (backImg[currentBack].width), 0);
  // pos 
  backMove--;
  if (backMove <- backImg[currentBack].width) {
    if(currentBack+1 < 4) { 
      currentBack = currentBack+1;
    } else { 
      currentBack = 0;
    }
    backMove=0;
  }
}
