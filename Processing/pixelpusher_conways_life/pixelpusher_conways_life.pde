/*
 *  Because whenever geeks are gathered together with a bitmapped display,
 *  someone will implement Conway's Life.  Written while 3/4 drunk, at
 *  ORD Camp 2014, with help from some of the guests whose names escape me.
 *  If it was you, please let me know and I'll credit you here.  -Jas
 */

// Unknown origin
// Runs on Processing
// Super slow to connect to OPC.

OPC opc;

//import processing.core.*;
//import java.util.*;

//DeviceRegistry registry;

int stride = 120;
boolean use_weighted_get = true;

boolean ready_to_go = true;

int canvasW = 160;
int canvasH = 100;

int arrayWidth = 16;
int arrayHeight = 10;

int[][] cells;
int scaleX;
int scaleY;

void setup() {
  size(160, 100, P3D);
  scaleX = width / arrayWidth;
  scaleY = height / arrayHeight;
  
  opc = new OPC(this, "rhubarb.local", 7890);
  opc.ledGrid(0, 16, 10, width/2, height/2, 10, 10, 0, false, false);
  
  stroke(#000000);
  fill(#000000);
  colorMode(HSB, 100, 100, 100, 100);
  rectMode(CORNERS);

  cells = populate();
  frameRate(20);
  background(0);
}


int[][] populate() {
  int[][] initCells = new int[arrayWidth][arrayHeight];
  for (int x = 0; x < arrayWidth; x++) {
    for (int y = 0; y < arrayHeight; y++) {
      if (random(1) < .50) {
        initCells[x][y] = 1;
      }
    }
  }

  return initCells;
}


void render(int[][] cells) {
  //background(0);
  noStroke();
  //fill(color(0, 0, 10, 8));
  fill(color(0, 0, 0));
  rect(0, 0, width, height);
  for (int x = 0; x < arrayWidth; x++) {
    for (int y = 0; y < arrayHeight; y++) {
      if (cells[x][y] > 0) {
        fill(color(10*cells[x][y], 75, 50));
        ellipseMode(CENTER);
        ellipse(x*(width / arrayWidth)+6, y *(height/arrayHeight)+5, height/arrayHeight, height/arrayHeight );
      } 
//      else {
//        stroke(color(0, 0, 0, 25));
//        point(x, y);
//      }
    }
  }
}

int wrapInc(int a, int maxVal) {
  if (a + 1 >= maxVal) {
    return 0;
  } 
  else {
    return a + 1;
  }
}

int wrapDec(int a, int maxVal) {
  if (a - 1 < 0) {
    return maxVal - 1;
  } 
  else {
    return a - 1;
  }
}

int getNeighbor(int[][] cells, int x, int y, int idx) {
  /*   
   0 3 5
   1 x 6
   2 4 7 
   */
  int neighborX;
  int neighborY;
  if (idx < 0 || idx > 7) {
    throw new RuntimeException("Neighbor index out of bounds");
  }

  if (idx < 3) {
    neighborX = wrapDec(x, arrayWidth);
  } 
  else if (idx >= 5) {
    neighborX = wrapInc(x, arrayWidth);
  } 
  else {
    neighborX = x;
  }

  if (idx == 0 || idx == 3 || idx == 5) {
    neighborY = wrapDec(y, arrayHeight);
  } 
  else if (idx == 2 || idx == 4 || idx == 7) {
    neighborY = wrapInc(y, arrayHeight);
  } 
  else {
    neighborY = y;
  }

  return cells[neighborX][neighborY];
}

int countNeighbors(int[][] cells, int x, int y) {
  int neighborCount = 0;
  for (int idx = 0; idx < 8; idx++) {
    if (getNeighbor(cells, x, y, idx) > 0) {
      neighborCount++;
    }
  }
  return neighborCount;
}

int tryBirth(int[][] cells, int x, int y) {
  if (countNeighbors(cells, x, y) == 3) {
    return 1;
  } 
  else {
    return 0;
  }
}

int tryAge(int[][] cells, int x, int y) {
  if (countNeighbors(cells, x, y) == 2 || countNeighbors(cells, x, y) == 3) {
    return cells[x][y] + 1;
  } 
  else {
    return 0;
  }
}

int[][] gen(int[][] cells) {
  int[][] nextGen = new int[arrayWidth][arrayHeight];

  for (int x = 0; x < arrayWidth; x++) {
    for (int y = 0; y < arrayHeight; y++) {
      if (cells[x][y] == 0) {
        nextGen[x][y] = tryBirth(cells, x, y);
      } 
      else {
        nextGen[x][y] = tryAge(cells, x, y);
      }
    }
  }
  return nextGen;
}

int frameIdx = 0;
int genIdx = 1;
void draw() {
  //background(0);
  //noStroke();
  render(cells);
  
  if(frameIdx++ >= genIdx) {
    cells = gen(cells);
    frameIdx = 0;
  }
}


boolean inBounds(int x, int y) {
  if (x < 0 || x >= arrayWidth || y < 0 || y >= arrayHeight)
    return false;
  return true;
}

void mousePressed() {
  int x = mouseX;
  int y = mouseY;
  if (inBounds(x/scaleX, y/scaleY))
    cells[x/scaleX][y/scaleY]++;
}

void mouseDragged() {
  int x = mouseX;
  int y = mouseY;
  if (inBounds(x/scaleX, y/scaleY))
    cells[x/scaleX][y/scaleY]++;
}

void stop()
{
  super.stop();
}
