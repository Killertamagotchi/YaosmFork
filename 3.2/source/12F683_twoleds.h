' Select chip and frequency
#chip 12F683,4

' Setup fuses
#config OSC = INT, MCLR = OFF, PWRT = ON, BOD = OFF, IESO = OFF, FCMEN = OFF

' Clock and I/O
#define pClock GPIO.0
#define pOutput GPIO.1
#define pInput GPIO.2

' Status LEDs
#define pLed1 GPIO.5
#define pLed2 GPIO.4

' I/O directions
#define dTrisio TRISIO
#define dDirections 0x04

#define dLargeChip			' 2048 words
#define dLargeEE			' 256 bytes eeprom
