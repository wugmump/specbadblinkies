// FeralInk
// Found at: https://www.openprocessing.org/sketch/395420

// noise, cos, sin, random, line, ellipse, Array, generative
// Mouse click to re-draw, left for black background, right for white.

NoiseTrail[] trail = new NoiseTrail[500];
float rad, mult, h, s, b;
int count ;
boolean isBlack;

void setup() {
  size(1000, 650);
  colorMode(HSB, 360, 100, 100, 100);
  strokeWeight(.5);
  noiseDetail(3, .4);
  isBlack = true;
  setTrails();
  h = 330;
}

void draw() {
  count++;
  if (count > 600) noLoop();
  for (int i = 0; i < trail.length; i++) {
    trail[i].drawTrail();
  }
}


class NoiseTrail {
  float x, y, x2, y2, noiseFactor;
  float a = random(TWO_PI);
  float r = random(20, 180);

  NoiseTrail() {
    x = width/2+cos(a) * r * 1.3;
    y = height/2+sin(a) * r;
  }

  void drawTrail() {
    x2 = x;
    y2 = y;
    noiseFactor = map(noise(x * .025, y * .025, 
    frameCount * .005), 0, 1, -mult, mult);
    x += cos(noiseFactor) * rad;
    y += sin(noiseFactor) * rad;

    s += .009;
    h += .00009;
    b = 100 - (abs(sin(frameCount* .009))*50);
    if (s > 100) s = 100;
    if (h > 360) h = 0;

    stroke(h, s, b);
    line(x2, y2, x, y);

    if (count < 5) {
      noStroke();
      fill(h, 100, 100, 3);
      ellipse(x, y, 20, 20);
    }
  }
}

void setTrails() {
  if (isBlack) background(0);
  else background(360);
  count = 0;
  mult = 80;
  rad = 2;
  s = 0;
  h = random(360);
  b =   100;
  for (int i = 0; i < trail.length; i++) {
    trail[i] = new NoiseTrail();
  }
  loop();
}

void mousePressed() {
  if (mouseButton == LEFT) isBlack = true;
  if (mouseButton == RIGHT) isBlack = false;
  setTrails();
}
