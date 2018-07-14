/*
 * SunRingFunRing
 * Joshua Goldberg 2018
 * working with Caroline S Eastman and Glen Duncan
 
 */

OPC opc;

int x=0;
int slowrise = 0;
int lim=255;
int tempR, tempG, tempB, tempA;

float xCen, yCen;

void setup()
{
  size(512, 512);
  background(0);
  fill(128,128,128,15);
  stroke(0,0);
  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);
  opc.showLocations(false);
  frameRate(60);


  //define the rings.
  makeRings();
  
}

void draw(){
  
  xCen=mouseX;
  yCen=mouseY;
  x+=1;
  slowrise++;
  fill(tempR,tempG, tempB, tempA);
  ellipse(mouseX,mouseY,x,x);
  if (x>lim){
    x=0;
    lim=lim-5;
    tempR = slowrise/4;
    tempG = lim;
    tempB = int(sin(lim)*255);
    tempA = 25;
    stroke(0,0);
    if(slowrise>1000){slowrise=15;}
    if(lim<15){lim=255;}
  }
  fill(0,0,0,5);
  rect(0,0,width,height);
  
}
