// Unknown origin. Errors under Processing

int dots = []
float xscale = 0.01
float yscale = 0.01
int speed = 4
float zOffscale = 0.0055
float zOff = 0
float angle = 3.14
const size = 750

class Dot{
  constructor(x_, y_){
    this.x = x_ ||  random(width)
    this.y = y_ ||  random(height)
    this.vel = createVector(0,0)
  }

  update(){
    let n = noise(this.x*xscale , this.y*yscale, zOff)
    n = map(n,0,1,-2*PI + angle,angle)
    this.vel = p5.Vector.fromAngle(n)
    this.vel.mult(speed)
    this.x += this.vel.x
    this.y += this.vel.y

    if(this.x < 0) this.x = width
    if(this.y < 0) this.y = height
    if(this.x > width) this.x = 0
    if(this.y > height) this.y = 0
  }

  show(){
    stroke(map(this.x,0,width,0,255),0,map(this.y,0,height,0,255),55)
    line(this.x, this.y,this.x-this.vel.x, this.y - this.vel .y)
  }
}

function setup(){
  createCanvas(500,500)
  noStroke()
  
  for(let i = 0; i < size; i++){
    dots.push(new Dot())
  }
  noStroke()
}

function draw(){
  speed = map(mouseX,0,width,1,8)
  angle = map(mouseY, 0, height,0 ,2*PI)
  for(let i =0; i < size; i++){
    dots[i].update()
    dots[i].show()
  }
  zOff += zOffscale
}

function mousePressed(){
  background(0)
  dots = []
   for(let i = 0; i < size; i++){
    dots.push(new Dot())
  }
}
