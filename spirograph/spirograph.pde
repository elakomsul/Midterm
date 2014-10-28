import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer sou;

// SPIROGRAPH
// http://en.wikipedia.org/wiki/Spirograph
// also (for inspiration):
// http://ensign.editme.com/t43dances
//
// this processing sketch uses simple OpenGL transformations to create a
// Spirograph-like effect with interlocking circles (called sines).  
// press the spacebar to switch between tracing and
// showing the underlying geometry.
//
// your tasks:
// (1) tweak the code to change the simulation so that it draws something you like.
// hint: you can change the underlying system, the way it gets traced when you hit the space bar,
// or both.  try to change *both*.  :)
// (2) use minim to make the simulation MAKE SOUND.  the full minim docs are here:
// http://code.compartmental.net/minim/
// hint: the website for the docs has three sections (core, ugens, analysis)... look at all three
// another hint: minim isn't super efficient with a large number of things playing at once.
// see if there's a simple way to get an effective sound, or limit the number of shapes
// you're working with.

int NUMSINES = 10; // how many of these things can we do at once?
float[] sines = new float[NUMSINES]; // an array to hold all the current angles
float rad; // an initial radius value for the central sine
int i; // a counter variable

float red, green, blue;

// play with these to get a sense of what's going on:
float fund = 0.02; // the speed of the central sine
float ratio = 3.; // what multiplier for speed is each additional sine?
int alpha = 100; // how opaque is the tracing system

boolean trace = false; // are we tracing?

void setup()
{
  size(800, 600, P3D); // OpenGL mode

  rad = height/5.; // compute radius for central circle
  background(255); // clear the screen
  
  red = random(0, 255);
  green = random(0, 255);
  blue = random(0, 255);

  for (int i = 0; i<sines.length; i++)
  {
    sines[i] = PI; // start EVERYBODY facing NORTH
  }
  
  {
    minim = new Minim(this);
    sou = minim.loadFile("chopin.mp3");
    sou.loop();
  }
}

void draw()
{

  if (!trace) background(255); // clear screen if showing geometry
  if (!trace) {
    stroke(red, green, blue); // black pen
    noFill(); // don't fill
  }  

  // MAIN ACTION
  pushMatrix(); // start a transformation matrix
  translate(width/2, height/2); // move to middle of screen

  for (i = 0; i<sines.length; i++) // go through all the sines
  {
    float erad = 50; // radius for small "point" within circle... this is the 'pen' when tracing
    // setup tracing
    if (trace) {
      stroke(red, green, blue); //random color
      fill(0, 0, 255, alpha/2); // also, um, blue
      erad = 5.0*(1.0-float(i)/sines.length); // pen width will be related to which sine
    }
    float radius = rad/(i+1); // radius for circle itself
    rotateZ(sines[i]); // rotate circle
    if (!trace) ellipse(0, 0, radius*4, radius*4); // if we're simulating, draw the sine
    pushMatrix(); // go up one level
    translate(0, radius); // move to sine edge
    if (!trace) ellipse(0, 0, 10, 10); // draw a little circle
      stroke(red, green, blue); //random color
      fill(0, 0, 255, alpha/2); // also, um, blue
    if (trace) ellipse(10, 30, erad, erad); // draw with erad if tracing
    popMatrix(); // go down one level
    translate(50, radius); // move into position for next sine
    sines[i] = (sines[i]+(fund+(fund*i*ratio)))%TWO_PI; // update angle based on fundamental
  }
  popMatrix(); // pop down final transformation
}

void keyReleased()
{
  if (key==' ') {
    trace = !trace; 
    background(255);
  }
}

