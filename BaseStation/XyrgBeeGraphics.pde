


void initialGameScreen() {
  ShowColor(4, 0, 0, 0);  // Turn off all pixels
  delay(500);
  ShowChar(4,'X',0,15,0,0);
  delay(500);
  ShowColor(4, 0, 0, 0);  // Turn off all pixels
  delay(50);
  ShowChar(4,'y',0,15,0,0);
  delay(500);
  ShowColor(4, 0, 0, 0);  // Turn off all pixels
  delay(50);
  ShowChar(4,'r',15,0,0,0);
  delay(500);
  ShowColor(4, 0, 0, 0);  // Turn off all pixels
  delay(50);
  ShowChar(4,'g',0,0,15,0);
  delay(500);
  ShowColor(4, 0, 0, 0);  // Turn off all pixels
  delay(50);
  ShowChar(4,'B',0,15,0,0);
  delay(500);
  ShowColor(4, 0, 0, 0);  // Turn off all pixels
  delay(50);
  ShowChar(4,'e',0,15,0,0);
  delay(500);
  ShowColor(4, 0, 0, 0);  // Turn off all pixels
  delay(50);
  ShowChar(4,'e',0,15,0,0);
  boder_twoColorChase (15,0,0,0,15,0);  
  
}




void yinYang() {
  for (int low = 0; low < 16; low++) {
    boder_twoColorChase(low, 0, 0, 0, 15 - low,0);
  }  
  for (int low = 0; low < 16; low++) {
    boder_twoColorChase(15 - low, 0 , 0, 0, low, 0);
  } 
}



void fill_stripe(int red, int green, int blue) {
  for (int x = 0; x < 8; x++) {
    for (int y = 0; y < 8; y++) {
      SetPixelXY(4, x, y, red, green, blue);
    }    
  }  
}


void fill_stripeAlternating(int red, int green, int blue) {
  for (int x = 0; x < 8; x++) {
    if (x % 2 == 0) {
      for (int y = 0; y < 8; y++) {
        SetPixelXY(4, x, y, red, green, blue);
      }    
    } 
    else {
      for (int y = 7; y >= 0; y--) {
        SetPixelXY(4, x, y, red, green, blue);
      }    
    }  
  }
}


void boder_twoColorChase (int red1, int green1, int blue1, int red2, int green2, int blue2) {
  // The two passed colors chase each other around the border for one complete revolution
  int delayTime = 0;
  int x = 0;
  int y = 0;

  for (y = 0; y <= 6; y++) {
    SetPixelXY(4, x, y, red1, green1, blue1);  // First Color: (0,0) -> (0,6)
    SetPixelXY(4, 7 - x, 7 - y, red2, green2, blue2);  // Second Color: (7,7) -> (7,0)
    delay(delayTime);
  }
  y = 7;
  for (x = 0; x <= 6; x++) {
    SetPixelXY(4, x, y, red1, green1, blue1);   // First Color: (0,7) -> (6,7)
    SetPixelXY(4, 7 - x, 7 - y, red2, green2, blue2);  // Second Color: (6,0) -> (0,0)
    delay(delayTime);
  }  
  x = 7;
  for (y = 7; y >= 1; y--) {
    SetPixelXY(4, x, y, red1, green1, blue1);    // First Color: (7,7) -> (7,1)
    SetPixelXY(4, 7 - x, 7 - y, red2, green2, blue2);  // Second Color: (0,1) -> (0,7)
    delay(delayTime);
  }  
  y = 0;
  for (x = 7; x >= 1; x--) {
    SetPixelXY(4, x, y, red1, green1, blue1);    // First Color: (7,0) -> (6,0)
    SetPixelXY(4, 7 - x, 7 - y, red2, green2, blue2);  // Second Color: (,7) -> (,7)
    delay(delayTime);
  }    
}