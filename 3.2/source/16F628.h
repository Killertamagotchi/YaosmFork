' Select chip and frequency
#chip 16F627, 4
' Setup fuses
#config OSC = INT, BODEN = OFF, MCLR = OFF, PWRT = ON

' Clock and I/O
#define pClock PORTA.0
#define pOutput PORTA.1
#define pInput PORTA.2

' Disable pin
#define pDisable PORTB.0

' Status LEDs
#define pLed PORTA.7

' I/O directions
#define dTrisio TRISA
#define dDirections 0x04

' Weak Pullup
#define dWpu TRISB			' On 16F62x all pullups on portb are controlled by bit7 in OPTIONREG so this is used to set directions on portb
#define dPullups 0x01		' portb.0 is input, the rest is output

#define dChipDisable		' Enable support for disabling chip by grounding pin 3 (This line must be disabled for two led compilations)
#define dLargeChip			' 2048 words
#define dSmallEE			' 128 bytes eeprom

