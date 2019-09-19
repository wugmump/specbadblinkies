// Wheat Wind
// Found at: https://www.openprocessing.org/sketch/486673

/*
author:  lisper <leyapin@gmail.com> 2015
desc:    noise 2d line
This work is licensed under a Creative Commons Attribution-ShareAlike 3.0 Unported License.
*/

float nx = 0;
float ny = 0;
float nz = 0;

void setup () {
  size (600, 600);
  colorMode (HSB);
}


void draw () {
  background (255);
  stroke(0,0,0,25); 
  drawStream ();
}

void drawStream () {
  nx = 0;
  for (int i=0; i<width; i += 5) {
    ny = 0;
    for (int j=0; j<width; j += 5) {
      float angle = map (noise (nx, ny, nz), 0, 1.0, 0, 4*PI);
      float x = 50 * cos (angle);
      float y = 50 * sin (angle);
      line (i, j, i+x, j+y);
      ny += 0.03;
    }
    nx += 0.02;
  }
  nz +=0.01;
}
