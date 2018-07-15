 void makeRings() {
  
  opc.ledRing(0, 32, width/2, height/2, width*0.49, 0);
  opc.ledRing(32,24, width/2, height/2, width*.39,0);
  opc.ledRing(64,16, width/2, height/2, width*.29,0);
  opc.ledRing(80,12, width/2, height/2, width*.19,0);
  opc.ledRing(92,8, width/2, height/2, width*.09,0);
  opc.led(100,width/2, height/2);

  
 }
