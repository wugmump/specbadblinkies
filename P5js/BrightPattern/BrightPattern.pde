/*
  Looped Pattern
  Francis Cousins
  Created in Lab 16/02/2018
*/

// Found at: https://www.openprocessing.org/sketch/510097
// Runs in P5js

//Defining intiables for Gradient
int Y_AXIS = 1;
int X_AXIS = 2;
int b1, b2;

int xPos;
int yPos;
int ellipseWidth = 200;
int ellipseHeight = 200;
int sSize = 1;

// create intiables for cell & circle size - Kirk Woolford (Lecturer - Surrey University)
int cellSize;
int circSize;

void setup() {
  createCanvas(windowWidth, windowHeight);
  strokeWeight(1);
  
  xPos = windowWidth/2;
  yPos = windowHeight/2;
  cellSize = windowWidth/20;
  
  //Provides Setup for BG Gradient (https://p5js.org/examples/color-linear-gradient.html)
  b1 = color(100, 100, 190);
  b2 = color(10, 10, 15);
}

function draw() {
  
  //Set BG Colour (https://p5js.org/examples/color-linear-gradient.html)
  setGradient(0, 0, windowWidth, windowHeight, b1, b2, Y_AXIS);

  fill(0,0,0,0);
  
  //Value out of 255 with mouse movement (for colour)
  int ratioMouseX = mouseX / windowWidth;
  int ratioWidth = ratioMouseX * 255;
  int ratioMouseY = mouseY / windowHeight;
  int ratioHeight = ratioMouseY * 255;
  
  //Sets the square Size
  if (sSize == int(cellSize) + int(cellSize)) {
    aSize = false;
  }
  if (sSize == 1) {
    aSize = true;
  }
  if (aSize == true) {
    sSize = sSize + 0.5;
  }
  if (aSize == false) {
    sSize = sSize - 0.5;
  }
    
  //ellipse(xPos, yPos, ellipseWidth, ellipseHeight);
  //Loop of interactive circles - based on Loopy by Kirk Woolford (Lecturer - Surrey University)
  for (int y = 0; y <= height; y += cellSize) {
    for (int x = 0; x <= width; x += cellSize) {
      
      // set size of circle based on the distance between x, y, and the mouse
      circSize = width/(dist(x, y, mouseX, mouseY));
      if (circSize > cellSize) {
        circSize = cellSize;
      }
      
      //Creates squares
      noStroke();
      fill(ratioWidth,255 - ratioWidth,ratioHeight,150);
      rect(x - sSize/2,y - sSize/2,sSize,sSize,25);
      
      //Creates circles
      fill(circSize*100,circSize*20,0,circSize*100);
      ellipse(x, y, 1/circSize*100, 1/circSize*100);
      //stroke(0,0,0,(0.2-(circSize/cellSize))*255);
      //line(x, y, mouseX, mouseY);
    }
  }
}

//Set BG Colour (https://p5js.org/examples/color-linear-gradient.html)
void setGradient(x, y, w, h, c1, c2, axis) {

  noFill();
  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      int inter = map(i, y, y+h, 0, 1);
      int c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      int inter = map(i, x, x+w, 0, 1);
      int c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}
