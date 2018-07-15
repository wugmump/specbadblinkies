import processing.net.*;

/*
 * SunRingFunRing
 * Joshua Goldberg 2018
 * working with Caroline S Eastman and Glen Duncan
 
 */

OPC opc;

int x=255;
int slowrise = int(random(0,1000));
int lim=500;
int tempR, tempG, tempB, tempA;
int alpha = 50;

float a = 0;
float amount = 0;

float xCen, yCen;

void setup()
{
  size(500,500);
  background(0);
  fill(128,128,128,15);
  stroke(0,0);
  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);
  opc.showLocations(false);
  frameRate(30);
  opc.setColorCorrection(3,1,.9,1);

  //define the rings.
  makeRings();
  
}

void draw(){
  
  amount = amount+0.001;
  if (amount>.5) { amount = 0; }
  
  float xN = width/2+cos(a)* 250;
  float yN = height/2+sin(a) * 250;
  a = a+amount;
  if (a> TWO_PI) {a=0;}
  
  //i barely understand how this works below
  
  //xCen=mouseX;
  //yCen=mouseY;
  x+=1;
  slowrise++;
      tempR = slowrise/4;
    tempG = int((cos(float(slowrise/1000))+0)*128.);
    tempB = int(sin(lim)*255);
    tempA = int(amount*512);
  fill(tempR,tempG, tempB, tempA);
  ellipse(xN,yN,x,x);
  if (x>lim+25){
    x=0;
    lim=lim-5;

    stroke(0,0);
    if(slowrise>1000){slowrise=15;}
    if(lim<15){lim=500;}
  }

  
  
  fill(0,0,0,alpha);
  rect(0,0,width,height);
  
    if(random(0,slowrise)<40){
    // draw a sparkle
    fill(255,255,255,255);
    rect(int(random(0,width)), int(random(0,height)), 25,25);
  }
  
}
