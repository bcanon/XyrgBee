#include <Wire.h>
#include <NewSoftSerial.h>

#define YES 0x01;
#define NO 0x00;
#define r 0;
#define g 1;
#define b 2;


// Configure NewSoftSerial for both the LCD Backpack and the Rainbowduino 


NewSoftSerial lcd = NewSoftSerial(8,9);  // Receive pin then send pin.  Only send pin needs to be connected.
NewSoftSerial xbee =  NewSoftSerial(11, 12);

int CMDState;  // Required by setpixel functions

char endFlag;  // Holds expected end-of-command character

long displayResetMillis = 0;
int displayResetTime = 5000;
int displayNeedsReset = 0;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

unsigned char RainbowCMD[6];
unsigned long timeout;


// We're handling Red, Green and Blue values in three multidimensional arrays C[x][y]
int R[8][8] = {
  {8, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0}
};

int G[8][8] = {
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0}
};

int B[8][8] = {
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0},
  {0, 0, 0, 0, 0, 0, 0, 0}
};



int pixel[3][8][8] = {
  {
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0}
  },
  {
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0}
  },
  {
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0}
  } 
};

void setup() {

  // Start the default, LCD and XBee serial interfaces baud rates to 9600
  Serial.begin(9600);
  lcd.begin(9600);
  xbee.begin(9600);





  // Get the LCD ready
  lcdInitialize();






  // Join the I2C Bus on Arduino Analog Pins 4 and 5
  Serial.print("Attempting to join I2C Bus as Master...");
  lcd.print("Joining I2C Bus ");
  xbee.print("Attempting to join I2C Bus as Master...");

  Wire.begin(); // join i2c bus (address optional for master) - if it can't join the bus, the program will probably hang

  Serial.println("SUCCESS!");
  lcd.print("SUCCESS!");
  xbee.println("SUCCESS!");


  // Display the start-up animation & send start-up messages to the serial devices
  Serial.println("Displaying startup graphic.");
  xbee.println("Displaying startup graphic.");
  lcdClearDisplay;
  selectLineOne();
  lcd.print("Displaying       Startup Graphic");

  initialGameScreen();


  selectLineOne();
  lcd.print("XyrgBee v0.1    Awaiting Command");


  Serial.println("SUCCESS!");
  xbee.println("SUCCESS!");

  Serial.println("XyrgBee v0.1 Awaiting Command...");
  xbee.println("XyrgBee v0.1 Awaiting Command...");

  lcdClearDisplay;
  selectLineOne();

  lcd.print("XyrgBee v0.1    Awaiting Command");

ShowColor(4, 0, 0, 0);

}



void loop() {  

int x, y, red, green, blue;
char xSerial, ySerial, rSerial, gSerial, bSerial;

  char current;
  char buffer[16];
  int currentCounter = 0;
  // If there's inbound serial data available, grab the first chunk (it needs to be sent all at once vs. byte by byte)
  while(xbee.available()) {
    current = xbee.read();
    Serial.print("Serial character ");
    Serial.print(currentCounter);
    Serial.print("  value: ");
    Serial.println(current, HEX);
    buffer[currentCounter] = current;
    currentCounter++;
  }


if (currentCounter >= 5) {

int red, green, blue;


red = pixel[0][x][y];
green = pixel[1][x][y];
blue = pixel[2][x][y];

  
     SetPixelXY(4, x, y, red, green, blue);

  
}


//  



  // If we got some data from the default serial connection (Arduino Serial Monitor or XBee)
  if (currentCounter != 0) {
    Serial.println(" ");
    Serial.print("Total Characters Received: ");
    Serial.print(currentCounter);
    if (currentCounter >= 9) {
      xSerial = buffer[0];  // X value
   
      ySerial = buffer[2];  // Y value
    
      rSerial = buffer[4] / 16;  // Red value
    
      gSerial = buffer[6] / 16;  // Green valye
    
      bSerial = buffer[8] / 16;  // Blue value
      
      endFlag = buffer[9];  // End of command flag      



// TEST
//fill_stripeAlternating(rSerial, gSerial, bSerial);

     SetPixelXY(4, xSerial, ySerial, rSerial, gSerial, bSerial);



// Conditional - check for endFlag == "." else not a valid command
      
      if((xSerial >= 0) && (xSerial <= 7)) {
        x = xSerial;
      }
      if((ySerial >= 0) && (ySerial <= 7)) {
        y = ySerial;
      }
      if((rSerial >= 0) && (rSerial <= 15)) {
        red = rSerial;
      }
      if((gSerial >= 0) && (gSerial<= 15)) {
        green = gSerial;
      }
      if((bSerial >= 0) && (bSerial <= 15)) {
        blue = bSerial;
      }
      
      
      
      
      
      Serial.print(" (Valid XyrgBee Command)");
      lcdClearDisplay();
       selectLineOne();
      lcd.print("Command Received");
      lcd.print("[X");
      lcd.print(buffer[0], HEX);
      lcd.print("Y");
      lcd.print(buffer[2], HEX);
      lcd.print(" R");
      lcd.print(buffer[4], DEC);
      lcd.print("G");
      lcd.print(buffer[6], DEC);
      lcd.print("B");
      lcd.print(buffer[8], DEC);
      lcd.print("]");
      displayResetMillis = millis();
      displayNeedsReset = 1;
 
 // Add call to change state of Rainbowduino display 
 
    } else {
      Serial.print(" (Invalid XyrgBee Command)");
      lcdClearDisplay();
      selectLineOne();
      lcd.print("Invalid Command ->");
      for (int bufferLoop = 0; bufferLoop < currentCounter; bufferLoop++) {
        lcd.print(buffer[bufferLoop]);
      }
      displayResetMillis = millis();
      displayNeedsReset = 1;
    }
    Serial.println("");
    Serial.println("");
  }

  //  Reset the LCD to the default Awaiting Command screen if in need
  if (((millis() - displayResetMillis) > displayResetTime) && (displayNeedsReset != 0)) {
    selectLineOne();
    lcd.print("XyrgBee v0.1    Awaiting Command");
    displayResetMillis = millis();
    displayNeedsReset = 0;
  }
}
