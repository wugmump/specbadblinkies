// Pixel-sized particles version, of 'surfs_up'.
// Particles are now directly noise driven omitting the flow field.
// Array[], particle, pixel, noise()
// Mouse click to reset, mouseX adjusts background clear.

// Found at: https://www.openprocessing.org/sketch/298646
// Runs under Processing, but crashes hard when OPC is enabled with error:
// ArrayIndexOutOfBoundsException: -10944
// Runs under Processingjs

Particle[] particles;
int particleCount;
float alpha;

//OPC opc;

void setup() {
  size(320, 200);
  
  //opc = new OPC(this, "rhubarb.local", 7890);

  //opc.ledGrid(0, 16, 10, width/2, height/2, 30, 30, 0, false, false);
  //opc.enableShowLocations = true;
  
  background(0);
  noStroke();
  particleCount = 600;
  setParticles();
}

void draw() {
  frameRate(20);
  alpha = map(mouseX, 0, width, 5, 35);
  fill(0, alpha);
  rect(0, 0, width, height);

  loadPixels();
  for (Particle p : particles) {
    p.move();
  }
  updatePixels();
}

void setParticles() {
  particles = new Particle[particleCount];
  for (int i = 0; i < particleCount; i++) { 
    float x = random(width);
    float y = random(height);
    float adj = map(y, 0, height, 255, 0);
    int c = color(40, adj, 255);
    particles[i]= new Particle(x, y, c);
  }
}

void mousePressed() {
  setParticles();
}

class Particle {
  float posX, posY, incr, theta;
  color  c;

  Particle(float xIn, float yIn, color cIn) {
    posX = xIn;
    posY = yIn;
    c = cIn;
  }

  public void move() {
    update();
    wrap();
    display();
  }

  void update() {
    incr +=  .008;
    theta = noise(posX * .006, posY * .004, incr) * TWO_PI;
    posX += 2 * cos(theta);
    posY += 2 * sin(theta);
  }

  void display() {
    if (posX > 0 && posX < width && posY > 0  && posY < height) {
      pixels[(int)posX + (int)posY * width] =  c;
    }
  }

  void wrap() {
    if (posX < 0) posX = width;
    if (posX > width ) posX =  0;
    if (posY < 0 ) posY = height;
    if (posY > height) posY =  0;
  }
}
