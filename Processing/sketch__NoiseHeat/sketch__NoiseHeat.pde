// Noise Heat
// Found at: https://www.openprocessing.org/sketch/363109

// noise, vertex

// For whatever reason, this looks like crap on the LEDs
// ^^ yup just turn off opc.enableShowLocations

float incr1, incr2, incr3, h, a;

OPC opc;

void setup() {
  size(320, 200);
  
  opc = new OPC(this, "rhubarb.local", 7890);

  // opc.ledGrid(index, stripLength, numStrips, x, y, ledSpacing, stripSpacing, angle, zigzag, flip)
  opc.ledGrid(0, 64, 10, width/2, height/2, 3, 3, 0, false, false);
  opc.enableShowLocations = false;
  
  //background(#292929);
  background(#000000);
  colorMode(HSB, 298, 100, 100, 100);
  frameRate(30);
}

void draw() {
  //noStroke();
  fill(0,2);
  //rect(0, 0, width, height);
  incr2 = 300;
  incr3 = - 250;
  h = 0;
  a = 100;
  strokeWeight(random(.3,1));
  for (int i = 0; i < 7; i++) {
    beginShape();
    for (float x = 0; x <= width+200; x++) {
      stroke(h, 20, 300, a);
      vertex(x-200, (height+incr3)*noise(incr1, x/incr2));
    }
    endShape();
    incr1 +=.0004;
    incr2 -= 37;
    incr3 += 70;
    h += 5;
    a -= 7;
  }
}
