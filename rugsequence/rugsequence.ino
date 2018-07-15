// The Jeffrey sequencer
// Joshua Goldberg 2017

#include <DmxMaster.h>

int fsrAnalogPin = 0; // FSR is connected to analog 0
int LEDpin = 11;      // connect Red LED to pin 11 (PWM pin)
int fsrReading;      // the analog reading from the FSR resistor divider
float fsrAvg; // smoother
int colorpoint;

float red[] = {0,0,0,0,0,0,0,0};
float green[] = {0,0,0,0,0,0,0,0};
float blue[] = {0,0,0,0,0,0,0,0};

float rPop = 128.;
float gPop = 128.;
float bPop = 128.;

int lightPin = 1;
int chaseDir = 1;
int chaseWait = 100;

void setup() {
  /* The most common pin for DMX output is pin 3, which DmxMaster
** uses by default. If you need to change that, do it here. */
  DmxMaster.usePin(3);

  /* DMX devices typically need to receive a complete set of channels
** even if you only need to adjust the first channel. You can
** easily change the number of channels sent here. If you don't
** do this, DmxMaster will set the maximum channel number to the
** highest channel you DmxMaster.write() to. */
  DmxMaster.maxChannel(24);

  Serial.begin(9600);   // We'll send debugging information via the Serial monitor

}

void loop() {

 
  
  fsrReading = analogRead(fsrAnalogPin);
  // Serial.print("Analog reading = ");
  //Serial.println(fsrReading);
  fsrReading = constrain(fsrReading, 50, 1950);
  fsrAvg = (fsrAvg + fsrReading) / 2.;
  int brightness = map(int(fsrAvg), 20, 1000, 1,16);

    chaseWait--;
    if (chaseWait == 0) {
      chaseWait = 1000-fsrAvg;
      lightPin = lightPin + chaseDir;
      if (lightPin == 8) {
        chaseDir = -1;
      } else if (lightPin == 1) {
        chaseDir = 1;
      }

       colorpoint+= (17-brightness);
  if (colorpoint > 255) { colorpoint = 0; }  
    int colorOffset = (colorpoint);
    
    if (colorOffset < 85) {
      red[lightPin-1] = colorOffset * 3;
      green[lightPin-1] = 255 - colorOffset * 3;
    } else if (colorOffset  < 170) {
      int temp = colorOffset -= 85;
      red[lightPin-1] = 255 - temp * 3;
      blue[lightPin-1] = temp * 3;
    } else {
      int temp = colorOffset -= 170;
      green[lightPin-1] = temp * 3;
      blue[lightPin-1] = 255 - temp * 3;
    }

    }

   //Serial.print("lightPin = ");
   //Serial.println(lightPin);






    for (int i=1; i <= 8; i++){
if (i!=lightPin) {
    red[i-1]= red[i-1]*.993;
    green[i-1]= green[i-1]*.993;
    blue[i-1]= blue[i-1]*.993;
}

    DmxMaster.write((i*3)-2,int(red[i-1]));
    DmxMaster.write((i*3)-1,int(green[i-1]));
    DmxMaster.write((i*3),int(blue[i-1]));
      


  }



    /* Small delay to slow down the ramping */
    delay(0);

  



}


