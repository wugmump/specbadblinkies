// Swarm Art 6
// Found at: https://www.openprocessing.org/sketch/494768

//import processing.pdf.*; //import PDF creating library 

float e = 150; //creating a smaller square

Swarm swarm;

void setup() {
  size(600, 600);

  swarm = new Swarm();
  // Adding bots into the system - 4 groups of swarms of 75 in various places
  for (int i = 0; i < 75; i++) {
    swarm.addBot(new Bot(0,600));
    swarm.addBot(new Bot(600,0));
    swarm.addBot(new Bot(0,0));
    swarm.addBot(new Bot(600,600));
   
    
    
    
  
    
  }
  
  //  beginRecord(PDF,"swarmart1a.pdf"); //start recording the PDF into filename swarm art 1

}

void draw() {
  //background(60,50,50);
  stroke(200);
  noStroke();
  rectMode (CENTER); 
  fill (255,255,255,2);
  rect (0,0,1200,1200);
 // rect (width/2, height/2, width-e*2, height-e*2);
  swarm.run();
}




// The Swarm class is compiled of bot objects

class Swarm {
  ArrayList<Bot> bots; // Creating An ArrayList for all the bots

  Swarm() {
    bots = new ArrayList<Bot>(); // Initializing ArrayList
  }

  void run() {
    for (Bot b : bots) {
      b.run(bots);  // Passing the entire list of bots to each boid individually
    }
  }

  void addBot(Bot b) { //function to add bots into swarm
    bots.add(b);
  }
}




// The Bot class within the Swarm class -  ArrayList<Bot> bots
// create class adding floats/PVectors 
// Introduce PVectors that will be used to construct Alignment, Cohesion and Separation Vectors

class Bot { 

  PVector position;
  PVector x; 
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum force exerted when steering (shorter or longer routes)
  float maxspeed;    // Maximum speed bot can travel 

  Bot(float x, float y) {              // construct the bot 
    acceleration = new PVector(0, 0);  // introduce acceleration as empty PVector
    float angle = random(TWO_PI);      // creating a random angle to create 'wandering' bot
    velocity = new PVector(cos(angle),sin(angle));  // apply random angle to velocity
    position = new PVector(x, y);      // create position.x / position.y PVectors 
    r = r + random(10);                             // this will be used to control the size of the bot
    
    maxspeed = 100;                    // will be used to limit velocity once it sees target
    maxforce = 2.5;                    // how much swerve towards the target - how direct
    
  }

  void run(ArrayList<Bot> bots) { //listing functions to run within boid class
    swarm(bots); //applying separate/cohesion/alignment forces
    update(); //updating movements of bots
    checkedges(); //to make them stay in the box - but you want them to steer away from boid
    render(); //the look of the bots
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  // acceleration changes each time based on three rules
  void swarm(ArrayList<Bot> bots) {
    PVector sep = separate(bots);   // Separation - avoid coliding with neighbours
    PVector ali = align(bots);      // Alignment - steer same direction as neighbours
    PVector coh = cohesion(bots); // Cohesion - steer towards the centre of neighbours


    // Weight each of the forces made above with multiply
    sep.mult(10); //how far apart
    ali.mult(2.0); // direction
    coh.mult(0.5); //steering towards neighbour centre
    
    // Apply all of the forces created above 
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // updating the position of bot
  void update() {
    velocity.add(acceleration); // Update the velocity - adding accelleration
    velocity.limit(maxspeed); // adding maxspeed to velocity - the fastest it will go once it sees target
    position.add(velocity); //adding velocity to positon - make bots move
    acceleration.mult(0); // Change acceleration to 0 after it's met it's target
   
  }

  // Using seek/target methods this calculates and 
  // applies a steering force towards a target 
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // subtracting target from postion creates 
    //A vector pointing from the position to the target
    desired.normalize(); //once this is calculated we normalise - vector = 1
    desired.mult(maxspeed); //and apply maximum speed to reach target

    // implement the formula for Steering = Desired velocity minus Velocity 
    PVector steer = PVector.sub(desired, velocity); //sub is subtract
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer; // return the PVector 
    
  }

  void render() {
    // Draw a triangle (one bot) rotated in the direction of its velocity
    float theta = velocity.heading();
    float cellred,cellgreen, cellblue;
    float alpha;
    
    
    cellred = 255 ;
    cellblue = 255;
    cellgreen = 255;
  
    alpha = random(255); //creating changing transparency
    
    // adding in bezier curves instead of triangles for bots 
    // creating sketch like wave mappings of bots movement 
   
    fill(cellred,cellgreen,cellblue,alpha);
    stroke(cellred, cellgreen, cellblue,alpha);
    strokeWeight(0.1);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    ellipse(0, 0,r,r);
    noFill();
    stroke (32,98,164);
    bezier (25,250,80,40,125,250,140,250); // this line creates a curve 
    bezier (140,250,160,300,180,310, 200,250);
    stroke (235,171,0);
   bezier (200,250, 250,100, 280, 140, 310,250);
   bezier (310,250, 370,500, 430,40, 475,250); 
    popMatrix();
    
    
    
    
    
  }



  void checkedges () { // stopping bots from leaving canvas
    
     PVector desired = null;

    if (position.x < e) {
      desired = new PVector(maxspeed, velocity.y);
    } 
    else if (position.x > width -e) {
      desired = new PVector(-maxspeed, velocity.y);
    } 

    if (position.y < e) {
      desired = new PVector(velocity.x, maxspeed);
    } 
    else if (position.y > height-e) {
      desired = new PVector(velocity.x, -maxspeed);
    } 

    if (desired != null) {
      desired.normalize();
      desired.mult(maxspeed);
      PVector steer = PVector.sub(desired, velocity);
      steer.limit(maxforce);
      applyForce(steer);
    }
                                
  }







// Separation
// Method checks for nearby bots and steers away
PVector separate (ArrayList <Bot> bots) {
  float desiredseparation = 10.0; // the bots will know any further than this is too close
  PVector steer = new PVector(0, 0, 0);
  int count = 0;

  ///// For every boid in the system, check if it's too close
  for (Bot other : bots) {
    float d = PVector.dist(position, other.position);
    //bot assesses how close the other bots are above 
    //and then will point away 
    // If the distance is greater than 0 and less than the desired separation the bot will point away 
    // by using zero it makes sure the bot doesn't separate from itself
    if ((d > 0) && (d < desiredseparation)) {
      // Calculate vector pointing away from neighbor
      PVector diff = PVector.sub(position, other.position);
      diff.normalize();   // normalize keeps the vector direction but changes length to 1
      diff.div(d);        // Weight by distance
      steer.add(diff);     // adding all the vectors of nearby bots together
      count++;            // Keep track of how many bots are around in order to calculate the average
    }
  }
  // by saying "if" more than zero - it makes sure that it doesn't change anything if nothing 
  // is too close
  if (count > 0) {
    steer.div((float)count); //divide by the velocity of the other bots
  }

  // so if the average is greater than 0 then it can go ahead and move in the desired direction
  // at maximum speed 
  if (steer.mag() > 50) {
    // Reynolds formula for steering: Steering = Desired - Velocity
    steer.setMag(maxspeed);
    steer.sub(velocity); 
    steer.limit(maxforce);
  }
  return steer;
}

// Alignment
//  calculate average velocity of nearby bots in system
PVector align (ArrayList<Bot> bots) {
  float neighbordist = 0.5; 
  PVector sum = new PVector(0, 0);
  int count = 0;
  for (Bot other : bots) {
    float d = PVector.dist(position, other.position);
    if ((d > 0) && (d < neighbordist)) {
      sum.add(other.velocity);
      count++;
    }
  }
  if (count > 40) {
    sum.div((float)count);
    sum.normalize();
    sum.mult(maxspeed);
    PVector steer = PVector.sub(sum, velocity);
    steer.limit(maxforce);
    return steer;
  } else {
    return new PVector(0, 0); 
  }
}

// Cohesion
// calculates the steering direction by counting the average position of all nearby bots (the centre of bots)
PVector cohesion (ArrayList<Bot> bots) {
  float neighbordist = 50;
  PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
  int count = 0;
  for (Bot other : bots) {
    float d = PVector.dist(position, other.position);
    if ((d > 0) && (d < neighbordist)) {
      sum.add(other.position); // Adding up all the positions of other bots
      count++;
    }
  }
  if (count > 0) {
    sum.div(count);
    return seek(sum);  // Steer towards the position
  } else {
    return new PVector(0, 0);
  }
}
}

void keyPressed() { //if r is pressed a new PDF of a snapshot of what is one the screen is created
  if (key=='r') {
    endRecord();
  }
}
