// Necrofire
// Found at: https://www.openprocessing.org/sketch/506797

void setup() {
  size(320, 200);
  //createCanvas(windowWidth, windowHeight);
  background(255);
  particles = [];
}

void draw() {
  background(30,10,20);
  noStroke();
  for(var i = 0; i < 6; i++) {
    //square = new particle(mouseX, mouseY);
    square = new particle(width/2+random(-250,250), height);
    particles.push(square);
  }
  for(var i = 0; i < particles.length; i++) {
    particles[i].update();
    particles[i].show();
  }
  if(particles.length > 10000) {
    particles.splice(0,10);
  }
}

function particle(x,y) {
  this.length = random(5,9);
  this.position = createVector(x,y);
  this.velocity = createVector(random(-2,2),0);
  this.acceleration = createVector(random(-0.01,0.01),-0.05);
  this.time = 0;
  
  this.update = function() {
    this.position.add(this.velocity);
    this.velocity.add(this.acceleration);
    this.edges();
    this.time ++;
  }
  this.colour = random(100);
  
  this.show = function() {
    fill(255,this.colour,230-this.time*2.3);
    rect(this.position.x, this.position.y, this.length, this.length);
    //ellipse(this.position.x, this.position.y, this.length);
  }
  
  this.edges = function() {
    var restitution = random(-0.3)
    if (this.position.y <= 0 + random(20)) {
      this.velocity.y = this.velocity.y*restitution
    }
  }
}
