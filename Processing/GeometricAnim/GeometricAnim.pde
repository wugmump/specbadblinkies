// Geometric Animations
// Found at: https://www.openprocessing.org/sketch/405926

float t;
float theta;
int maxFrameCount = 200; // frameCount, change for faster or slower animation

OPC opc;

void setup() {
  size(540, 540);
  
  opc = new OPC(this, "rhubarb.local", 7890);

  opc.ledGrid(0, 16, 10, width/2, height/2, 30, 30, 0, false, false);
  opc.enableShowLocations = false;
  
  noStroke();
}

void draw() {
  //background(#242949);
  background(#000000);
  translate(width/2, height/2); // translate 0,0 to center

  t = (float)frameCount/maxFrameCount;
  theta = TWO_PI*t;

  for ( int x= -175; x <= 175; x += 25) {
    for (int y= -100; y <= 155; y += 50) {
      float offSet = 50*x+y+y;   // play with offSet to change map below

      float x2 = map(cos(-theta+offSet), 0, 1, 0, 25); // map x position
      float y2 = map(cos(-theta+offSet), 0, 1, 25, 0); // map y position
      float sz2 = map(sin(-theta+offSet), 0, 1, 15, 45); // map size off the ellipse
      fill(250-(x/2), 150+(x/6), 250-(y/2)); // color with gradient created

      ellipse(x+x2, y-y2, sz2, sz2);
    }
  }
}
