// Ran on MBP. Missing video library and videos.

import processing.video.*;

//String filename = "/Users/gduncan/Movies/My Movie 9 - Medium.mov";
//String filename = "/Users/gduncan/Pictures/Camping2017-1/YDTL0052.MP4";
String filename = "/Users/gduncan/Pictures/Camping2017-1/YDTL0050.MP4";
//String filename = "/Users/gduncan/Movies/Campfire480p.mp4";
//String filename = "/Users/gduncan/Movies/Sunset.mp4";


float zoom = 2;

OPC opc;
Movie movie;
PGraphics[] pyramid;

void setup()
{
  size(160, 100, P3D);

  // Connect to the local instance of fcserver. You can change this line to connect to another computer's fcserver
  opc = new OPC(this, "rhubarb.local", 7890);

  opc.ledGrid(0, 16, 10, width/2, height/2, 10, 10, 0, false, false);
  movie = new Movie(this, filename);
  movie.loop();

  pyramid = new PGraphics[4];
  for (int i = 0; i < pyramid.length; i++) {
    pyramid[i] = createGraphics(width / (1 << i), height / (1 << i), P3D);
  }
}

void keyPressed() {
  if (key == 'd') opc.setDithering(false);
  if (key == ' ') movie.pause();
  if (key == ']') zoom *= 1.1;
  if (key == '[') zoom *= 0.9;
}

void keyReleased() {
  if (key == 'd') opc.setDithering(true);
  if (key == ' ') movie.play();
}  

void movieEvent(Movie m)
{
  m.read();
}

void draw()
{
  // Scale to width, center height
  int mWidth = int(pyramid[0].width * zoom);
  int mHeight = mWidth * movie.height / movie.width;

  // Center location
  float x, y;

  if (mousePressed) {
    // Pan horizontally and vertically with the mouse
    x = -mouseX * (mWidth - pyramid[0].width) / width;
    y = -mouseY * (mHeight - pyramid[0].height) / height;
  } else {
    // Centered
    x = -(mWidth - pyramid[0].width) / 2;
    y = -(mHeight - pyramid[0].height) / 2;
  }

  pyramid[0].beginDraw();
  pyramid[0].background(0);
  pyramid[0].image(movie, x, y, mWidth, mHeight);
  pyramid[0].endDraw();

  for (int i = 1; i < pyramid.length; i++) {
    pyramid[i].beginDraw();
    pyramid[i].image(pyramid[i-1], 0, 0, pyramid[i].width, pyramid[i].height);
    pyramid[i].endDraw();
  }

  image(pyramid[pyramid.length - 1], 0, 0, width, height);
}
