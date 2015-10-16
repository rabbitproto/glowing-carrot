/*
Treehouse Projects - www.treehouseprojects.ca
 Jellyfish Fields
 Aug. 2012
 */

import processing.serial.*; //so that I can use my controller

int numJellyfish = 3; //number of jellyfish you want in the game
Jellyfish[] jellyfishArray; //array of jellyfish
PImage bg; //background image
PImage jf; //jellyfish image
PImage sb; //spongebob image
int jellyfishSize = 50; //size of target jellyfish
int score = 0; //current score
int timeLeft = 2000; //duration of each game (app. timeLeft / 100 in seconds)
boolean mouseController = false; //if true, user has selected to use mouse to play game
boolean gameStart = false; //if true, game is in progress
PFont spongeFont; //declaring the font used in the gameplay text
Serial nesPort; //declaring serial port to communicate with controller
int spongebobXLoc = 150;
int spongebobYLoc = 200; //xy location of spongebob
int controllerSensitivity = 9; //the higher the number, the more pixels the controller can move spongebob per tap
int endOfGameDelayCycles = 300;
boolean endScreenActive = false;

void setup() {
  size(320, 480);
  noCursor();

  //initializing the array
  jellyfishArray = new Jellyfish[numJellyfish]; 
  for (int i = 0; i < numJellyfish; i++)
  {  
    jellyfishArray[i] = new Jellyfish();
  }

  //loading the images
  bg = loadImage("background.jpg");
  jf = loadImage("jellyfish.png");
  sb = loadImage("spongebob.png");

  //loading font
  spongeFont = createFont("buzzFont.ttf", 15);
  textFont(spongeFont);

  //initializing serial port
  String nesPortName = Serial.list()[2];
  nesPort = new Serial(this, nesPortName, 9600);
}

void draw() {
  background(bg);
  textSize(11);
  text("treehouseprojects.ca", 180, 460);

  if (timeLeft < 10) {
    endScreenActive = true;
    fill(255);
    rect(35, 200, 262, 50);

    fill(0);
    textSize(15);
    text("Congratulations, Your Score Is:", 50, 220); 
    textSize(30);
    text(score, 152, 245);

    endOfGameDelayCycles--;

    if (endOfGameDelayCycles < 5) {
      timeLeft = 2000;
      endOfGameDelayCycles = 300;

      gameStart = false;
      score = 0;
      mouseController = false;
      endScreenActive = false;
    }
  }

  //start game menu
  if (gameStart == false) {
    fill(255);
    rect(35, 195, 250, 100);

    fill(0);
    textSize(15);
    text("Press A on the Keyboard", 60, 220); 
    text("to Use the Mouse", 85, 240);
    text("Press A on Your Controller", 55, 265); 
    text("to Use it Instead", 88, 285);

    if (keyPressed) {
      if (key == 'a' || key == 'A') {
        mouseController = true;
        gameStart = true;
      }
    }

    if (nesPort.readChar() == 'A') {
      mouseController = false;
      gameStart = true;
    }
  }

  if ((gameStart == true) && (endScreenActive == false)) {

    for (int i = 0; i < numJellyfish; i++)
    {  
      jellyfishArray[i].drawJellyfish();
    }
    moveSpongebob();

    fill(0);
    textSize(15);
    text("Score: " + score, 20, 20);
    text("Time Left: " + timeLeft/100, 200, 20);
  }
}

void moveSpongebob() {

  if (mouseController == false) {

    char directionPressed = nesPort.readChar();

    if (directionPressed == 'R')
      spongebobXLoc += controllerSensitivity;

    if (directionPressed == 'L')
      spongebobXLoc -= controllerSensitivity;

    if (directionPressed == 'D')
      spongebobYLoc += controllerSensitivity;

    if (directionPressed == 'U')
      spongebobYLoc -= controllerSensitivity;

    image(sb, spongebobXLoc, spongebobYLoc, 102, 153);
  }


  if (mouseController == true) {
    image(sb, mouseX, mouseY, 102, 153);
    spongebobXLoc= mouseX;
    spongebobYLoc= mouseY;
  }

  for (int i = 0; i < numJellyfish; i++) {
    if ((abs(spongebobXLoc - jellyfishArray[i].getXLoc()) < 35) && (abs(spongebobYLoc - jellyfishArray[i].getYLoc()) < 35)) {
      jellyfishArray[i].setLifeStatus(false);
      fill(224, 27, 96);
      score++;
    }
  }
  timeLeft--;
}

class Jellyfish {
  float xLoc, yLoc, lifeDuration;
  boolean lifeStatus; //x location, y location, how long it will stay on screen, dead (0) or alive (1)

  Jellyfish() {
    xLoc = random(jellyfishSize, width - (jellyfishSize + 10));
    yLoc = random(jellyfishSize, height - (jellyfishSize + 10));

    if (mouseController == true)
      lifeDuration = random(50, 125);
    if (mouseController == false)
      lifeDuration = random(100, 200);

    lifeStatus = true;
  }

  float getXLoc() {
    return xLoc;
  }

  float getYLoc() {
    return yLoc;
  }

  void setLifeStatus(boolean tempLifeStatus) {
    lifeStatus = tempLifeStatus;
  }

  void drawJellyfish() {
    lifeDuration--;

    if ((lifeDuration >= 0) && (lifeStatus == true))
      image(jf, xLoc, yLoc, jellyfishSize, jellyfishSize);

    else {
      xLoc = random(jellyfishSize, width - (jellyfishSize + 10));
      yLoc = random(jellyfishSize, height - (jellyfishSize + 10));

      if (mouseController == true)
        lifeDuration = random(50, 125);
      if (mouseController == false)
        lifeDuration = random(100, 200);

      lifeStatus = true;
    }
  }
}

