'
'	YAOSM version 3.2
'

'#include "12F629_675_d2a.h"			' 12F629/675
'#include "12F629_675_d2b.h"			' 12F629/675
'#include "12F629_675_twoleds_d2a.h"	' 12F629/675
'#include "12F629_675_twoleds_d2b.h"	' 12F629/675
'#include "12F635_d2a.h"				' 12F635
#include "12F635_d2b.h"				' 12F635
'#include "12F683.h"					' 12F683
'#include "12F683_twoleds.h"			' 12F683
'#include "16F87_88.h"					' 16F87/88
'#include "16F627_d2a.h"				' 16F627/627A
'#include "16F627_d2b.h"				' 16F627/627A
'#include "16F628.h"					' 16F628/628A
'#include "16F630_676_d2a.h"			' 16F630/676
'#include "16F630_676_d2b.h"			' 16F630/676
'#include "16F636_639.h"				' 16F636/639
'#include "16F648.h"					' 16F648A
'#include "16F684.h"					' 16F684

	movlw	dDirections		' Saving some space by setting up all I/O directions at the same time
	movwf	dTrisio

	#ifdef dChipDisable
		movlw	3
		ReadEE
		movwf	BTEMP
		if bTemp.0 = 0 then goto NotDisabled
		movlw	dPullups						' Enable Weak pullup for the pDisable pin
		movwf	dWpu		
		bcf		OPTION_REG,7					' Globally enable weak pullups
		sDelay									' Wait, just in case the pullup need a little time to kick in
		if pDisable on then goto NotDisabled	' If high then we should not disable	
ChipDisabled:									' Loop forever
		goto ChipDisabled
NotDisabled:
	#endif

	bNum = 1
	#ifdef dLargeChip
		#ifdef pLed
			set pLed on		' LED indicates start of first sync
		#endif
		#ifdef pLed1
			set pLed1 on	' LED1 indicates start of first sync (twoled version)
		#endif
		bUnlock = 0				' Clear bUnlock to indicate that chip is undetected and sync will therefor not unlock chip
		sSyncAndUnlock			' Sync with cn302 (no unlock)
		#ifdef pLed
			set pLed off	' turn off LED to indicate sync success
		#endif
		#ifdef pLed1
			set pLed1 off	' turn off LED1 to indicate sync success (twoled version)
		#endif
		
		bHigh = 0x40
		bMid  = 0xBC
		bLow  = 0xB2
		sWriteCommandFF				' Read 0x40BCB2 to check for D2B chip (0x40BCB2 = 0x20 on D2B)
		if bResponse = 0x20 then	' D2B found
			bUnlock = 0xBE			' Setup variables
			dLow = 0x88				' Low addressbyte for original and new drivecode	
			bCodeHigh = 0x05		' Drivecode in program area starts at 0x0580
			bCodeLow = 0x80
			bNewRet = 0x90			' Low byte of new return address from loginstate 0x7f
			bOrgRetLow = 0x4A
			bOrgRetMid = 0xD5
			bNewRet2 = 0x7C			' Low byte of new return address from loginstate 0x11
			bOrgRetLow2 = 0xB4
			bUpgradeMid = 0xF5
		end if
		if bUnlock = 0 then			' Assume DMS/D2A if D2B is not found
			bUnlock = 0xB6			' Setup variables
			dLow = 0x86				' Low addressbyte for original and new drivecode	
			bCodeHigh = 0x03		' Drivecode in program area starts at 0x0200
			bCodeLow = 0x00
			bNewRet = 0x8e			' Low byte of new return address from loginstate 7f
			bOrgRetLow = 0xC7
			bOrgRetMid = 0xD4
			bNewRet2 = 0x7A			' Low byte of new return address from loginstate 0x11
			bOrgRetLow2 = 0x8F
			bUpgradeMid = 0xF3
		end if
		call sUnlock				' Unlock now that the unlock address is known
	#endif

	#ifdef dSmallChip
		#ifdef pLed
			set pLed on		' LED indicates start of first sync
		#endif
		#ifdef pLed1
			set pLed1 on	' LED1 indicates start of first sync (twoled version)
		#endif
		sSyncAndUnlock		' Sync and unlock
		#ifdef pLed
			set pLed off	' turn off LED to indicate sync success
		#endif
		#ifdef pLed1
			set pLed1 off	' turn off LED1 to indicate sync success (twoled version)
		#endif
		bCodeHigh = 0x01	' Drivecode in program area starts at 0x01B6
		bCodeLow = 0xA9
	#endif
	
	' Read 7th eeprom byte (pos 6)
	movlw	6
	ReadEE
	movwf	bNoEE			' bNoEE = 0xFF (on normal starts and 0x00 on recovery)
	' Clear pos 6 
	clrf	EEDATA
	call WriteEE
	
	bLow = bNewRet2		' Low addressbyte for original and new drivecode	

	#ifdef pLed
		set pLed off	' Turn LED off on to show code is being uploaded
	#endif
	#ifdef pLed2
		set pLed2 on	' LED2 indicates drivecode uploading (twoled version)
	#endif

	' Upload code
	bNoEE.0 = 1			' No eeprom reading on first patch run (0xFF on normal boot 0x01 on recovery boot)
	bOrgMid = 0x15
	DoPatching
	
	' Restore pos 6 in eeprom (which doubles as disc type variable)
'	movlw	6			' EEADR should still be 0x06 here
'	movwf	EEADR					
	movlw	0xFF						
	movwf	EEDATA
	call WriteEE
	
	bNoEE.0 = 0			' Enable eeprom reading 
		
	' Do upgrade unless it is a recovery boot
	if bNoEE.1 = 1 then
		' Do second patching
		bOrgMid = 0x15		' Restore bOrgMid
		bPos = 8			' Start with eeprom byte 8 (8-127/255 contains patch data)
		bLow = dLow			' Low, starting address
		DoPatching			' Upgrade
	end if
	
	' Upload settings to 0x8700
	bOrgMid = 0x1C		' Restore bOrgMid (0x87)
	bLow = 0			' Low, starting address
	bPos = 0			' Start with first eeprom byte
	bTemp = 7			' Replace 7 bytes
	call CopyAdded		' Upload settings
	
	#ifdef pLed1
		set pLed1 on	' LED1 serves as powerled (twoled version)
	#endif

WaitForDisc:			' Start of main loop
	#ifdef pLed
		set pLed on		' Turn on LED
	#endif
	#ifdef pLed2
		set pLed2 off	' Turn off LED2 (twoled version)
	#endif
	
	sHandleLoginstates						' Handles loginstate 0x11 and 0x7f (reads and writes to 0x008F84/86)
	
	bMid.3 = 0								' 0x8F -> 0x87
	bLow   = 0x06
	sWriteCommandFF							' Read 0x8706 to check for yaosm config/upgrade disc
	if bResponse = 0x59 then				' Only run when we have the correct disc in the drive
		bMid.2 = 0							' 0x87 -> 0x83
		bLow   = bUnlock + 0x52
		sWriteCommandFF
		if bResponse = 0xAA then			' 0xAA is our faked DI-command
			if bResponse2 = 0xA0 then		' Are we setting a value?
				#ifdef pLed
					set pLed off			' Turn off LED
				#endif
				#ifdef pLed2
					set pLed2 on			' Turn on LED2 (twoled version)
				#endif
				bLow = bUnlock + 0x54
				sWriteCommandFF				' Read DI buffer + 2 (pos + value)
				#ifdef dSmallEE
					if bResponse.7 = 1 then	' If someone tries to use an upgrade 
						bResponse = 8		' for large eeproms on a 128 byte eeprom
						bResponse2 = 0xFF	' then we disable the upgrade
					end if
				#endif
				movf	BRESPONSE,W			' Write value to eeprom
				movwf	EEADR				'
				movf	BRESPONSE2,W		'
				movwf	EEDATA				'
				call WriteEE				'
				bLow = bLow - 1				' Invalidate second byte in DICMD0 so that we do not set the same value twice
				bFirstbyte.7 = 0			'
'				bSecondbyte = 0				'
				call sWriteCommandFE		'
			end if
		end if
		goto WaitForDisc
	end if
	#ifdef dLargeChip
		if bResponse = 0x00 then			' On a failed disc detect disc type will remain zero
			bHigh = 0xF0					' F0F20C = disc header in read cache
			bMid = 0xF2
			bLow = 0x0C				
ReadDEAD:			
			sWriteCommandFF					' Read 2 bytes
			if bResponse = 0xDE	then		' Look for 0xDEAD
				if bResponse2 = 0xAD then
					bLow = bLow + 2			' 0x0E
					if bLow <> 0 then goto ReadDEAD ' (skip forward until bLow = 0)
					' Found 0xDEAD 122 times in discheader 
					EEADR = 0x00			' Start at 0x00
					bMid = bUpgradeMid
ReadEmergencyUpgrade:
					sWriteCommandFF			' Read first byte
					movf	BRESPONSE,W		'
					movwf	EEDATA			'
					call WriteEE			' Write it to eeprom
					bLow = bLow + 1			' Increase source address
					EEADR = EEADR + 1		' Increase eeprom address
					#ifdef dSmallEE
						if bLow.7 = 0 then goto ReadEmergencyUpgrade ' Save 128 bytes
					#endif
					#ifdef dLargeEE
						if bLow <> 0 then goto ReadEmergencyUpgrade ' Save 256 bytes
					#endif
					#ifdef pLed
						set pLed off		' Turn off LED
					#endif
					#ifdef pLed1
						set pLed1 off		' Turn on LED1 (twoled version)
					#endif
EmergencyUpgradeDone:						' Trap chip in loop until we powercycle
					goto EmergencyUpgradeDone
				end if
			end if
			goto WaitForDisc
		end if
	#endif
	if bMyregion = 0xFF then			' Auto detect region?
		bLow  = 0						' Read 0x008700 (Region)
		sWriteCommandFF					' 
		if bResponse < 3 then			' Is it a valid region?
			movf	BRESPONSE,W			' Get the response
			movwf	BMYREGION			' Save in bMyregion
			movwf	EEDATA				' and load EEDATA
			clrf	EEADR				' Choose pos 0 in eeprom
			call WriteEE				' Write to eeprom
		end if
	end if
	goto WaitForDisc

	
'**************************** Sub routines *****************************************

sub sHandleLoginstates
	bHigh = 0
	bMid  = 0x8F
	bLow  = 0x84
	bNum = 2
	sWriteCommandFF						' Read original return address from stack
	bSecondbyte = 0x80					' mid byte
	if bResponse = bOrgRetLow2 then		' Check for loginstate 0x11
		if bResponse2 = 0xCF then
			bFirstbyte = bNewRet2		' low byte
			sWriteNewReturnAddress		' Write 0x4080xx as new return address in stack
			goto DoneHandlingLoginstates
		end if
	end if
	if bResponse = bOrgRetLow then		' Check for loginstate 0x7F
		if bResponse2 = bOrgRetMid then
			bFirstbyte = bNewRet		' low byte
			bSecondbyte.0 = 1			' mid byte = 0x81
			sWriteNewReturnAddress		' Write 0x4081xx as new return address in stack
		end if
	end if
DoneHandlingLoginstates:
end sub

sub sWriteNewReturnAddress
	#ifdef pLed
		set pLed off			' Turn off LED
	#endif
	#ifdef pLed2
		set pLed2 on			' Turn on LED2 (twoled version)
	#endif
	call sWriteCommandFE		' write low & mid to 0x8f84
'	bLow  = 0x86				
	bLow.1 = 1					' Saving one asm instruction
	bFirstbyte = 0x40			' high byte
	bNum  = bNum - 1			' only one byte
	call sWriteCommandFE		' write high to 0x8f86
	bNum  = bNum + 1			' restore bNum
end sub

sub sReadPatch
	if bNoEE.0 = 1 then goto ReadFromProgramMemory	' eeprom or program area?
	movf	BPOS,W									' Read from eeprom
	ReadEE
	movwf	BCURRENT
	if bPos = 0 then bMyregion = bCurrent			' Save region
	bPos = bPos + 1									' Step to next byte
	goto DoneReadingFromEprom						' Done
ReadFromProgramMemory:
	call	READDRIVECODE							' Read drivecode
	movwf BCURRENT
	bCodeLow = bCodeLow + 1							' Increase address
	if bCodeLow = 0 then bCodeHigh = bCodeHigh + 1	' 255->0?
DoneReadingFromEprom:
end sub

sub	sUploadCode					' Upload code to ext ram
	bHigh = 0					' Internal ram for settings

	bSaveLow = bLow				' Save bLow
	bLow = bLow & 0x1F			' Remove the 3 highest bits
	if bLow = 0 then			' Handle loginstates a 8 times for every uploaded 256 bytes of drivecode (bLow=0x00/20/40/60/80/a0/c0/e0)
		sHandleLoginstates		
		bNum = bNum - 1			' sHandleLoginstates ALWAYS exits with bNum = 2
	end if
	bLow = bSaveLow				' Restore bLow
	
	if bPos > 7 then bHigh.6 = 1' if bPos = 8 or more then we're uploading to external ram (0x408xxx)
	bMid  = bOrgMid + 0x6B
	bFirstbyte = bCurrent
	call sWriteCommandFE
sIncreaseAddress:
	bLow = bLow + 1				' Increase address
	if bLow = 0 then bOrgMid = bOrgMid + 1
end sub

' Sync with cn302
sub sSyncAndUnlock
ReSyncOnUnlock:
	' Sync
	bSyncbyte1 = 0			' Clear syncbyte1
	bSyncbyte2 = 0			' Clear syncbyte2
SyncLoop:
   	rotate bSyncbyte1 right	' Rotate syncbyte1 right
   	rotate bSyncbyte2 right	' Rotate syncbyte2 right
	set pClock on			' Clock high
	call sClockDelay		' 4 us
	set pClock off			' Clock low
	call sClockDelay		' 4 us
   	bSyncbyte1.7 = pInput	' Read bit a put it as highest bit in syncword
	set pClock on			' Clock high
	if bSyncbyte2 <> 0xEE then goto SyncLoop ' Loop until synced
	if bSyncbyte1 <> 0xEE then goto SyncLoop ' Loop until synced
sUnlock:
 	' Unlock after sync only if chip has been detected
#ifdef dLargeChip
 	if bUnlock <> 0 then		
#endif
		' Write the unlock command (10 bytes)
		movlw 0xFE
		call sWriteByte			' 0xff = READ, 0xfe = WRITE		
		sReadByte				' Always 0						
		movlw 0x82
		call sWriteByte			' ADDR mid byte					
#ifdef dLargeChip
		movf bUnlock,W
#endif
#ifdef dSmallChip
		movlw bUnlock
#endif
		call sWriteByte			' ADDR low byte					
		movlw 0x41
		call sWriteByte			' first byte (write), 0x00 (read)	
		sReadByte				' ADDR high byte
		sReadByte				' second byte (write), 0x00 (read)	
		sReadByte				' Always 0						
		movlw 1
		call sWriteByte			' bytes to write/read 1 or 2
		sReadByte				' Always 0					
		' Read the response
		sReadByte
		bUnlockStatus = bIn					' Byte 1 is 0x00 if OK
		sReadByte
		bUnlockStatus = bUnlockStatus + bIn	' Byte 2 is 0x00 if OK
		sReadByte
		bUnlockStatus = bUnlockStatus + bIn	' Byte 3 is first byte when we read, should be 0x41 in this case
		' Check if OK, if not, resync and try again
		if bUnlockStatus <> 0x41 then goto ReSyncOnUnlock		' resync
#ifdef dLargeChip
 	end if
#endif
end sub

sub sReadByte
	movlw	0
sWriteByte:
	movwf	BOUT
	repeat 8									' Write 8 bits (1 byte)
		if bOut.0 = 0 then set pOutput off		' If LSB is 0 then set pOutput to low
		if bOut.0 = 1 then set pOutput on		' If LSB is 1 then set pOutput to high
		set pClock off							' Clock low
		rotate bOut right						' Rotate to next bit
		rotate bIn right						' Rotate to next bit
		bIn.7 = pInput							' Read bit and put in as hightest bit in byte
		set pClock on							' Clock high
	end repeat
	sDelay
sClockDelay:
end sub

sub sDelay
	wait 84 us
end sub

sub sWriteCommandFF
	bCmd = 0xFF
	goto RepeatWriteCommand
sWriteCommandFE:
	bCmd = 0xFE
RepeatWriteCommand:
	' Write the command (10 bytes)
	movf bCmd,W
	call sWriteByte						' 0xff = READ, 0xfe = WRITE		
	sReadByte							' Always 0						
	movf bMid,W
	call sWriteByte						' ADDR mid byte					
	movf bLow,W
	call sWriteByte						' ADDR low byte				
	movf bFirstbyte,W
	call sWriteByte						' lowbyte (write), 0x00 (read)	
	movf bHigh,W
	call sWriteByte						' ADDR high byte				
	movf bSecondbyte,W
	call sWriteByte						' highbyte (write), 0x00 (read)	
	sReadByte							' Always 0						
	movf bNum,W
	call sWriteByte						' bytes to write/read 1 or 2	
	sReadByte							' Always 0						
	' Read the response
	sReadByte
	bStatus = bIn						' Byte 1 is 0x00 if OK
	sReadByte
	bStatus = bStatus + bIn				' Byte 2 is 0x00 if OK
	sReadByte
	bResponse = bIn						' Byte 3 is first byte when we read
	if bNum.1 = 1 then					' bNum = 2? (saveing two asm instructions by bittesting)
		sReadByte
		bResponse2 = bIn				' Byte 4 is second byte when we read 2 bytes (1 word)
	end if
	if bStatus = 0 then goto WriteCommandDone ' Exit if OK
	sSyncAndUnlock					' resync and try again
	goto RepeatWriteCommand
WriteCommandDone:
end sub

sub DoPatching
' 0-108 = Added code (-1)
' 109-248 = Matching code (+108)
' 249-254 = Replaced code (+248)
' 255 = EOF
NextPatchByte:
	sReadPatch									' Get patch data
	if bCurrent = 255 then goto PatchingDone	' 255 means end of patch data
	if bCurrent > 108 then						' Matching code (109-248)
		bTemp = bCurrent - 108
CopyMatching:
		if bNoEE.0 = 1 then
			bHigh = 0x08
			bMid  = bOrgMid
			sWriteCommandFF						' Read original code, starting from 0x081586/0x081588
			bCurrent = bResponse
			sUploadCode							' Upload code to ext ram and increase address variables
		end if
		if bNoEE.0 = 0 then						' When eeprom patching we just increase the adress
			call sIncreaseAddress
		end if
		bTemp = bTemp - 1						' Decrease counter
		if bTemp <> 0 then goto CopyMatching
		goto NextPatchByte
	end if
	bTemp = bCurrent + 1
CopyAdded:										' Added code (0-108)
	sReadPatch									' Get code from eeprom
	sUploadCode									' Upload code to ext ram and increase address variables
	bTemp = bTemp - 1							' Decrease counter
	if bTemp <> 0 then goto CopyAdded
	goto NextPatchByte

PatchingDone:
end sub

sub ReadEE
	movwf EEADR
	#ifdef d16F87
		bcf EECON1,EEPGD
	#endif	
	bsf EECON1,RD
	movf EEDATA,W
end sub
	
WriteEE:
	#ifdef d16F87
		bcf EECON1,EEPGD
	#endif	
	bsf	EECON1,WREN
	movlw	85
	movwf	EECON2
	movlw	170
	movwf	EECON2
	bsf	EECON1,WR
WaitForEEWrite:
	btfsc	EECON1,WR
	goto	WaitForEEWrite
	return
	
READDRIVECODE:	
	movf  	bCodeHigh,W
	movwf	PCLATH
	movf	bCodeLow,W
	movwf	PCL
	