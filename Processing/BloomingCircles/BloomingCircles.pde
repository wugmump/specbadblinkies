// BloomingCircles
// Found at: https://www.openprocessing.org/sketch/477110

var num;
var x;
var y;
var r;
var alive;
var state;
var t;

function setup()
{
  createCanvas(windowWidth * 0.7, windowHeight * 0.7);
  background(245,200,15);  
  blendMode(DARKEST);
  noStroke();
  
  randomSeed(99);
  
  num = 150;
  
  x = Array(num);
  y = Array(num);
  t = Array(num);
  r = Array(num);
  
  alive = Array(num);
  state = Array(num);
  
  for(var i = 0; i < num; i++) {
    alive[i] = false;
    t[i] = 0;
  }
}


function draw()
{
  var ok;
  var xp;
  var yp;
  var dy;
  var dx;
  var d;
  var i;
  var j;
  var p;
    
  clear();
  background(245,200,15);
  
  for(i = 0; i < num; i++) {
    t[i] += 1/30.0;
    r[i] += 1.5;
    p = sin(PI/2*t[i])*sin(PI/2*t[i]);
    if(alive[i]) {
      if(state[i] == 0) {
        ok = true;
        for(j = 0; j < num; j++) { 
          if(i != j && alive[j]) {      
            dx = x[i]-x[j];
            dy = y[i]-y[j];
            d = Math.sqrt(dx*dx+dy*dy);
            if(d < r[j] + r[i]) ok = false;
          } // if
        } // for
        if(!ok || t[i] > 1.0) { 
          state[i] = 1;
          t[i] = 0;
        }
        fill(195, 52, 52);
      } else if(state[i] == 1) {
        fill(245*p+195*(1-p), 200*p+52*(1-p), 15*p+52*(1-p));
        if(t[i] > 1.0) alive[i] = false;
      } // if
      ellipse(x[i],y[i],r[i]*2,r[i]*2);
    } else {
      xp = Math.random()*width;
      yp = Math.random()*height;
      ok = true;
      for(var j = 0; j < num; j++) {
        if(i != j) {
           var dx = xp-x[j];
           var dy = yp-y[j];
           var d = Math.sqrt(dx*dx+dy*dy);
           if(d < r[j] && alive[j]) ok = false;
        } // if
      } // for
      if(ok) {
        x[i] = xp;   y[i] = yp;
        r[i] = 0;    t[i] = 0.0;
        alive[i] = true;
        state[i] = 0;
      } // if
    } // if
  } // for
  
}
