// Apollonian Gasket III
// Found at: https://www.openprocessing.org/sketch/390420

var circles;
var theta;
var side;

var k1,k2,k3,c1,c2,c3,r1,r2,r3,z1,z2,z3;
var r12,z12;
function setup() {
  side = windowWidth < windowHeight ? windowWidth:windowHeight;
  createCanvas(side,side); 
  background(0);
  theta = 0.0;
 t = 0.0;
  //We need three tangent circles to start off with.
    //radii 
   r1 = 300;
  r2 = 200;
  //centers 
  z1 = new complex(side/2,side/2);
  var touchPoint = new complex(side/2-r1,side/2);
  z2 = touchPoint.add(new complex(r2,0));
  
  r12 = 0.5*(r1+r2);
  z12  = touchPoint.add(new complex(r12,0));
  
   
  //var z3 = new complex(side/2+200,side/2);
   //theta = 1.54;            
  
  
   
  
   //curvatures
  k1 = -1/r1;
  k2 = 1/r2;
  
  //initial circles
  c1 = new Circle(z1.scale(k1),k1);
  c2 = new Circle(z2.scale(k2),k2);
 
  frameRate(30)
} 
          
function draw() {
  background(0);
  t += 0.01;
  theta = (PI/3)*sin( t );

  //first guess at z3 and r3
  var dz3 = new complex(r12*cos(theta),r12*sin(theta));
  z3 = z12.add(dz3);
  r3 = r1 - z1.minus(z3).modulus();

  //iterativly improve our guess of r3,z3
  for(var i=0;i<200;i++){
    z3 = find_z3(z2,r2,r3,theta);
    r3 = find_r3(z3,z1,r1);
  }

  //third circle
  var k3 = 1/r3;
  c1 = new Circle(z1.scale(k1),k1);
  c2 = new Circle(z2.scale(k2),k2);
  var c3 = new Circle(z3.scale(k3),k3);


  //we've set them up to be touching tangent to the other two
  c1.tangentCircles = [c2,c3];
  c2.tangentCircles = [c1,c3];
  c3.tangentCircles = [c2,c1];

  circles = [c1,c2,c3];

  //update
  n=0
  while(circles.length<1000 && n<8){
    n++;
    var incompleteCircles = circles.filter((x) => x.tangentCircles.length>0  && x.tangentCircles.length<5);
    var completion = incompleteCircles.reduce( function(acc,obj) { return concat(acc,apollonian(obj));},[]);
    circles = concat(circles,completion);
  }


  //draw all the circles!
  circles.map((x) => x.draw());

  println(frameRate())
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
  var c23 = decartes(c,c2,c3).filter((x)=> !c1.isEqual(x) && x.r > r_min)
  var c13 = decartes(c,c1,c3).filter((x)=> !c2.isEqual(x) && x.r > r_min);
  var c12 = decartes(c,c1,c2).filter((x)=> !c3.isEqual(x) && x.r > r_min);

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
  c1.tangentCircles = concat(c1.tangentCircles,[c_plus,c_minus] )  ;
  c2.tangentCircles = concat(c2.tangentCircles,[c_plus,c_minus]);
  c3.tangentCircles = concat(c3.tangentCircles,[c_plus,c_minus]);
  
  return [c_plus,c_minus];
}

function Circle(z,k) {
  //k is the curvature.
  //z is the position expressed as a complex number and divided by the curvature.
  //This is a convienient quantity for decartes therom.
  this.k = k;
  this.r = 1/abs(k);
  this.z = z;
  this.x = z.x/k;
  this.y = z.y/k;
  
  this.tangentCircles = []
  
  this.isEqual = function(c) {
    var tolerance = 1.0;
    
    var  equalR = abs(this.r - c.r) < tolerance;
    var  equalX = abs(this.x - c.x) < tolerance;
    var  equalY = abs(this.y - c.y) < tolerance;
    
    return equalR && equalX && equalY;
  }
  
  this.draw = function(){
    /*
    if(k>0){
      fill(255);
    }
    else{
      fill(0);
    }
    */
    noFill();
    stroke(255,50);
    ellipse(this.x,this.y,2*this.r,2*this.r);
    stroke(255,10);
    this.tangentCircles.map((c) => line(this.x,this.y,c.x,c.y));
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
