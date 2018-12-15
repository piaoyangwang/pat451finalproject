
#include <Wire.h> // Must include Wire library for I2C
#include <SparkFun_MMA8452Q.h> // Includes the SFE_MMA8452Q library

// Begin using the library by creating an instance of the MMA8452Q
//  class. We'll call it "accel". That's what we'll reference from
//  here on out.
MMA8452Q accel;

// The setup function simply starts serial and initializes the
//  accelerometer.



int s0 = 2;     // pin number connected to pin S0 of the 4051
int s1 = 3;     // pin number connected to pin S1 of the 4051

int encoderPos = 0;     // encoder position
int lastPos = 0;        // keep track of last position   
int stateA=LOW;
int stateB=LOW;
int analogPin = 7;  // pin number connected to the multiplexer's z pin

float location = 0;
int button = 0;


void setup()
{
  pinMode(s0, OUTPUT);    // s0
  pinMode(s1, OUTPUT);    // s1
  Serial.begin(9600);
  Serial.println("MMA8452Q Test Code!");
  pinMode(analogPin, INPUT_PULLUP);
  accel.init();

   
}

// The loop function will simply check for new data from the
//  accelerometer and print it out if it's available.
void loop()
{
  displayButton();
  
  if (accel.available())
  {

    accel.read();
    location = accel.cy;
//    printCalculatedAccels();
//    printOrientation();
//    Serial.println(); 
  }

   encoderStep();
//   displayStep();
   delay(1);

  String aim = "";
  
  aim = String(location)+ "," + String(encoderPos) +"," + String(button);
  Serial.println(aim);
   
}

// The function demonstrates how to use the accel.x, accel.y and
//  accel.z variables.
// Before using these variables you must call the accel.read()
//  function!
void printAccels()
{
  Serial.print(accel.x, 3);
  Serial.print("\t");
  Serial.print(accel.y, 3);
  Serial.print("\t");
  Serial.print(accel.z, 3);
  Serial.print("\t");
}

// This function demonstrates how to use the accel.cx, accel.cy,
//  and accel.cz variables.
// Before using these variables you must call the accel.read()
//  function!
void printCalculatedAccels()
{ 
  Serial.print(accel.cx, 3);
  Serial.print("\t");
  Serial.print(accel.cy, 3);
  Serial.print("\t");
  Serial.print(accel.cz, 3);
  Serial.print("\t");
}

// This function demonstrates how to use the accel.readPL()
// function, which reads the portrait/landscape status of the
// sensor.
void printOrientation()
{
//   accel.readPL() will return a byte containing information
//   about the orientation of the sensor. It will be either
//   PORTRAIT_U, PORTRAIT_D, LANDSCAPE_R, LANDSCAPE_L, or
//   LOCKOUT.
  byte pl = accel.readPL();
  switch (pl)
  {
  case PORTRAIT_U:
    Serial.print("Portrait Up");
    break;
  case PORTRAIT_D:
    Serial.print("Portrait Down");
    break;
  case LANDSCAPE_R:
    Serial.print("Landscape Right");
    break;
  case LANDSCAPE_L:
    Serial.print("Landscape Left");
    break;
  case LOCKOUT:
    Serial.print("Flat");
    break;
  }
}


void encoderStep(){

   int readingA,readingB;
  
    digitalWrite(s0, LOW);
    digitalWrite(s1, HIGH);
   
   readingA = digitalRead(analogPin);

    digitalWrite(s0, HIGH);
    digitalWrite(s1, LOW);
   
   readingB= digitalRead(analogPin);

   
   //readingA = digitalRead(pinA);
   //readingB = digitalRead(pinB);
   if (stateA!=readingA) {  //state has changed->tick
     if (readingA==readingB)    //CW
          ++encoderPos;
      else
          --encoderPos;         //CCW
    }
   /*if (stateB!=readingB) { //state has changed->tick
      if (readingA==readingB)   //CCW
          --encoderPos;
      else
          ++encoderPos;         //CW
   }*/
   stateA = readingA;   //update state to current reading
   stateB = readingB;
    
} 
  
void displayStep() {
  if (encoderPos != lastPos) {    //position has changed
//    Serial.write(255);
//    Serial.println(encoderPos); //send new position
  }
  lastPos=encoderPos;           //store current position
}


void displayButton(){
  int buttonread;
   digitalWrite(s0, LOW);
   digitalWrite(s1, LOW);
   buttonread= digitalRead(analogPin);
   button = buttonread;
//  Serial.println(buttonread);
}
