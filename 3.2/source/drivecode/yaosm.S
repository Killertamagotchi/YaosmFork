.macro bclr16 address bit
 .byte 0xF5, 0xD8 + \bit
 .word \address
.endm

.macro bset16 address bit
 .byte 0xF5, 0xD0 + \bit
 .word \address
.endm

.macro tbz16 address bit label
 .byte 0xF5, 0xC0 + \bit
 .word \address
 .byte \label
.endm

.macro tbnz16 address bit label
 .byte 0xF5, 0xC8 + \bit
 .word \address
 .byte \label
.endm

.ifdef _D2A
	.set	_addr_8308, 0x8308		# DICMD0
	.set	_addr_8330, 0x8330
	.set	_addr_8332,	0x8332
	.set	_addr_8334, 0x8334
	.set	_addr_8336, 0x8336
	.set	_addr_8346, 0x8346
	.set	_addr_8368, 0x8368
	.set	_addr_8369, 0x8369
	.set	_addr_8373, 0x8373
	.set	_addr_8378, 0x8378
	.set	_addr_837A, 0x837A
	.set	_addr_838C, 0x838C
	.set	_addr_8418, 0x8418
	.set	_addr_8428, 0x8428
	.set	_addr_8576, 0x8576		# Media
	.set	_addr_85A8, 0x85A8
	.set	_addr_85B8, 0x85B8
	.set	_addr_85BC, 0x85BC
	.set	_addr_85BE, 0x85BE
	.set	_addr_85C6, 0x85C6
.endif

.ifdef _D2B
	.set	_addr_8308, 0x8310
	.set	_addr_8330, 0x8338
	.set	_addr_8332,	0x833A
	.set	_addr_8334, 0x833C
	.set	_addr_8336, 0x833E
	.set	_addr_8346, 0x834E
	.set	_addr_8368, 0x8370
	.set	_addr_8369, 0x8371
	.set	_addr_8373, 0x837B
	.set	_addr_8378, 0x8380
	.set	_addr_837A, 0x8382
	.set	_addr_838C, 0x8394
	.set	_addr_8418, 0x8420
	.set	_addr_8428, 0x8430
	.set	_addr_8576, 0x8580
	.set	_addr_85A8, 0x85B2
	.set	_addr_85B8, 0x85C2
	.set	_addr_85BC, 0x85C6
	.set	_addr_85BE, 0x85C8
	.set	_addr_85C6, 0x85D0
.endif

# Settings from PIC eeprom
.set	_loc_region,		0x8700
.set	_loc_speed1,		0x8701
.set	_loc_speed2,		0x8702
.set	_loc_chipdisable,	0x8703
.set	_loc_autoboot, 		0x8704
.set	_loc_audiofix,		0x8705

# Internal variables
.set	_disc_type,			0x8706
.set 	_current_speed,		0x8707

_after_ls11:
				cmp		0x3260,d0		# 
				bne		not_3260
				sub		d0,d0			# Force OK if 0x3260
not_3260:
				bra		loc_8cf8f		# Done

_label1:
                mov     (_addr_8336), D0
                cmp     0, D0
                beq     _label3
                mov     (A2), D0
                cmp     0, D0
                bne     _label3
                mov     D3, (_addr_8334)
                mov     1, D0
                mov     D0, (A3)
                mov     0xFFFF, D1
                mov     _addr_8334, A0
                jsr     sub_94EC3
                mov     (_addr_8334), D0
                or      0x80, D0
                mov     D0, (_addr_8334)

_label2:
                bra		yaosm_code			# <---- Override call to DI handler with our own code
#                jsr     sub_851F1			# This is handled within yaosm code now
                bra     _label1				# And this line will never be reached but is kept to keep original size of the mainloop

_label3:
                mov     D3, (_addr_8334)
                mov     1, D0
                mov     D0, (A3)
                mov     0xFFFF, D1
                mov     _addr_8334, A0
                jsr     sub_94F61
return_from_disclogin: 
                mov     (_addr_8334), D0
                and     0x532, D0
                cmp     0x20, D0
                bne     _label2
                movbu   (_addr_8369), D0
                cmp     0, D0
                bne     _label4
                bra     _label13

_label4:
                mov     (_addr_85B8), D0
                cmp     4, D0
                beq     _label5
                mov     (_addr_85B8), D0
                cmp     3, D0
                beq     _label5
                bra     _label13

_label5:
                movbu   (_addr_8308), D2
                movbu   (0x40030F), D0
                btst    0x10, D0
                beq     _label6
                mov     0x800, D0
                mov     D0, (_addr_8330)
                mov     4, D0
                mov     D0, (_addr_8332)
#                jsr     sub_83E13
				bra		_label14
				nop
_label6:
#                jsr     sub_83E03
				bra 	_label15
				nop
_label16:
                bclr16	(_addr_8368), 0
                movbu   (_addr_8346), D0
                cmp     0, D0
                beq     _label7
                movbu   (_addr_8346), D0
                cmp     0x13, D0
                bne     _label8

_label7:
                mov     D3, (_addr_85B8)
                bra     _label9

_label8:
                mov     1, D0
                mov     D0, (A2)

_label9:
                movb    D3, (_addr_8369)
                mov     1, D0
                mov     0xFFDF, D1
                jsr     sub_952B0
                movbu   (_addr_838C), D0
                cmp     0, D0
                beq     _label10
                movb    D3, (_addr_838C)
                jsr     sub_9241E

_label10:
                mov     D2, A0
                cmp     0xA8, A0
                beq     _label11
                cmp     0xD0, A0
                beq     _label11
                cmp     0xA4, A0
                beq     _label11
                bra     _label1

_label11:
#                jsr     sub_838DC
				bra		_label17
				nop
_label18:
                movbu   (_addr_8368), D0
                btst    0x10, D0
                bne     _label12
                bra     _label1

_label12:
                and     0xFFEF, D0
                movb    D0, (_addr_8368)
                jsr     sub_89E6C
                bra     _label1

_label13:
                movb    D3, (_addr_8369)
                bra     _label2
################# END OF MAINLOOP #############################

### relocated JSR:s that goes from jsr label16 to jsr label24 as we relocate the mainloop.
### Keeping the mainloop size at the same size as the original one simplifies the patch algoritm.
_label14:
                jsr     sub_83E13
                bra		_label6
_label15:
                jsr     sub_83E03
                bra		_label16
_label17:
                jsr     sub_838DC
                bra		_label18
                
######### Media flag and sectors size patching ################
# This code is called after loginstate 7F has finished
# d0,d2,a0 is safe to use here
media_patching:
				mov		return_from_disclogin,a0 #Patch return adress from disclogin with our custom mainloop (0x4080c6/c8)
				mov		a0,(0x8be2)			#
											
				sub		d0,d0				#Clear config disc variable and current speed (no speed fix unless backup)
				mov		d0,(_disc_type)		#
				
				tbnz16	(_addr_8576),5,82	#Saving 2 bytes with mn102h instruction (step forward 82bytes if bit5 is set)
detected_backup:				
				mov		0x04,d0				#Set emu to 0x04
				movb	d0,(_addr_8576+34)	#

				mov		0x408819,a0
				movbu	(a0),d0				#d0 = 0x22
				add		-3,d0				#d0 = 0x1F (add -3 is 2 bytes less than sub 3)
				movb	d0,(_addr_8576+4)	#High byte
				movbu	(1,a0),d0			#d0 = 0xD0
				movb	d0,(_addr_8576+3)	#Mid byte
				movbu	(2,a0),d0			#d0 = 0x5F
				movb	d0,(_addr_8576+2)	#Low byte
				
				mov		0x8828,d0			#Set mediaword to 0x8828 (single layer)
				mov		_addr_8576,a0		#
				mov		d0,(a0)				#
				
				movx	(2,a0),d0			#Copy finished maxsector (first layer) to d0
				cmp		0,d0				#If this is zero...
				beq		single_layer_disc	#...then it is a single layer disc
				
				mov		0x8D,d2				#Dual layer mediabyte(high) should be 0x8D
				movb	d2,(_addr_8576+1)	#
				
				mov		0x3F69BF,d2			#Hard code maxsector (whole disc) to 0x3F69BF (needed by SSBB)
				bra		patch_maxsector
single_layer_disc:				
				mov		0x23047F,d0			#Set last sector to 0x23047F (Needed for DVD-RW/+R/+RW & SMG)
				mov		d0,d2				#First layer and whole disc is the same on single layer disc
patch_maxsector:				
				movx	d0,(2,a0)			#Last sector on first layer
				movx	d0,(12,a0)			#
				movx	d2,(6,a0)			#Last sector on disc
				movx	d2,(16,a0)			#
				movbu	(_loc_speed2),d0	#Alternate speed is default
				movb	d0,(_current_speed)	#
				sub		d0,d0				#Fake an OK from loginstate 7F even if it failed
no_media_patching:
				jmp		loc_8d4c7			#Go on
				
###############################################################				
##### Code called before and after call to 851F1 ##############
###############################################################
# d0,d1,d2,a0 is safe to use
yaosm_code:

### SMG fix goes here ###
				mov		_addr_8308,a0
				movbu	(a0),d0				#Read DI to d0
				cmp		0xA8,d0				#Are we doing an A8 command?
				beq		detected_A8			#
				tbz16	(_addr_8576),4,10	#Original? skip 10 bytes to "bra call_851f1"
				cmp		0xA4,d0				#A4 command?
				bne		no_smg_fix			#No?, then we're done
				bclr16	(_addr_8576),4		#0x38->0x28
				bra		call_851f1			#No audiofix on A4
no_smg_fix:				
# Check if audiofix should be used (We only get here if DICMD0 is not A8 or A4)
				movbu	(_loc_audiofix),d0	#2 or above means audiofix is on.
				cmp		0x02,d0				#
				blt		call_851f1			#
				mov		(_addr_8334),d0
    			btst	68,d0
				beq		call_851f1			#No fix
				movbu	(_addr_8346),d0
				extxb	d0
				cmp		-127,d0
				bne		call_851f1			#No fix
				movbu	(_addr_85BC),d0
				extxb	d0
				cmp		2,d0
				bne		call_851f1			#No fix
				jsr		sub_audiofix		#Go to audiofix
_label1b:
				bra		_label1				#Skip DI handler when audiofix is used

# Finally call the original subroutine
call_851f1:
                jsr     sub_851F1			#DI handler is called 

############ Finish mediapatching and recover from SMG fix #####                
# d0, d1 and a0 safe to use
				movbu	(_addr_8576),d0		#Read Mediabyte			
				cmp		0x28,d0				#Does it need patching?
				bne		_label1b			#No?
				bset16	(_addr_8576),4		#0x28->0x38
				bra		_label1b			#loop
				
######### Sector reads and modifications ########################
detected_A8:
				movbu	(_disc_type),d1		#Are we done yet?
				cmp		0,d1				#
				bne		A8_command_done_bne	#Yes? Then do not go on
								
check_gc_region_sector:				
# Check high word
				mov		(4,a0),d1			#high word
				cmp		0,d1				#is it zero
				bne		check_wii_region_sector	#No, then it's not the gc region area, but it may be the Wii region area
# Is it the disc header?
				mov		(6,a0),d2			#low word
				cmp		0x1001,d2			#0x0110 = gc region area
A8_command_done_bne:
				bne		A8_command_done_bra
# GC REGION AREA 0x00000110 (0x440) (Only read by GC)
# GameID patching
				mov		0x400180,a0			#Read gameid
				movx	(0,a0),d1			#3 bytes
				movb	d1,(_disc_type)		#Update _disc_type variable to make PIC accept changes if config disc (0x59) and also to indicate we're done
				cmp		0x484e47,d1			#"GNH"? (Action Replay disc)
				beqx	patch_gameid		#yes? patch!
				and		0xff,d1
				cmp		0x57,d1				#"W"? (WiiKey config disc)
				beq		patch_gameid		#yes? patch!
				cmp		0x59,d1				#"Y"? (Is it the yaosm config disc?)
				bne		not_config_disc		#no? do not patch
patch_gameid:								#Patch gameid 
				mov		0x5a47,d0			#"GZ"
				mov 	d0,(a0)				#
				cmp		0x59,d1				#Was it the yaosm config disc?
				beq		A8_command_done		#No region patching for config disc
not_config_disc:
				mov		0x20f661,a0			#F0Ff661 (start of discheader information)
				bra		region_patching		#go on and do the region patching
				
check_wii_region_sector:
# Check if Wii region area has been read (high word)
				cmp		0x0100,d1			#high word = 0x0001?
				beq		check_wii_region2	#yes? then go on
# Speed patching subroutine				
				movbu	(0x400180),d1		#Read first byte from gameID
				cmp		0x47,d1				#Is it "G"?
				beq		no_speed_patch		#Then skip speedfix (code gets here on GCOS multigame discs and we want to stop the speedfix)
				movbu	(_current_speed),d1	#
				cmp		0x01,d1				#Is it medium speed?
				blt		no_speed_patch		#Lower = Slow speed
				bhi		fast_speed			#Higher = Fast speed
				mov		0x81,d1				#Medium speed (0x0081)
				bra		patch_speed			#Do it
fast_speed:				
				mov		0x01bd,d1			#Fast speed (0x01BD)
patch_speed:
				mov		d1,(loc_40bd7a)		#Patch it
no_speed_patch:				
				bset16	(_disc_type),7		#Just making sure _disc_type != 0x00 and !=59 telling the code we are done here
A8_command_done_bra:
				bra		A8_command_done		#Done here
				
check_wii_region2:				
# Check if Wii region area has been read (low word)
				mov		(6,a0),d2			#low word
				cmp		0x38,d2				#0x3800 = Wii region area
				bne		A8_command_done		#
				movbu	(_loc_speed1),d1
				movb	d1,(_current_speed)
				
# WII REGION AREA 0x00013800 (0x4E000)

#  Toggle audiofix if requested
				movbu	(_loc_audiofix),d1	#Read audiofix config byte
				cmp		0,d1				#Is it 0 (Off)
				beq		no_af_toggle		#No?
				cmp		3,d1				#Is it 3 or higher (On)
				bge		no_af_toggle		#No?
				sub		2,d1				#0x01->0xFF(On), 0x02->0x00(Off)
				movb	d1,(_loc_audiofix)	#Save new setting (until chip is reset)
no_af_toggle:

				mov 	0x21d3c9,a0			#F1D3C9 - D00000 (Regionbyte location)
#Common region patching code for GC and Wii				
region_patching:				
				mov 	a0,(0x40006c)
				mov		0x430000,a0			#Setup a0
				tbz16	(_addr_8576),4,2	#Original? skip 2 bytes to "no_region_offset"
				add 	0x06,a0				#Add offset for backups
no_region_offset:
				movbu	(_loc_region),d1	#Read region
				cmp		0x03,d1				#Check region configuration
				beq		A8_command_done		#Disabled? (0x03)
				blt		patch_region		#Enabled? (0x00-0x02)
				movbu	(a0),d1				#Auto detect!
				movb	d1,(_loc_region)	#
patch_region:				
				movb 	d1,(a0)				#So we patch it C9/CF

				cmp		0x38,d2				#Skip next part for GC discs (d2=0x1001 for GC when we get here)
				bne		A8_command_done		#
				sub		d2,d2
				add		0x0d,a0				#0xF1D3D6
				mulu	d1,d1				#0->0, 1->1, 2->4
				add		d1,a0				#JAP=D6,USA=D7,PAL=DA
				movb	d2,(a0)				#Zero to 0xF1D3D6/D7/DA = JAP/USA/PAL				
A8_command_done:
				bra		call_851f1			#Go on
				
				
################## Audiofix below this point ###################
sub_audiofix:                				
				jsr		sub_85171
				sub		d0,d0
   				movb	d0,(_addr_8378)
				mov		8,d0
				mov		d0,(_addr_85A8)
    			jsr		sub_840b5
				mov		d0,(_addr_837A)
				cmp		0,d0
				mov		5,d2
				mov		d2,(_addr_85BC)
				bne		label_audiofix3
				mov		2,d2
				mov		d2,(_addr_85C6)
				mov		9,d2
				mov		d2,(_addr_85BE)
				movb	d0,(_addr_8373)
				mov		(_addr_8418),a0
				mov		(6,a0),d2
				mov		(_addr_8428),d0
				add		d2,d0
				add		-18,a3
				movx	d2,(10,a3)
				movx	d3,(14,a3)
				mov		d0,d3
				mov		0x01B000,d0
				movx	d0,(0,a3)
				mov		176,d0
				jsr		sub_audiofix4a
				movb	d2,(2,a3)
				movb	d2,(a3)
				jsr		sub_audiofix4a
				mov		d3,(2,a3)
				sub		d0,d0
				mov		d0,(4,a3)
				mov		0x0208,d0
				mov		d0,(a3)
				mov		4,d0
				jsr		sub_audiofix4b
				movx	(10,a3),d2
				movx	(14,a3),d3
				add		18,a3
				sub		d2,d2
label_audiofix2:
				jsr		sub_851aa
				jsr		sub_8517e
				rts	

label_audiofix3:
				mov		1,d0
				mov		d0,(_addr_85C6)
				mov		9,d2
				bra 	label_audiofix2

sub_audiofix4a:
				mov		1,d0
sub_audiofix4b:
				mov		a3,a0
				add		4,a0
				jsr		sub_91e65
				rts	
				                 				