' Select chip and frequency
#chip 12F675,4

' Setup fuses
#config OSC = INT, BODEN = OFF, MCLR = OFF, PWRT = ON

' Clock and I/O
#define pClock GPIO.0
#define pOutput GPIO.1
#define pInput GPIO.2

' Disable pin
#define pDisable GPIO.4

' Status LEDs
#define pLed GPIO.5

' I/O directions
#define dTrisio TRISIO
#define dDirections 0x14

' Weak Pullup
#define dWpu WPU
#define dPullups 0x10

#define dChipDisable		' Enable support for disabling chip by grounding pin 3 (This line must be disabled for two led compilations)
#define dSmallChip			' 1024 words
#define dSmallEE			' 128 bytes eeprom

#include "d2a.h"