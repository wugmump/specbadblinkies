// Apollonian Gasket II
// Found at: https://www.openprocessing.org/sketch/390233
// Runs in P5js, not processing

var circles;
var theta;
var side;

var circle_1,circle_2,circle_3,initial_decartes;

void setup() {
    side = windowWidth < windowHeight ? windowWidth:windowHeight;
    createCanvas(side,side); 
    background(0);

    t = 0.0;

    //We need three tangent circles to start off with.
    //radii 
    var r1 = side/2.2;
    var r2 = (2.0/3.0)*r1;
  
    //centers 
    z1 = new complex(side/2,side/2);
    var touchPoint = new complex(side/2-r1,side/2);
    z2 = touchPoint.add(new complex(r2,0));

    //curvatures
    var k1 = -1/r1;
    var k2 = 1/r2;

    //initial circles
    circle_1 = new Circle(z1.scale(k1),k1);
    circle_2 = new Circle(z2.scale(k2),k2);

    theta = 0.0;
    circle_3 = thirdCircle(circle_1,circle_2,theta);

  //we'll need these to test against latter so we can reset.
    initial_decartes = decartes(circle_1,circle_2,circle_3);


    frameRate(30);
} 
          
void draw() {
    //update
    theta += 0.01;
  
    //we need three touching circles to start off the algorythm.
    //Circles 1 and 2 are fixed, one inside the other. 
    //We roll the third one around in the space between them.
    circle_3 = thirdCircle(circle_1,circle_2,theta);

    if(circle_3.isEqual(initial_decartes[0] )|| circle_3.isEqual(initial_decartes[1])){
        //our third circle now is equal to one of the circles that was touching our third circle at theta = 0.0
        //That means we can jump back to the beginning seamlessly
        theta = 0.0;                
    }

    //we've set them up to be touching tangent to the other two
    circle_1.tangentCircles = [circle_2,circle_3];
    circle_2.tangentCircles = [circle_1,circle_3];
    circle_3.tangentCircles = [circle_2,circle_1];

    circles = [circle_1,circle_2,circle_3];

    
    n=0;
    while(circles.length<1000 && n<20){
        n++;
        var incompleteCircles = circles.filter((x) => x.tangentCircles.length>0  && x.tangentCircles.length<5);
        var completion = incompleteCircles.reduce( function(acc,obj) { return concat(acc,apollonian(obj));},[]);
        circles = concat(circles,completion);
    }
    println(circles.length + "," + n);
  
  
    //draw all the circles!
    background(255);
    circles.map((x) => x.draw());

    println(frameRate())
    //noLoop();
}

function thirdCircle(c1,c2,angle){
    //first guess at z3 and r3
    //As a first guess assume the center of c3 lies on the cirle that is the average of the first two
    //This is true at theta==0
    var r_a = 0.5*(c1.r + c2.r);
    var z_a = c1.center.add(c2.center).scale(0.5);


    var dz3 = new complex(r_a*cos(angle),r_a*sin(angle));

    var z3 = z_a.add(dz3);
    var r3 = 0.0;

    //iterativly improve our guess of r3,z3
    for(var i=0;i<200;i++){
      r3 = find_r3(z3,c1.center,c1.r);
      z3 = find_z3(c2.center,c2.r,r3,theta);
    }

    //curvature
    var k3 = 1/r3;

    return new Circle(z3.scale(k3),k3);
}

function find_z3(z2,r2,r3,theta){
    var n = new complex(cos(theta),sin(theta));
    return z2.add(n.scale(r2+r3));
}

function find_r3(z3,z1,r1){
    var dz = z3.minus(z1);
    return r1 - dz.modulus();
}

function apollonian(c){
    //Apply Decartes theorem iterativly to pack circles within a circle.
    //https://en.wikipedia.org/wiki/Apollonian_gasket
    if(c.tangentCircles.length<2)return [];
    if(c.tangentCircles.length==2) return decartes(c,c.tangentCircles[0],c.tangentCircles[1]);

    c1 = c.tangentCircles[0];
    c2 = c.tangentCircles[1];
    c3 = c.tangentCircles[2];

    //Each call to decartes returns a pair of circles. 
    //One we already have, so we filter it out. We'll also filter out circles that are too small.
    var r_min = 3.0;

    var c23 = decartes(c,c2,c3).filter((x)=> !c1.isEqual(x) && x.r > r_min);
    var c13 = decartes(c,c1,c3).filter((x)=> !c2.isEqual(x) && x.r > r_min);
    var c12 = decartes(c,c1,c2).filter((x)=> !c3.isEqual(x) && x.r > r_min);
    //return c23;
    return concat(c23,concat(c12,c13));
}


function decartes(c1,c2,c3){
    //Decartes Theorem: Given three tangent circles we can find a fourth and a fifth.
    //https://en.wikipedia.org/wiki/Descartes%27_theorem
    var k_plus = c1.k + c2.k + c3.k + 2*sqrt(c1.k*c2.k + c3.k*c2.k + c1.k*c3.k);
    var k_minus = c1.k + c2.k + c3.k - 2*sqrt(c1.k*c2.k + c3.k*c2.k + c1.k*c3.k);

    var c12 = c1.z.mult(c2.z);
    var c23 = c2.z.mult(c3.z); 
    var c31 = c3.z.mult(c1.z); 

    var t1 = c1.z.add(c2.z.add(c3.z));
    var t2 = c12.add(c23.add(c31));
    var t3 = t2.sqrt().scale(2.0);                

    var z_plus = t1.add(t3);
    var z_minus = t1.minus(t3);

    var c_plus = new Circle(z_plus,k_plus);
    var c_minus = new Circle(z_minus,k_minus);

    c_plus.tangentCircles = [c1,c2,c3];
    c_minus.tangentCircles = [c1,c2,c3];

    //These now have a full set so we don't care anymore
    c1.tangentCircles = [];
    c2.tangentCircles = [];
    c3.tangentCircles = [];

    return [c_plus,c_minus];
}

function Circle(z,k) {
    //k is the curvature.
    //z is the position expressed as a complex number and divided by the curvature.
    //This is a convienient quantity for decartes therom.
    this.k = k;
    this.r = 1/abs(k);
    this.z = z;


    this.center = z.scale(1.0 /k);

    this.description = function(){
        println( "Circle center: (" + this.center.x + "," + this.center.y + ")  radius:" + this.r + "curvature:" +this.k);
    }

    this.tangentCircles = []

    this.isEqual = function(c) {
        var tolerance = 2.0;

        var  equalR = abs(this.r - c.r) < tolerance;
        var  equalX = abs(this.center.x - c.center.x) < tolerance;
        var  equalY = abs(this.center.y - c.center.y) < tolerance;

        return equalR && equalX && equalY;
    }

    this.draw = function(){
        if(k>0){
            fill(255);
        }
        else{
            fill(0);
        }

        ellipse(this.center.x,this.center.y,2*this.r,2*this.r);
    }
  
}

function complex(x,y) {
    this.x = x;
    this.y = y;

    this.add = function(z){
          return new complex(this.x + z.x,this.y + z.y);
    }

    this.minus = function(z){
          return new complex(this.x - z.x,this.y - z.y);
    }

    this.mult = function(z){
          return new complex(this.x * z.x - this.y * z.y ,this.x * z.y + this.y * z.x);
    }

    this.scale = function(s){
          return new complex(this.x * s  ,this.y * s);
    }

    this.sq = function() {
          return this.mult(this);
    }

    this.sqrt = function() {
          var r = sqrt(this.modulus());
          var arg = this.arg()/2.0;
          return new complex(r*cos(arg),r*sin(arg));
    }

    this.modulus = function() {
          return sqrt(this.x * this.x + this.y * this.y);
    }

    this.arg = function() {
          return atan2(this.y,this.x);
    }
}
