import processing.serial.*;

int lf = 10;    // Linefeed in ASCII
String myString = null;
Serial myPort;
int xPos;
float a =0;
float r =0;
float b =0;

void setup(){
 size (255,255);
 //println(Serial.list());
String portName ="/dev/tty.usbmodem14501";
myPort = new Serial(this, portName, 9600);
myPort.clear();

myString = myPort.readStringUntil(lf);
myString = null;
}


void draw() {
  
    background(int(r));
 
   fill(255);
 ellipse(a*100, height/2, 20, 20);
  
  
  
  
  while (myPort.available() > 0) {
   String tempString = myPort.readStringUntil(lf);
   myString = myPort.readStringUntil(lf);
    if (myString != null) {
     // println(myString);
      float[] num = float(split(myString,','));
      a = num[0];
      r = num[1];
      b = num[2];
      
   //   println( a+ r + b);
      println("a" + a+"r" + r+"b" + b);
    }
  }

}
//void draw(){
//  background(0);
//  fill(255);
//  ellipse(xPos, height/2, 20, 20);
//}

//void serialEvent(Serial myPort){
 
//xPos = myPort.read();
//}
