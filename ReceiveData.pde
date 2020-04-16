/*
@author Tommy Boonchuaysream
 - draw a circle, change the size by adjusting the potentiometer
 - press the switch to see the background color change
 - text appears if the circle is too small or too big
 */


// Importing the serial library to communicate with the Arduino 
import processing.serial.*;    

// Initializing a vairable named 'myPort' for serial communication
Serial myPort;      

// Data coming in from the data fields
String [] data;
int switchValue = 0;    // index from data fields
int potValue = 1;

// Change to appropriate index in the serial list — YOURS MIGHT BE DIFFERENT
int serialIndex = 0;

// animated ball
int minPotValue = 0;
int maxPotValue = 4095;    // will be 1023 on other systems
int minBallSize = 0;
int maxBallSize = 50;

int randomRed = int(random(255));
int randomGreen = int(random(255));
int randomBlue = int(random(255));


void setup ( ) {
  size (800, 600);    

  // List all the available serial ports
  printArray(Serial.list());

  // Set the com port and the baud rate according to the Arduino IDE
  myPort  =  new Serial (this, Serial.list()[serialIndex], 115200);
} 

//call this to get the data 
void checkSerial() {
  while (myPort.available() > 0) {
    String inBuffer = myPort.readString();  

    print(inBuffer);

    // This removes the end-of-line from the string AND casts it to an integer
    inBuffer = (trim(inBuffer));

    data = split(inBuffer, ',');

    // do an error check here?
    switchValue = int(data[0]);
    potValue = int(data[1]);
  }
} 

//-- change background to red if we have a button
void draw ( ) {  
  // every loop, look for serial information
  checkSerial();
  drawBackground();
  drawBall();
} 

// if input value is 1 (from ESP32, indicating a button has been pressed), change the background
void drawBackground() {
  if ( switchValue == 1 ) {
    //random background color
    randomRed++;
    randomGreen++;
    randomBlue++;
    background(randomRed, randomGreen, randomBlue);
  } else {
    //reset background color and make a new random background color
    background(0); 
    randomRed = int(random(255));
    randomGreen = int(random(255));
    randomBlue = int(random(255));
  }
}

//-- animate ball left to right, use potValue to change speed
void drawBall() {
  fill(169, 204, 227);

  //value from potentiometer
  float size = map(potValue, minPotValue, maxPotValue, minBallSize, maxBallSize);

  //lets you know that you can't see the circle because it's too small
  if (size == 0) {
    textSize(32);
    text("It's gone!", 330, 300);
  }

  //exponential size changes
  size = pow(size, 2);

  //adjust ellipse's size according to the potentiometer
  fill(169, 204, 227);
  ellipse(400, 300, size, size);

  //lets you know that you can't see the background if the circle is covering it
  if (size > 1000) {
    textSize(32);
    fill(0);
    text("You can't see the background!", 180, 300);
  }
}
