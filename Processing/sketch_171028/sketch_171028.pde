// 171028
// Found at: https://www.openprocessing.org/sketch/467290

/*
171028
Big cube consisted of small cubes
only outer sides, no inner cubes.
*/

float t;
float theta;
int maxFrameCount = 250;

int a = 5; // offset number
int space = 105; // size of big cube for the for loops

color c1;
color c2;

OPC opc;

void setup(){
  size(540,540, P3D);
  
  opc = new OPC(this, "127.0.0.1", 7890);

  opc.ledGrid(0, 16, 10, width/2, height/2, 30, 30, 0, false, false);
  opc.enableShowLocations = true;
}

void draw(){
  background(5);
  translate(width/2,height/2);
  t = (float)frameCount/maxFrameCount;
  theta = TWO_PI*t;

  // lights
  directionalLight(245, 245, 245, 300, -200, -200);
  ambientLight(240, 240, 240);

  // rotate the whole cube
  rotateX(radians(45));
  rotateZ(radians(45));
  rotateY(theta);
  rotateX(theta);

// 3 nested for loops to create sides
  for (int x = -space; x <= space; x += 30) {
  for (int y = -space; y <= space; y += 30) {
  for (int z = -space; z <= space; z += 210) {

    // map size of small cubes with offset
    float offSet = ((x*y*z))/a;
    float sz = map(sin(-(theta*2)+offSet), -1, 1, -0, 30);

    color c1 = color(240,40,200);
    color c2 = color(5);


  if ((x*y*z)%30 == 0){
    fill(c1);
    stroke(c2);
  } else {
    fill(c2);
    stroke(c1);
  }

    // small blocks, 3 times to create cube
    shp(x,y,z,sz);
    shp(y,z,x,sz);
    shp(z,x,y,sz);

    }}}

    } // end loop

     void shp(float x, float y,  float z, float d){

            pushMatrix();
            translate(x,y,z);
            box(d);
            popMatrix();

      }
