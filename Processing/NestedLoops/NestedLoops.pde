// Nested Loops
// Found at: https://www.openprocessing.org/sketch/428993
// Runs under processing
// Flickers when opc.enableShowLocations = true;

float z = 0; // create variable for noise z

OPC opc;

void  setup() {
    size(320, 320);
    
  opc = new OPC(this, "rhubarb.local", 7890);

  opc.ledGrid(0, 16, 10, width/2, height/2, 30, 30, 0, false, false);
  opc.enableShowLocations = false;
  
}

void draw() {
    noStroke();
    fill(0, 0, 0, 10);
    rect(0,0,height,width);

    // float y = 0; creates decimal variable y and assigns value 0 to it
    // loop repeats as long as y < height; is true
    // y = y + 20 increments y in the end of each iteration.
    for (float y = 0; y < height; y = y + 20) {
        
      stroke(map(y * ((sin(frameCount/10)+1)/2) , 0, height, 0, 255), map(y * ((sin(frameCount/40)+1)/2) , 0, height, 0, 255), 255, 100);
        // float x = 0; creates decimal variable x and assigns value 0 to it
        // loop repeats as long as x < width; is true
        // x = x + 1 increments the x in the end of each iteration.
        for (float x = 0; x < width; x = x + 1) {
            point(x, y + map(noise(x/150, y/150, z), 0, 1, -100, 100));
        }
    }
    // when y is 500 the program will move forward. In this case increment z
    z = z + 0.02;
}
