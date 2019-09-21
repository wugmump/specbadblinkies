// P5Monjori
// Found at: https://www.openprocessing.org/sketch/494215

var program;

function setup() {
  pixelDensity(1);
  createCanvas(windowWidth, windowHeight,WEBGL);
  rectMode(CENTER);
  noStroke();
  fill(204);
  program = new p5.Shader(this._renderer,vert,frag);
  }

function draw() {  
  this.shader(program);
  background(0);
  program.setUniform('resolution',[width,height]);
  program.setUniform('time',millis()/200);
  rect(0,0,width,height);
}
