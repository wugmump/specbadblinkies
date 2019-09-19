// Falling Bubbles
// Found at: https://www.openprocessing.org/sketch/524697

import java.util.*;

ArrayList<bubble> bubbles;

void setup() {
  size(600, 600);
  bubbles = new ArrayList<bubble>();
  loadbubble();
}

void draw() {
 
  background(25, 151, 200);
  if ((frameCount % 3) == 0) {
    addbubble();
  }
  

  drawbubble();
  for(int i = 0; i < bubbles.size(); i++){
    bubble s = bubbles.get(i);
    if(s.death){
      bubbles.remove(s);
    } 
  }
}

void loadbubble() {
  for (int i = 0; i < 1; i++) {
    bubbles.add(new bubble());
  }
}

void drawbubble() {
  for (bubble s: bubbles) {
    s.display();
  }
}

void addbubble() {
  bubbles.add(new bubble());
}

class bubble {
  PVector location;
  PVector acceleration;
  PVector velocity;
  PVector wind;
  PVector gravity;

  float bubbleHeight, bubbleWidth;
  float mass;

  boolean death = false;

  bubble() {
    bubbleHeight = random(5, 20);
    bubbleWidth  = bubbleHeight;

    location = new PVector(random(width), -bubbleHeight);
    velocity   = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    wind = new PVector(random(-0.004, 0.004), 0);

    mass = 100/bubbleWidth;
    gravity = new PVector(0, 0.05);
  }

  void display() {
    drawbubble();
    movebubble();
    applyForce(gravity);
    applyForce(wind);
  }

  void drawbubble() {
    noStroke();
    fill(255, 200);
    ellipse(location.x, location.y, bubbleWidth, bubbleHeight);
  
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void movebubble() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  
    if (location.y > height+bubbleHeight) {
      death = true;
    }
  }
}
