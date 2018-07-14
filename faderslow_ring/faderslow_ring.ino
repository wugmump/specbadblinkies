// Spec's verbose comentary goes here

#include <Adafruit_NeoPixel.h>

#define PIN    0 // signal plugged into port 6
#define N_LEDS 7 // 24 item ring
#define SCALE_FACTOR .9 // how bright is the color (range 0.-1.)
#define FSPEED 5 // by how much is it faded each time

// faderslow_ring 1.0
// code is incorrect for blinky as currently set

// joshua goldberg 2018
// gradually unphasing ring

float r = 0;
float g = 0;
float b = 0;
float w = 0;
int rDir = 1;
int gDir = 1;
int bDir = 1;

int FSRpin = 0;
int FSRvalue = 0;

int lightPin = 0;
int spinDir = 1;

int whichLED = 1;



Adafruit_NeoPixel strip = Adafruit_NeoPixel(N_LEDS, PIN, NEO_GRB + NEO_KHZ800);

void setup() {
  // put your setup code here, to run once:
  strip.begin();
//  Serial.begin(9600);

}

void loop() {


  if (g > 120) {
    gDir = -1;
  } else if (g < 30) {
    gDir = 1;
  }

  if (r > 120) {
    rDir = -1;
  } else if (r < 30) {
    rDir = 1;
  }

  if (b > 120) {
    bDir = -1;
  } else if (b < 30) {
    bDir = 1;
  }
  r = r + (.11 * rDir);
  g = g + (.12 * gDir);
  b = b + (.13 * bDir);

  lightPin = (lightPin + spinDir) % N_LEDS;
  strip.setPixelColor(lightPin, int(r), int(g), int(b));

  for (int i = 0; i < 24; i++) {
    // for each pixel, this reads the current color and fades it down a little every cycle

    // pix 8-18 = bottom ring
    // pix 24-35 = top ring

    whichLED=i;


    uint32_t currentColor = strip.getPixelColor(whichLED);
    int currentR = splitColor(currentColor, 'r');
    int currentG = splitColor(currentColor, 'g');
    int currentB = splitColor(currentColor, 'b');

    int x = FSPEED - 1;

    if (currentR > x) {
      currentR = currentR - FSPEED;
    } else {
      currentR = 0;
    }
    if (currentG > x) {
      currentG = currentG - FSPEED;
    } else {
      currentG = 0;
    }
    if (currentB > x) {
      currentB = currentB - FSPEED;
    } else {
      currentB = 0;
    }
    strip.setPixelColor(whichLED, currentR, currentG, currentB);
  }

  // put your main code here, to run repeatedly:
  strip.show();
  delay(15);
}

/**
   splitColor() - Receive a uint32_t value, and spread into bits.
*/
uint8_t splitColor ( uint32_t c, char value )
{
  switch ( value ) {
    case 'r': return (uint8_t)(c >> 16);
    case 'g': return (uint8_t)(c >>  8);
    case 'b': return (uint8_t)(c >>  0);
    default:  return 0;
  }
}
