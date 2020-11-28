<?php
	makepatch("d2a");
	makepatch("d2b");
	

function makepatch($chip)
{
	global $matching, $p, $added, $parr, $oldp;
	// Read original code
	$orgbin = $chip."_org.bin";
	$orgfp = fopen($orgbin,"rb");
	$x=0;
	while(1)
	{
		$current = ord(fgetc($orgfp));
		if(feof($orgfp)) break;
		$orgarr[$x++] = $current;
		echo dechex($current);
	}
	echo "\r\n" . $x . "\r\n";
	fclose($orgfp);

	// Read new code	
	$newbin = $chip.".bin";
	$newfp = fopen($newbin,"rb");
	$x=0;
	while(1)
	{
		$current = ord(fgetc($newfp));
		if(feof($newfp)) break;
		$newarr[$x++] = $current;
		echo dechex($current);
	}
	echo "\r\n" . $x . "\r\n";
	fclose($newfp);

	
	$patchasm = $chip."_patch.asm";
	$patchbin = $chip."_patch.bin";
	$patchfp = fopen($patchasm,"wb");
	$patchbinfp = fopen($patchbin,"wb");
	$org=0;
	$new=0;
	$p=0;
	$added=0;
	$matching=0;
	// 0-108 = Added code (-1)
	// 109-248 = Matching code (+108)
	// 249-254 = Not used (+248)
	// 255 = EOF
	while(1)
	{
		if($new>=sizeof($newarr)) break; // Exit if we've reached the end of the new code
		$current = $newarr[$new++];		// Read new code
		
		$forcereplace = false;
		if($org<(sizeof($orgarr)-1) && $matching==0 && $current==$orgarr[$org] && $newarr[$new] != $orgarr[$org+1])
		{
			$forcereplace = true;
		}
		
		if( $org>=sizeof($orgarr) || $forcereplace || $current!=$orgarr[$org] )		// Added or replaced code
		{
			StopMatching();
			if($added>108) StopAdded();
			if($added==0)
			{
				echo "ADDED:";
				$parr[$p] = 0;
				$oldp = $p++;			// Save new pos in array
			}
			printf("%02X",$current);
			$parr[$p++] = $current;		// Save diffing code to array
			$org++;						// Step forward
			$added++;					// Increase counter
		}
		else if(!$forcereplace && $current==$orgarr[$org])		// Matching code
		{
			StopAdded();
			if($matching>139) StopMatching();
			if($matching==0) echo "MATCHING:";
			printf("%02X",$current);
			$matching++;			// Increase counter
			$org++;					// Step forward in original code
		}
	}
	StopMatching();
	StopAdded();
	echo "\r\n" . $p . "\r\n";
	fprintf($patchfp,"	ORG 0x1A9\r\n");
	foreach($parr as $value)
	{
		fprintf($patchfp,"	RETLW 0x34%02X\r\n",$value);
		fputs($patchbinfp,chr($value),1);
	}
	fprintf($patchfp,"	RETLW 0x34FF\r\n");	// End of patch data
	fprintf($patchfp,"END\r\n");
	fclose($patchfp);
	fclose($patchbinfp);
	echo "MD5:".md5_file($newbin) . "\r\n";
}

	function StopMatching()
	{
		global $matching, $parr, $p;
		if($matching>0)		// Matching code previously
		{
			$parr[$p++] = $matching + 108;		// Save identcounter to patcharray
			echo "($matching)\r\n";
			$matching = 0;
		}
	}
	function StopAdded()
	{
		global $added, $parr, $oldp;
		if($added>0)		// Added code previously
		{
			$parr[$oldp] = $added - 1;		// Save addcounter to patcharray
			echo "($added)\r\n";
			$added = 0;
		}
	}
?>
