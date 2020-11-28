yaosm version version 3.2
-------------------------
Yet Another OpenSource Modchip version 3.2
USE IT AT YOUR OWN RISK!


Features
--------
- Supports DMS/D2A/D2B chipsets (It does NOT support D2C)
- Wii originals
- Wii original imports*
- Wii backups
- Wii backup imports*
- Gamecube originals
- Gamecube original imports**
- Gamecube backups
- Gamecube backup imports**
- Gamecube homebrew
- All medias DVD-R/DVD-RW/DVD+R/DVD+RW/DVD+R DL/DVD-R DL (no bitsetting required)
- Dual Layer support
- Configurable speed setting (default and alternate)
- Automatic region detection
- Stealth (well, at least as much "stealth" as any other Wii modchip currently available)
- "Safe" Configuration disc
- Optional status LED
- Optional disable switch (solder wire to reset switch)
- GameID overriding for some GameID's that was blocked by firmware 3.0***
- Support for Super Mario Galaxy and Super Smash Bros. Brawl
- Gamecube audiofix (4 different configurations)
- DVD upgradeable
- Recovery mode in case of a failed upgrade (See Q&A section for details)

*Partial support.
See http://wiki.gbatemp.net/wiki/index.php/Wii_Region_Patcher_Compatibility_List for more info.
 
**Partial support, for 100% support use GCOS.
See: http://wiinewz.com/forums/gcos/

***Allows booting of yaosm config disc, WiiKey config disc and some versions of Action Replay.


Donations
---------
http://wiinewz.com/forums/yaosm/66982-donations.html


Quickstart
----------
1. Program your chip with the hex file that match the chip you've choosed to use.
2. Connect the chip to your Wii. (http://wiinewz.com/forums/yaosm/67994-install-guide-by-the-cheekymonkey.html)
3. Make sure the first disc you use is a game from your own region.
4. If you later on want to change any settings, use the configuration disc.


Chip compability
----------------
Hexfiles are included for the following PICs:
12F629/12F675
12F635
12F683
16F627/16F627A
16F628/16F628A
16F648A
16F630/16F676
16F636/16F639
16F684
16F87/16F88

Should be portable to any PIC chip that GCBasic supports and has the following requirements.
- At least 1024 words of program memory (2048 is preferred)
- 64 bytes of ram
- A decent amount of hardware stack levels (no 12F509 is NOT a suitable chip)
- At least 128 bytes of eprom memory for configuration and upgrade data.
- Internal oscillator (Sure, you can use an external if you really want to but is it worth the trouble?)


Installation
------------
An excellent guide for opening and modding your wii can be found here:
http://wiinewz.com/forums/yaosm/67994-install-guide-by-the-cheekymonkey.html

By default the chip has speedfix and audiofix enabled.
This can be changed by modifying the eeprom data before programming your chip or you can change it
later with the configuration disc (requires a GC controller).


Automatic region detection
--------------------------
The region setting will be configured automaticly the first time you insert a disc after programming
the chip so make sure that the first game you try is a disc from your own region. Doesn't matter if
it is a Wii or a Gamecube disc, backup or original.

If you, by mistake, used an import as the first disc then the chip will not play ANY backup or original discs 
after that and you will need to reprogram the chip or use the configuration disc.


Configuration
-------------
This is an explanation of the configuration bytes:

byte 0 = Regionpatching
0x00 = JAP, 0x01 = USA, 0x02 = EUR, 0x03 = disabled, 0xFF = auto (default)

byte 1 = Default speed setting (only affects Wii backups)
0x00 = slow speed   (Gamecube speed)
0x01 = medium speed (Somewhere in between)
0xFF = fast speed   (Wii speed) (default)

byte 2 = Alternate speed setting (only affects Wii backups)
0x00 = slow speed   (Gamecube speed)
0x01 = medium speed (Somewhere in between)
0xFF = fast speed   (Wii speed) (default)

byte 3 = Chip disable feature (you may want to disable this if you have a LED connected to pin3)
0x00 = Disable the chip disable feature (no weak pull-up on pin3)
0xFF = Enable the chip disable feature (this is the default)

byte 4 = Reserved for future features

byte 5 = Audiofix on/off
0x00 = Disable the Gamecube audiofix (always off)
0x01 = Disable audiofix by default (when powering up the Wii) and enable it by inserting a Wii disc before running your GC backup.
0x02 = Enable audiofix by default (when powering up the Wii) and disable it by inserting a Wii disc before running your GC backup.
0xFF = Enable the Gamecube audiofix (always on)(default)

byte 6 = reserved and used by recovery procedure in case of a bad upgrade. Do NOT change this manually.

byte 7 = Always 0xFF, do not change.

byte 8 and higher = reserved for upgrade patch data

 
Schematics          12F6xx      16F630/x6/84     16F639      16F62x/64x/8x
----------           __ __         __ __          __ __          __ __
V = 3.3v           1|V   G|8     1|V   G|14     1|V   G|20     1|I   O|18
G = Ground         2|L   C|7     2|L   C|13     2|L   C|19     2|    C|17
C = Clock          3|D   O|6     3|D   O|12     3|D   O|18     3|    L|16
O = Output         4|____I|5     4|    I|11     4|    I|17     4|     |15
I = Input                        5|     |10     5|     |16     5|G   V|14
                                 6|     |9      6|     |15     6|D    |13
L = Status LED (optional)        7|_____|8      7|     |14     7|     |12
D = Disable switch (optional)                   8|     |13     8|     |11
Connect LED like this: L<>+LED-<>R<>G           9|     |12     9|_____|10
Use 680ohm for R with red LED and 470ohm       10|_____|11
with yellow or green LED.

For 12F629, 12F635, 12F675 and 12F683 chips the pinout is identical to WiiFree/OpenWii(PIC version)/Wiinja

Here's an attempt of showing the solderpoints on the Wii with ASCII:

            V  G
       *          *
 --->* I C    * * *
/      * O      * - * 
|               * * * *
|      | |            *
| * *  * * *     =
|       ||||||||||||||||||||
|      /                    \
|     -                      -
|     -      Panasonic       -
|     -       G2C-D2B        -
|     -   (or DMS or D2A)    -
|     -                      -
 \
  NOTE:  If you lack the solder point that the arrow points at, don't worry, it just means that you
         have the new circuitboard. The only modchip I know that uses that point is the WiiKey.
  NOTE2: Late D2B boards have their legs cut off where connection point I, C and O normally connects
         to the G2C-D2B chip. If this is the case then you may need to grind off plastic from the
         top of the chip in order to repair that connection. This should ONLY be done by someone who
         knows what they're doing. Use google to find more information about the D2Bs with cut legs.
      

Status LED (optional)
---------------------
Goes on and off a few times during startup, then stays on but is turned off for a short period when a
disc is detected.

For some chips there are a 2-LED version where the second LED should be connected to the pin marked as
"D" in the schematic above. That also means those versions doesn't come with a chip disable feature.


Disable switch (optional)
-------------------------
By soldering a wire between pin3 on the chip and the middle "pin" on the Wii reset switch the chip
can be disabled by holding the reset button while powering on the Wii. It may be easier and less
dangerous to just connect an on/off switch between ground (pin8) and pin3. I do not recommend soldering
to the reset switch unless you know what you are doing.

At the moment there doesn't seem to be a necessary to ever disable the chip so this feature should
be considered as highly optional.

If you have a LED attached to pin3 then it will "glow" since the chip configures this pin as an input
pin with a weak pull-up (to make sure it is always read as high unless it is connected to ground). If
this bothers you then the chip disable feature can be disabled completely by modifying the eprom data
before programming the chip or by using the configuration disc.


About upgrades and how it works
-------------------------------
The code on the PIC processors that yaosm supports are NOT upgradeable without an external programmer.
So the code on the PIC can not be DVD upgraded. However 99% of the "magic" in yaosm is no longer done
with PIC code. It's done with mn102h(the processor architecture of the DMS/D2A/D2B chip) code and the
mn102h code is uploaded to the DMS/D2A/D2B controller by the PIC code. The PIC code also contains code
that will patch the allready uploaded code with information stored in the eeprom area of the PIC chip.

The eeprom area CAN be changed without an external programmer so therefor yaosm can be upgraded. There
is a limit though. The PIC chips either has 128 or 256 bytes of eeprom and 8 of those bytes are used
for storing the yaosm configuration. This is likely very similar to how the upgrades for Wiinja Deluxe
and Wiid works.

The normal way to upgrade yaosm is with a GC homebrew that sends the patch data as fake DI commands
which the PIC code catches and saves to the eeprom. I believe all current DVD upgradeable Wii chips
today uses GC homebrew to do the upgrade except for Wiinja Deluxe and possibly also Wiid.

In case future Wii firmware upgrades somehow manage to block GC homebrew this method will no longer
work and therefor yaosm supports an alternate upgrade method that doesn't need any homebrew code.
The alternate method detects a certain disc and reads the upgrade data directly from the read cache.
It's only included in the PIC chips with 2048 words of program area (like for example the 12F683) as it
didn't fit into the "smaller" chips.


Changes
-------
3.2
- Improved disc detection.
- Fixed PIC code so that it cannot corrupt the region byte. (No, really, this time it IS fixed)

3.1
- Fixed PIC code so that it cannot corrupt the region byte.

3.0
- Almost all code rewritten to drivecode.
- Configurable idle LED removed.
- DVD upgrade support added. 120 bytes of patch data can be stored in the eeprom (248 bytes for 12F683 
  and other chips with 256 bytes of eeprom)
- Better dual layer and SSBB support. Supports DVD+R DL and DVD-R DL without using bitsetting.

2.0
- Added Gamecube audiostreaming fix.

1.9
- Added GameID patch for Action Replay discs, all credit for this goes to Nekokabu. Consider this
  feature as experimental as it will only work on some AR versions.
- Added fix for Super Mario Galaxy backups.

1.8
- Sacrificed one of the status LED in favour of becoming 100% pin compatible with Wiinja chips which
  means that the chip can also be disabled by solder a wire between pin3 and the middle pin on the
  reset switch.
- Added a configuration byte to control the behaviour of the status LED when the chip is idle.
- Added a configuration byte to enable/disable the chip disable feature.
- Added support for dual layer discs.
- Added GameID overriding for GameIDs starting with W and Y (Makes them usable again on firmware 3.0)
- Changed GameID for future config discs
  
1.7
- Re-added support for 12F635/16F636/16F639 as it has been fixed (bug in GC basic)
- Minor code optimizations (saving a couple of bytes)

1.6
- Removed support for 12F635/16F636/16F639 since it has never been working.
- Redesigned the speed patching and made it fully configurable.
- Enabled the quick 4 flashes on status LED when eprom is updated.
- Added support for yaosm configuration disc.
- Removed support for rescue discs (no longer needed).

1.5 
- Further optimizations to the code and fixed an issue with version 1.4.
  Version 1.5 hopefully is what version 1.4 should have been.

1.4	
- Increased the number of loops before giving up while detecting type of game,
  which resulted in better detection of imports.
- Optimized the code for speed and size. New code is 22.5% smaller than version 1.3.
- Added silent mode (Speedfix default off but can be turned on when needed)
- Enabled support for rescue disc (reset/disable region patching)

1.3   
- Fixed problem with imported Gamecube promotional and demo discs.
- Added medium speedfix since it works better for some people.	

1.2
- Fixed problem with Gamecube original imports.

1.1
- Wii Original Imports shouls now work (thanks to the WiiFree team).
- Also region detection with originals now works.
- Some minor code optimizations.

1.0
- Initial release.


Credits
-------
The WiiFree team, The OpenWii team, WAB, FuzzyLogic 
     I've learned a lot from bits and pieces of your code...

The Great Cow Basic team 
     Don't let the name fool you. The code is more efficient than you may think and
     the support is excellent.

TheCheekyMonkey
     Excellent modding guide. Anyone planning to mod their Wii should read it.

emu_kidid
     For the excellent GCOS and for further developing it to support dual layer discs.
     
Team Cyclops
     Without the Dual Layer checking tool, testing DL support would have been a lot harder.
     
Microchip
     For their free samples program. I would never have learned PIC programming without it.

Erant
     I've borrowed code from the DVD tool sources to save time when relocating the mainloop
     and it certainly saved me some time. And I've learned a lot from your sources when rewriting
     everthing to drivecode.

The people on the yaosm forums at WiiNews
     Thanks for helping out with testing, it's really, really appriciated.
     Special thanks for those who provided the information needed to sort out the SMG problem.

All the people in the WiiNewz forums.
     The feedback given to the different WiiFree version has helped in the past.
     
Everyone I've forgotten to mention.


Question & Answers
------------------
Q: My 12F629/12F675/16F630/16F676 doesn't work!
A: Make sure you read the chip when it is new and write down it's bandgap setting. Make sure
   you use this bandgap setting when you program the chip. The programming software _should_
   preserve your bandgap setting but under some circumstances it may be overwritten and wrong
   bandgap setting can lead to an unstable or non-working chip.
   
   Also make sure you used the correct version. Due to space limitations in these chips (and
   a few others) there are one version for DMS/D2A and one for D2B.

Q: I'm about to buy a chip, which should I get?
A: I would go for the 12F683 since it is small, like the other 8-pin chips but has twice the
   amount of codespace and eeprom space compared to the 12F629/12F675. It also has the 
   capability of running at 8MHz which is twice the speed of the 12F629/12F675 chips.
   
   Currently yaosm has come to the point where all features no longer fits into the smaller chips
   so a 12F683 is the right choice.

Q: What about Gamecube imports, what's all this talk about GCOS?
A: With GCOS(Gamecube Operation System) you can boot Gamecube imports by first booting GCOS
   and then swap to your Gamecybe imports and let GCOS boot it.
   
   In fact the yaosm configuration disc doubles as a GCOS boot disc and it can be used to boot
   your Gamecube imports. 

   I also strongly recommend the GCOS multigame creator that you can find here here:
   http://wiinewz.com/forums/gcos/

   Apart from making it possible to put several GC backups on the same disc it boots the your imports.

Q: I'm planning to import games from USA and/or Japan and I live in Europe but I've heard that it
   can brick my Wii. Is that true?
A: Yes. Some Wii games contains firmware upgrades and getting a US or JAP upgrade on your PAL console
   can leave with everthing from a non working Wii to a Wii with duplicate News/Weather channels.

   Never ever use imported games unless you know what you are doing!
   
   To check what games are safe to run this page is a great resource: http://wiki.gbatemp.net/index.php?title=Wii_Region_Patcher_Compatibility_List

Q: Can you port yaosm to <insert any non-PIC chip here>?
A: I don't have enough time to maintain ports on non-PIC chips, however I'd love to see ports being made
   by others.

   yaosm 2.0 has been ported to work on Cyclowiz (SX28) by uncledim: http://www.teamcyclops.com/forum/showthread.php?t=1545
   
   With yaosm 3.0 most of the code is mn102 drivecode so porting yaosm 3.0 should be a LOT easier than
   previous versions. In fact it should be really easy to modify the OpenWii code to use the drivecode
   from yaosm and it's very likely that you'll see yaosm@openwii becoming a reality soon.

Q: What do you mean by "safe" configuration disc?
A: yaosm detects if the configuration disc has been inserted and only then will it allow changes to 
   the eeprom.

Q: Why isn't there a DMS version? I only found hex files for D2A and D2B.
A: The D2A version is also for DMS Wii's.

Q: Well, my DVD controller is a D2C, can I still use yaosm?
A: No, the D2C has closed the door for modchips that are designed for DMS/D2A/D2B Wii's however there
   are at least two commercial chips available for the D2C at the moment.

Q: How stealthy is yaosm really?
A: All commercial chips has claimed to be "stealth" but as some of you may know, every single chip
   (yaosm included) initially refused to run SMG. From a technical point of view the chips were not
   detected but the it was detected that SMG was run from backup which, to be honest, basicly is the
   same thing.
   
   There is no such thing as a 100% stealth chip because no one can predict what new firmwares and/or
   games can come up with. If you are concerned about stealth you should disable regionpatching. It's
   not very stealthy to run a game from a different region on your console.
   
Q: I was told the PICs used by yaosm can't be upgraded with a DVD, how come Wiinja Deluxe and now yaosm
   claims it can be DVD upgraded?
A: It's very true. The PIC code can not be upgraded. However yaosm 3.0 does most of it's "magic" with 
   mn102h code that is uploaded to the DVD-controller. By using a custom made patch algoritm it is possible
   to store patch data in the eeprom of the PIC chip and patch the mn102h code. This is of course limited
   by the size of the eeprom which is why I recommend the 12F683 chip that has twice the amount of eeprom
   compared to the 12F629/675 chips.
   
   Wiinja Deluxe uses a similar method for their upgrades.
   
Q: I did a DVD upgrade but now nothing works. I want my money back!
A: First of all, yaosm is free. I hope you didn't pay for it.
   Take a deep breath, count to ten, and then read carefully:
   - Power your Wii off. (not to standby, powerled should be red)
   - Power it on and pull the powerplug about 2 seconds after you powered it on.
   - Put the plug back and turn the Wii on again.
   - It should now load without any patchdata that may exist in the PIC eeprom.
   - Use the config disc to remove the corrupt upgrade from the PIC eeprom.
   - Power off and on again it should now work like a plain, non-upgraded, yaosm 3.0 again.
   
Q: I've got a Wii, chipped with yaosm 1.x/2.0. How do I use the DVD upgrade to upgrade it to 3.0?
A: You don't. You'll need an external programmer to reflash your chip to yaosm 3.0.

Q: My 16F628(non-A) doesn't work with the 16F628_628A hex?
A: Try the using the 16F627 hex. For some reason it seems to work better on the 16F628 chips.