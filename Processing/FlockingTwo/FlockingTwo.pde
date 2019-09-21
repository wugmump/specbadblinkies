// Dan Shiffman "The Nature of Code" Ch. 6 
// https://www.youtube.com/watch?v=IoKfQrlQ7rA
// https://gamedevelopment.tutsplus.com/tutorials/understanding-steering-behaviors-collision-avoidance--gamedev-7777
// http://paulbourke.net/geometry/pointlineplane/

// Mouse click to reset and toggle between 2 modes.
// boid, ArrayList, PVector, color, rect, text, cos, sin, random, map, vertex, ellipse
// Basic obstacle avoidance: All boids are same species.
// Only boids close to the obstacle are checked. A broad check first (where a collision may be possible)
// and then a precise line-point intersection check.

// Works on Processing


ArrayList<Boid> allBoids;
int numBoids = 170;
PVector obstaclePos;
float obstacleRad = 30;
boolean seeAll;

OPC opc;

void setup() {
  size(320, 200);
  
  opc = new OPC(this, "rhubarb.local", 7890);

  opc.ledGrid(0, 16, 10, width/2, height/2, 20, 20, 0, false, false);
  opc.enableShowLocations = false;
  
  ellipseMode(RADIUS);
  background(#000000);
  seeAll = false;
  makeBoids();
  obstaclePos = new PVector(width/2, height/2);
}

void draw() {
  if (seeAll) {
    background(#000000);
    noFill();
    stroke(130);
    strokeWeight(.5);
    ellipse(width/2, height/2, 70, 70);
    ellipse(width/2, height/2, 130, 130);
  } else {
    fill(0, 20);
    noStroke();
    rect(0, 0, width, height);
  }
  stroke(130);
  ellipse(width/2, height/2, obstacleRad, obstacleRad);
  fill(150);
  textSize(15);
  text("FPS:", 50, height-50);
  text(floor(frameRate), 90, height-50);
  for (Boid b : allBoids) {
    b.run();
  }
}

// functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

void makeBoids() {
  allBoids = new ArrayList<Boid>();
  for (int i = 0; i < numBoids; i++) {
    float angle = random(TWO_PI);
    float x = width/2 + cos(angle) * 200;
    float y = height/2 + sin(angle) * 200;
    allBoids.add(new Boid(x, y));
  }
}

void mousePressed() {
  seeAll = !seeAll;
  if (numBoids == 170) numBoids = 80;
  else numBoids = 170;
  makeBoids();
}

// class %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

class Boid {
  PVector pos, vel, accel, aheadLead, aheadTail;
  float r = 5, maxforce, maxspeed, theta, d = 50, aheadLen = 60;
  // broadChkDst == the max. dist (between boid pos and obstacle pos) at which the probe (line) can detect a possible collision
  float  broadChkDst = obstacleRad + aheadLen + (4*r); 
  float collDst = obstacleRad  + (4*r); // less than this and we have a collision
  color col = 255;


  Boid(float x, float y) {
    accel = new PVector(0, 0);
    vel = new PVector(random(-1, 1), random(-1, 1));
    pos = new PVector(x, y);
    aheadLead = new PVector(0, 0);
    aheadTail = new PVector(0, 0);
    maxspeed = 3;
    maxforce = 0.03;
  }

  void run() {
    flock();
    update();
    boundaries();
    // borders();
    collision();
    render();
  }

  void update() {
    vel.add(accel);
    vel.limit(maxspeed);
    pos.add(vel);
    accel.mult(0);
  }


  void flock() {
    PVector sep = separate();   
    PVector ali = align();     
    PVector coh = cohesion();   

    accel.add(sep);
    accel.add(ali);
    accel.add(coh);
  }

  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  void collision() {
    float d = PVector.dist(obstaclePos, pos);
    if (d < broadChkDst) { // collision is possible, but not certain, so check.
      // probe: a line in front of the boid from aheadTail (set at pos) to aheadLead
      aheadTail.set(pos);
      aheadLead.set(vel);
      aheadLead.normalize();
      aheadLead.mult(aheadLen);
      aheadLead.add(aheadTail);
      // dst == shortest distance from probe (a line) to obstacle (center) location
      float dst = distanceToSegment(aheadTail, aheadLead, obstaclePos);
      if (dst < collDst) { // obstacle circumference and boid probe area (2 X r around the line) overlap 
        PVector desired = PVector.sub(aheadLead, obstaclePos); // points away
        desired.normalize();
        desired.mult(maxspeed);
        desired.sub(vel);
        float setFrce = map(dst, obstacleRad, collDst, maxforce, 0);
        desired.limit(setFrce);
        accel.add(desired);
      }
    }
  }

  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // calc. dist. between obstacle pos and boid probe (a line segment from aheadTail to aheadLead).
  float distanceToSegment(PVector p1, PVector p2, PVector p3) {
    float xDelta = p2.x - p1.x;
    float yDelta = p2.y - p1.y;
    float u = ((p3.x - p1.x) * xDelta + (p3.y - p1.y) * yDelta) / (xDelta * xDelta + yDelta * yDelta);
    PVector point;
    if (u < 0) {
      point = p1;
    } else if (u > 1) {
      point = p2;
    } else {
      point = new PVector(p1.x + u * xDelta, p1.y + u * yDelta);
    }
    return PVector.dist(point, p3);
  }

  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Cohesion: Steer towards flockmates that have moved too far away. 
  // Collect the average pos of all nearby boids of same species. This becomes "desired".
  // Steer towards desired.

  PVector cohesion () {
    float neighbordist = 60;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all pos's
    int count = 0;
    for (Boid other : allBoids) {
      float d = PVector.dist(pos, other.pos);
      if ((d > 0) && (d < neighbordist)) { 
        sum.add(other.pos); // Add pos
        count++;
      }
    }
    if (count > 0) {
      sum.div(count); // average  
      sum.sub(pos); //  vec pointing from current pos to "desired" pos
      sum.normalize();
      sum.mult(maxspeed);
      // Steering = Desired - vel
      sum.sub(vel);
      float setMax = map(sum.mag(), 0, 5, 0, maxforce);
      sum.limit(setMax);  
      return sum;
    } else {
      return new PVector(0, 0);
    }
  }


  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Separate: Steer away from flockmates, of all species, that are too close.
  // Calc vector pointing away from each nearby flockmate.
  // The  average of these vectors becomes "desired".

  PVector separate () {
    float sepDist = 30;// r*6;
    PVector sum = new PVector(0, 0); // ends up as "desired"
    int count = 0;
    float dAv = 0, dTotal = 0;
    for (Boid other : allBoids) {
      float d = PVector.dist(pos, other.pos);
      // d>0 stops self-checking but allows some boids to piggy-back from time to time
      if ((d > 0) && (d < sepDist)) { 
        dTotal += d;
        PVector diff = PVector.sub(pos, other.pos); // points away
        diff.normalize();
        sum.add(diff);
        count++;
      }
    }
    // Average == divide by how many
    if (count > 0) {
      sum.div((float)count);
      dAv = dTotal/float(count);
    }
    if (sum.mag() > 0) {
      // force has inverse relatioship to average distance
      // if flockmates are closer, use more force, further away, use less
      float setMaxForce = map(dAv, 0, sepDist, .1, 0);
      //  Steering = Desired - vel
      sum.normalize();
      sum.mult(maxspeed);
      sum.sub(vel); // sum is "desired"
      sum.limit(setMaxForce);
      //sum.setMag(setMaxForce);//not js mode
    }
    return sum;
  }


  //  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // Align: Steer towards average heading (not pos) of nearby flockmates of same species.
  // Collect heading vector for each nearby flockmate.
  // the average of these vecs becomes "desired".
  PVector align () {
    float neighbordist = 60;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : allBoids) {
      float d = PVector.dist(pos, other.pos);
      if ((d > 0) && (d < neighbordist)) { 
        sum.add(other.vel);// total of headings of each local flockmate
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count); // average
      //  Steering = Desired - vel
      sum.normalize();
      sum.mult(maxspeed);
      sum.sub(vel);
      float setMax = map(sum.mag(), 0, 5, 0, .03);
      sum.limit(setMax);
      return sum;
    } else return new PVector(0, 0);
  }

  // Wraparound
  void borders() {
    if (pos.x < -r) pos.x = width+r;
    if (pos.y < -r) pos.y = height+r;
    if (pos.x > width+r) pos.x = -r;
    if (pos.y > height+r) pos.y = -r;
  }


  void boundaries() {
    PVector desired = null;

    if (pos.x < d) {
      desired = new PVector(maxspeed, vel.y);
    } else if (pos.x > width -d) {
      desired = new PVector(-maxspeed, vel.y);
    } 

    if (pos.y < d) {
      desired = new PVector(vel.x, maxspeed);
    } else if (pos.y > height-d) {
      desired = new PVector(vel.x, -maxspeed);
    } 

    if (desired != null) {
      desired.normalize();
      desired.mult(maxspeed);
      desired.sub(vel);
      desired.limit(.02);
      accel.add(desired);
    }
  } 

  void render() {

    theta = vel.heading2D() + PI/2;

    pushMatrix();
    translate(pos.x, pos.y);
    rotate(theta);
    if (seeAll) {
      stroke(#0AFCEE, 50);
      strokeWeight(r*4);
      line(0, 0, 0, -60);
      strokeWeight(1);
      stroke(255);
      line(0, 0, 0, -60);
      noFill();
      ellipse(0, 0, r*2, r*2);
    }
    noStroke();
    fill(col);
    beginShape();
    vertex(0, -r*2);
    vertex(-r*1.5, r*1.25);
    vertex(0, 0);
    vertex(r*1.5, r*1.25);
    endShape(CLOSE);
    popMatrix();
  }
}
