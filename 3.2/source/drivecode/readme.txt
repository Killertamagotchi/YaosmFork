About building the drivecode
----------------------------

- Run make to assemble yaosm.S into two bin files (You'll need a binutils 2.17.5 port for this)
- Use makepatches.php to compare the new bin files with the original drivecode to create the patch data.
- Use makelarge.php to generate large_patch.asm which should be used if you compile yaosm30.bas with the dLargeChip option.

makepatches.php expects d2a_org.bin and d2b_org.bin which should be 243 bytes from the memory of your DVD controller
starting from 0x81586 for DMS/D2A and 0x81588 for D2B. Starting with yaosm 3.2 you should add 12 bytes of 0x00 to the
beginning of the files making them a total of 255 bytes each.

makelarge.php expects that d2a_patch.bin and d2b_patch.bin allready exist (created with makepatches.php)