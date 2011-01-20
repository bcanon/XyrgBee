/*
 
 Serial LCD Backpack library for Sparkfun 5v Serial Enabled LCD Display
  
 created 27 May 2010
 modified 2 Jan 2011
 by Barrett Canon

 This sketch requires that the NewSoftSerial library be installed in the Arduino IDE's Contents/Resources/Java/libraries directory 
 NewSoftSerial can be downloaded here: http://arduiniana.org/libraries/newsoftserial/

 Sparkfun Serial Backpack Datasheet: http://www.sparkfun.com/datasheets/LCD/SerLCD_V2_5.PDF

 Pin numbers:
   LCD Backpack:
     5v - either 5v Arduino Pin
     Gnd - Arduino Ground Pin
     Rx - The Arduino pin defined in the second argument of the NewSoftSerial declaration (pin 9 in the below example)
 


Example:
  In the declarations section of the sketch (before setup()):
    NewSoftSerial lcd = NewSoftSerial(8,9);  // Receive pin then send pin.  Only send pin needs to be connected.
  setup():
      lcd.begin(9600);
      lcdInitialize();


 Available Functions:
  lcdBacklightOff()
  lcdBacklightOn()
  lcdClearDisplay()
  lcdCommand(byte lcdCommand)
  lcdCursorLeft()
  lcdCursorRight()
  lcdDisplayAwaitingMessage(char buffer[16], int charactersToDisplay)
  lcdGotoPosition(int cursorPosition)
  lcdInitialize()
  lcdScrollLeft()
  lcdScrollRight()
  lcdSetBacklightValue(int backlight)
  lcdUnderlineCursorOff()
  lcdUnderlineCursorOn()
  lcdVisualDisplayOff()
  lcdVisualDisplayOn()
  lcdblinkingBoxCursorOff()
  lcdblinkingBoxCursorOn()
  selectLineOne()
  selectLineTwo()


 */
 
 
void lcdInitialize() {   
  // Get the LCD display ready for showtime, giving it 200ms of breathing room between each request, lest it hang
  lcdBacklightOn();
  delay(200);
  lcdClearDisplay();
  delay(200);
  lcdVisualDisplayOn();  
  delay(200);
}


void lcdDisplayAwaitingMessage(char buffer[16], int charactersToDisplay) {
  // Display message (up to 16 characters) on the serial backpack, starting at the current position
  for (int characterLoop = 0; characterLoop < charactersToDisplay; characterLoop++) {
    lcd.print(buffer[characterLoop]);
  }
}


void selectLineOne() {
  // Puts the cursor at line 0 char 0
  lcdCommand(128);
}


void selectLineTwo() {  
  // Puts the cursor at line 1 char 0
  lcdCommand(192);
}


void lcdGotoPosition(int cursorPosition) {
  // Move the cursor to the specified position
  if (cursorPosition < 16) {
    // line 1: 0-15 
    lcdCommand(cursorPosition + 128);
  } 
  else if (cursorPosition < 32) {
    // line 2: 16-31,
    lcdCommand(cursorPosition + 128 + 48);
  } else { 
    // 31+ defaults back to 0
    lcdGotoPosition(0);
  }
}


void lcdClearDisplay() {
  // Clear Display
  lcdCommand(0x01);  
}


void lcdCursorRight() {
  // Move cursor right one
  lcdCommand(0x14);  
}


void lcdCursorLeft() {
  // Move the cursor to the left
  lcdCommand(0X10);
}


void lcdScrollRight() {
  // Scroll right
  lcdCommand(0X1C); 
}  


void lcdScrollLeft() {
  // Scroll left
  lcdCommand(0X18);
}  


void lcdVisualDisplayOn() {
  // Turn visual display on
  lcdCommand(0X0C);  
}  


void lcdVisualDisplayOff() {
  // Turn visual display off
  lcdCommand(0X08);
}  


void lcdUnderlineCursorOn() {
  // Underline cursor on
  lcdCommand(0X0E);
}  


void lcdUnderlineCursorOff() {
  // Underline cursor off
  lcdCommand(0X0C); 
}  


void lcdblinkingBoxCursorOn() {
  // Underline cursor on
  lcdCommand(0X0D);  
}  


void lcdblinkingBoxCursorOff() {
  // Blinking box cursor off
  lcdCommand(0X0C);
}  


void lcdSetBacklightValue(int backlight) {
  // Sets the LCD's backlight level to a value between 0 (off) and 30 (fully on)
  if (backlight > 30) {    // Make sure that the backlight is within the expected range
    backlight = 30;
  } else if (backlight < 0) {
    backlight = 0;
  }
  backlight = backlight + 128;  // Backlight Brightness values passed to the LCD run from 128 (off) to 157 (fully on)
  lcd.print(0x7C, BYTE);  // Command Character for Backlight Brightness
  lcd.print(backlight, BYTE);
}


void lcdBacklightOn() {
  // Turn on the backlight
  lcd.print(0x7C, BYTE);  // Command Flag for Backlight
  lcd.print(157, BYTE);  // Light Level On
}


void lcdBacklightOff() {
  // Turn off the backlight
  lcd.print(0x7C, BYTE);  // Command Flag for Backlight
  lcd.print(128, BYTE);  // Light Level Off
}


void lcdCommand(byte lcdCommand) { 
  // Sends the required command character to the LCD backpack
  lcd.print(0xFE, BYTE);  // Command Character
  lcd.print(lcdCommand, BYTE);
}
