import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

import processing.serial.*;

Serial myPort;
int xPos = 1;

Minim minim;
AudioPlayer []songs;


float Capacitance;
int []inBytes;
String inString;
String []inStrings;

void setup () {
  size(400, 300);        
  inBytes=new int[3];
  
  // List all the available serial ports
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[2], 9600);
  
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
  // set inital background:
  background(0);

  minim = new Minim(this);
  songs=new AudioPlayer[3];
//  song[0] = minim.loadFile("Morning 3D Printed Ukulele Improv.wav");
  songs[0]=minim.loadFile("2.wav");
  songs[1]=minim.loadFile("7.wav");
  songs[2]=minim.loadFile("8.mp3");
  songs[0].play();
  songs[1].play();
  songs[2].play();
//  songs[0].loop();
//  songs[1].loop();
  songs[0].pause();
  songs[1].pause();
  songs[2].play();
}
void draw () {
  
  if (inBytes[0]>2000) {
    if(!songs[0].isPlaying())
    {
      songs[0].play(0);
    }
  }
  else
  {
    songs[0].pause();
  }
  
  if (inBytes[1]>2000) {
    if(!songs[1].isPlaying())
    {
      songs[1].play(0);
    }
  }
  else
  {
    songs[1].pause();
  }
  
  if (inBytes[2]>5000) {
    if(!songs[2].isPlaying())
    {
      songs[2].play(0);
    }
  }
  else
  {
    songs[2].pause();
  }
}

void serialEvent (Serial myPort) {
  // get the ASCII string:
  inString = myPort.readStringUntil('\n');
  inString = trim(inString);
  if (inString != null) {
    // trim off any whitespace:
//    println(inString);
    inStrings=inString.split(" ");
//    inBytes=new int[inStrings.length];
    try{
      for(int i=0;i<inStrings.length;i++)
      {
        inBytes[i]=Integer.parseInt(inStrings[i]);
      }
      float inByte=inBytes[0];
      inByte = map(inByte, 000, 20000, 0, height);
  
      // draw the line:
      stroke(127, 34, 255, 80);
      line(xPos, height, xPos, height - inByte);
      
      inByte=inBytes[1];
      inByte = map(inByte, 000, 20000, 0, height);
  
      // draw the line:
      stroke(255, 34, 127, 80);
      line(xPos, 0, xPos, inByte);
  
      // at the edge of the screen, go back to the beginning:
      if (xPos >= width) {
        xPos = 0;
        background(0);
      } 
      else {
        // increment the horizontal position:
        xPos++;
      }
    }
    catch(Exception e)
    {
      println(e);
    }
  }
}

