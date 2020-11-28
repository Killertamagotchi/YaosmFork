' Select chip and frequency
#chip 16F676, 4

' Setup fuses
#config OSC = INT, BODEN = OFF, MCLR = OFF, PWRT = ON

' Clock and I/O
#define pClock PORTA.0
#define pOutput PORTA.1
#define pInput PORTA.2

' Disable pin
#define pDisable PORTA.4

' Status LEDs
#define pLed PORTA.5

' I/O directions
#define dTrisio TRISA
#define dDirections 0x14

' Weak Pullup
#define dWpu WPU
#define dPullups 0x10

#define dChipDisable		' Enable support for disabling chip by grounding pin 3 (This line must be disabled for two led compilations)
#define dSmallChip			' 1024 words
#define dSmallEE			' 128 bytes eeprom

#include "d2a.h"
