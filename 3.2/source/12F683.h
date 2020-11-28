' Select chip and frequency
#chip 12F683,4

' Setup fuses
#config OSC = INT, MCLR = OFF, PWRT = ON, BOD = OFF, IESO = OFF, FCMEN = OFF

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
#define dLargeChip			' 2048 words
#define dLargeEE			' 256 bytes eeprom
