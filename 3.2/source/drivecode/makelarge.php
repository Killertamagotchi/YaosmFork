<?php
	$bin = "d2a_patch.bin";
	$binfp = fopen($bin,"rb");
	$asm = "large_patch.asm";
	$asmfp = fopen($asm,"wb");
	fprintf($asmfp,"	ORG 0x300\r\n");
	$x=0;
	while(1)
	{
		$current = ord(fgetc($binfp));
		if(feof($binfp)) break;
		fprintf($asmfp,"	RETLW 0x%02X\r\n",$current);
		$x++;
	}
	fprintf($asmfp,"	RETLW 0xFF\r\n");
	fclose($binfp);
	echo $x . "\r\n";
	$x=0;
	$bin = "d2b_patch.bin";
	$binfp = fopen($bin,"rb");
	fprintf($asmfp,"	ORG 0x580\r\n");
	while(1)
	{
		$current = ord(fgetc($binfp));
		if(feof($binfp)) break;
		fprintf($asmfp,"	RETLW 0x%02X\r\n",$current);
		$x++;
	}
	fprintf($asmfp,"	RETLW 0xFF\r\n");
	fprintf($asmfp,"END\r\n");
	fclose($binfp);
	fclose($asmfp);
	echo $x;
?>