' Select chip and frequency
#chip 12F675,4

' Setup fuses
#config OSC = INT, BODEN = OFF, MCLR = OFF, PWRT = ON

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

#define dSmallChip			' 1024 words
#define dSmallEE			' 128 bytes eeprom

#include "d2b.h"
