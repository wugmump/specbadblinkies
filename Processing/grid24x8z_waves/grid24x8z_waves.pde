/*
 * Waves of color, in the HSV color space.
 *
 * This effect illustrates some of the properties of Fadecandy's dithering.
 * Hotkeys turn on/off various Fadecandy features. This file drives the
 * simple UI for doing so, and the actual effect is rendered entirely by a shader.
 */

// RUns on Processing, no obvious output to FC

PShader effect;
OPC opc;

void setup() {
  size(160,100, P2D);
  frameRate(30);
  
  effect = loadShader("effect.glsl");
  effect.set("resolution", float(width), float(height));

  opc = new OPC(this, "rhubarb.local", 7890);
  float spacing = height / 16.0;
  opc.ledGrid(0, 16, 10, width/2, height/2, 10, 10, 0, false, false);
  
  // Initial color correction settings
  mouseMoved();
}

void mousePressed() {
  opc.setStatusLed(true);
}

void mouseReleased() {
  opc.setStatusLed(false);
}

void mouseMoved() {
  // Use Y axis to control brightness
  float b = mouseY / float(height);
  opc.setColorCorrection(2.5, b, b, b);
}

void keyPressed() {
  if (key == 'd') opc.setDithering(false);
  if (key == 'i') opc.setInterpolation(false);
  if (key == 'l') opc.setStatusLed(true);
}

void keyReleased() {
  if (key == 'd') opc.setDithering(true);
  if (key == 'i') opc.setInterpolation(true);
  if (key == 'l') opc.setStatusLed(false);
}  

void draw() {
  // The entire effect happens in a pixel shader
  effect.set("time", millis() / 1000.0);
  effect.set("hue", float(mouseX) / width);
  shader(effect);
  rect(0, 0, width, height);
  resetShader();

  // Status text
  textSize(12);
  text("Keys: [D]ithering off, [I]nterpolation off, Status [L]ED", 10, 330);
  text("FW Config: " + opc.firmwareConfig + ", " + "  Color: " + opc.colorCorrection, 10, 350);
}
