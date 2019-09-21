// Found at: https://www.openprocessing.org/sketch/435687
// Runs under P5js

function Particle(x,y,amp) {
  this.speed   = random(0.1,1.5);
  this.name    =  "astroid";
  this.color   = color(255,random(21,133),5,random(2,200));
  this.posX     = x;
  this.posY= y;
  this.angle=random(0,360);
  this.size;
  this.amplitude=amp;
  this.sizeAmplitude=random(2,50);
  
  
  this.bounce=function(){
    this.posY=sin(radians(this.angle)) * 0.25*this.amplitude;
    this.posX=cos(radians(this.angle)) * this.amplitude;
    this.size=sin(radians(this.angle/2+135))*this.sizeAmplitude;
    this.angle=this.angle+this.speed*changeDir;
   }
    
  this.display=function(){
    
    ellipse(this.posX, this.posY,this.size,this.size);
  }
  
}


var amplitude = 200;
var angle=0;
//sizeAmplitude=50;
var particleVortex=[];
var changeDir=1;

function mousePressed(){
  changeDir=changeDir*(-1);
}



function setup() {
  createCanvas(windowWidth,windowHeight);
  for(var j=0;j<5;j++){
  for(var i=0;i<200;i++){
    particleVortex.push(new Particle(0,0,amplitude-i*8));
  }
    
  }  
}

function draw() {
  background(0); 
  noStroke();  
 // translate(mouseX,mouseY);
   translate(width/2,height/2);
    
  for(var i=0;i<particleVortex.length;i++){
    fill(particleVortex[i].color);
    particleVortex[i].bounce();
    particleVortex[i].display();
  } 
  
  }
