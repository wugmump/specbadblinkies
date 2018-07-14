/*
 * SunRingFunRing
 * Joshua Goldberg 2018
 * working with Caroline S Eastman and Glen Duncan
 
 */

OPC opc;

int R;
int G;
int B;
int rad = 60;        // Width of the shape
float xpos, ypos;    // Starting position of shape    

float xspeed = 2.8;  // Speed of the shape
float yspeed = 2.2;  // Speed of the shape

int xdirection = 1;  // Left or Right
int ydirection = 1;  // Top to Bottom

int square;

void setup() {
  size(500, 500);

  opc = new OPC(this, "127.0.0.1", 7890);
  opc.showLocations(false);
  //colorMode(HSB, 100);
  frameRate(60);
  noStroke();
  ellipseMode(RADIUS);
  // Set the starting position of the shape
  xpos = width/2;
  ypos = height/2;

  //define the rings.
  //Rings are taken from the p5 canvas

  //// Map one 24-LED ring to the center of the window
  opc.ledRing(0, 32, width/2, height/2, width*0.45, 0);
  opc.ledRing(32,24, width/2, height/2, width*.40,0);
  opc.ledRing(64,16, width/2, height/2, width*.35,0);
  opc.ledRing(80,12, width/2, height/2, width*.30,0);
  opc.ledRing(92,8, width/2, height/2, width*.25,0);
  opc.led(100,width/2, height/2);
}

void draw()
{
  background(0);

  // Update the position of the shape
  xpos = xpos + ( xspeed * xdirection );
  ypos = ypos + ( yspeed * ydirection );

  // Test to see if the shape exceeds the boundaries of the screen
  // If it does, reverse its direction by multiplying by -1
  if (xpos > width-rad || xpos < rad) {
    xdirection *= -1;
  }
  if (ypos > height-rad || ypos < rad) {
    ydirection *= -1;
  }

  // Draw the shape
  ellipse(xpos, ypos, rad, rad);

  // When you haven't assigned any LEDs to pixels, you have to explicitly
  // write them to the server. Otherwise, this happens automatically after draw().
  opc.writePixels();
}
