//recursionCircles
// Found at: https://www.openprocessing.org/sketch/195432

float my_num=0;
void setup(){
  size(800,800);
  background(0);
  translate(width/8,height/8);
  recursiveThing(width/2,height/2,700);
  saveFrame();
}
void recursiveThing(float x, float y,float sz){
  float a,nx,ny;
  fill(random(0,255),200,200,50);
  noStroke();
  ellipse(x*noise(my_num),y*noise(my_num),sz,sz);
  if(sz>2){
     a=random(TWO_PI);
     nx=x+sz/2*sin(a);
     ny=y+sz/2*cos(a);
     recursiveThing(nx,ny,sz/2);
     
     a=random(TWO_PI);
     nx=x+sz/2*sin(a);
     ny=y+sz/2*cos(a);
     recursiveThing(nx,ny,sz/2);
    
     a=random(TWO_PI);
     nx=x+sz/2*sin(a);
     ny=y+sz/2*cos(a);
     recursiveThing(nx,ny,sz/2);
  }
  my_num=my_num+0.09;
}
