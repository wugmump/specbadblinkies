// Color and Size
// Found at: https://www.openprocessing.org/sketch/450321

const num = 100;
let particles = new Array(num);

function setup() {
  createCanvas(windowWidth, windowHeight);
  background(100);
  noStroke();
  for(let i = 0; i<num; i++) {
    let s = random(20);
    particles[i] = {
      pos: [ random(windowWidth), random(windowHeight) ], 
      color : [random(255), random(255), random(255), random(255)],
      size : [s,s]
    };
  }
}

function draw() {
  background(100);
  //ellipse(mouseX, mouseY, 20, 20);
  for(let i = 0; i<num; i++) {
    if(particles[i].color[3] < 0) {
      let s = random(20);
      particles[i] = {
        pos: [ random(windowWidth), random(windowHeight) ], 
        color : [random(255), random(255), random(255), random(255)],
        size : [s,s]
      }
    }
    
    fill(particles[i].color);
    ellipse(...particles[i].pos, ...particles[i].size);
    particles[i].color[3]--;
    
    particles[i].size[0]++;
    particles[i].size[1]++;
  }
}
