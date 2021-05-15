<?php

/*

MODE 1

Example input: (S01E02)

72758    pc
         cc
72760 cccpc cpccp ccpcc ccpcc pccpc cpccc pcccp ccpcc pcccp cccpc
      pccpc ccpcc cpccp ccpcc cpccc pccpc cpccc pcccp ccpcc pccpc
72810 cpccp cccpc ccpcc pccpc ccpcc cpccp ccp
      cccpc cpccp ccpcc ccpcc pccpc cpccc cpc

c means the field advances a frame, p that it is a duplicate, the empty lines are required separators

This is generated manually by looking at ShowFields and stepping frames, in case you were wondering.

fix = FixSlowMoI(, , 30000, pd = 0, f = [ \
	[1,2,3,4,6,7,9,10,12,13,15,16,17,18,20,21,23,24,26,27,29,30,31,33,34,35,37,38,40,41,43,44,45,47,48,49,51,52,54,55,57,58,59,61,62,63,65,66,68,69,71,72,73,75,76,77,79,80,82,83], \
	[0,1,3,4,6,7,8,10,11,12,14,15,17,18,20,21,22,24,25,26,28,29,31,32,34,35,36,38,39,40,42,43,45,46,48,49,51,52,53,54,56,57,59,60,62,63,65,66,67,68,70,71,73,74,76,77,79,80,81,82,84] \
	])

The two arrays select the c fields from the input list. 

Set start/end, adjust 30000 to a bigger value, keep or remove pd (pulldown, 0: none, 2: cppcc, 3: ccppc).

The goal is to match the input frame count.

---

MODE 2

Example input: (S02E01)

8939 0
     1
8940 01244668901234567890123456789012346
     12345678901234567800224567890123456
8975 68800234567890123456789012345688002
     78901234567890224466890123456789012
9010 2456789012345678901
     3456789012446688012

The single digit numbers tell the frame number for each field, with rollover, the algorithm will correct it

fix = FixSlowMoI(, , 30000, pd = 0, f = [ \
	[0,0,4,1,6,5,7,7,8,9,11,11,12,13,15,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,38,40,39,42,42,44,43,46,46,48,47,50,49,52,51,54,53,56,55,58,57,60,59,62,61,64,63,66,65,68,67,69,69,70,71,73,73,74,75,77,77,78,79,81,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,100,102,101,104,104,106,105,108,108,110,109,112,112,114,113,116,115,118,117,120,119,122,121,124,123,126,125,128,127,130,129,131,131,132,133,135,135,136,137,139,139,140,141,143,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,162,164,163,166,166,168,167,170,170,172,171,174,174,176,175,178,177,179,179], [], \
	[1,2,4,7,8,11,12,15,16,18,20,22,24,26,28,30,32,34,36,39,40,43,44,47,48,50,52,54,56,58,60,62,64,66,68,71,72,75,76,79,80,83,84,86,88,90,92,94,96,98,100,103,104,107,108,111,112,115,116,118,120,122,124,126,128,130,132,135,136,139,140,143,144,147,148,150,152,154,156,158,160,162,164,167,168,171,172,175,176,179,180,182,185], \
	[0,2,4,7,8,11,12,15,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,71,72,75,76,79,80,83,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,118,120,122,124,126,128,130,132,135,136,139,140,143,144,147,148,150,152,154,156,158,160,162,164,166,168,170,172,174,176,178,180,182,185]
	])
	
It's a template you can put into your .avs after setting the correct start/end arguments.

First array will refer to all the good field pairs without gaps and dups. 

0,0 is frame 0
4,1 is frame 1
6,5 is frame 2
etc.

Where the same number repeats (0,0 or 7,7) there was only a single field available without a pair.

The third array will tell FixSlowMoI to apply a deinterlacer, which will interpolate the other field.

The forth array is the parity of the single field, top of bottom.

*/

$s = file_get_contents($argv[1]);

$mode = 0;
$tmp = [];
$frames = [];

$fc = [0, 0];
$fn = [[], []];

$t_last = -1;
$b_last = -1;
$t_offset = 0;
$b_offset = 0;
$field_base = 0;

foreach(explode("\n", $s) as $row)
{
	$row = preg_replace('/^ *# ?/', '', $row);
	$row = preg_replace('/ +/', ' ', $row);
	$row = preg_replace('/^[0-9]+ +/', '', $row); # number at the beginning of the line followed by a space is always a frame number (TODO: record it and output as the first argument)
	$row = str_replace(' ', '', $row);

	if(preg_match_all('/[cCpP]/', $row, $m))
	{
		if($mode == 2) die('mode?');
		$tmp[] = $m[0];
		$mode = 1;
	}
	else if(preg_match_all('/[0-9]/', $row, $m))
	{
		if($mode == 1) die('mode?');
		$tmp[] = $m[0];
		$mode = 2;
	}
	else 
	{
		$tmp = [];
		$mode = 0;
	}

	if(count($tmp) != 2) continue;

	if(count($tmp[0]) != count($tmp[1])) {print_r($tmp); die('???');}

	if($mode == 1)
	{
		for($j = 0; $j < 2; $j++)
		{
			for($i = 0; $i < count($tmp[0]); $i++)
			{
				$c = $tmp[$j][$i];
		
				if($c == 'c' || $c == 'C' || $c == 'p' || $c == 'P')
				{
					if($c == 'c' || $c == 'C')
					{
						$fn[$j][] = $fc[$j];
					}

					$fc[$j]++;
				}
			}
		}
	}
	else if($mode == 2)
	{
		for($i = 0; $i < count($tmp[0]); $i++)
		{
			$t = $tmp[0][$i];
			$b = $tmp[1][$i];
		
			if($t_last >= 5 && $t < 5) $t_offset += 10;
			if($b_last >= 5 && $b < 5) $b_offset += 10;
		
			$t_last = $t;
			$b_last = $b;
		
			if(!isset($frames[$t_offset + $t]['t']))
			{
				$frames[$t_offset + $t]['t'] = ($field_base + $i) * 2;
			}

			if(!isset($frames[$b_offset + $b]['b']))
			{
				$frames[$b_offset + $b]['b'] = ($field_base + $i) * 2 + 1;
			}
		}
	}
	
	$field_base += count($tmp[0]);
	
	$tmp = [];
}

$selectevery = [[], [], []]; // field, deinterlace, parity
$fc = 0;
$hastf = false;
$hasbf = false;

foreach($frames as $fields)
{
	if(!isset($fields['t']) && !isset($fields['b']))
	{
		print_r($fields);
		die('???');
	}
	
	if(isset($fields['t']) && isset($fields['b']))
	{
		$selectevery[0][] = $fields['t'];
		$selectevery[0][] = $fields['b'];
		$selectevery[1][] = $fc * 2 + 0;
		$selectevery[2][] = $fc * 2 + 0;
	}
	else if(isset($fields['t']))
	{
		$selectevery[0][] = $fields['t'];
		$selectevery[0][] = $fields['t'];
		$selectevery[1][] = $fc * 2 + 1;
		$selectevery[2][] = $fc * 2 + 0;

		$hastf = true;
	}
	else if(isset($fields['b']))
	{
		$selectevery[0][] = $fields['b'];
		$selectevery[0][] = $fields['b'];
		$selectevery[1][] = $fc * 2 + 1;
		$selectevery[2][] = $fc * 2 + 1;

		$hasbf = true;
	}
	
	$fc++;
}

if(!empty($fn[0]))
{
	echo 'fix = FixSlowMoI(, , 30000, pd = 0, f = [ \\'.PHP_EOL;
	echo "\t[".implode(',', $fn[0]).'], \\'.PHP_EOL;
	echo "\t[".implode(',', $fn[1]).'] \\'.PHP_EOL;
	echo "\t])".PHP_EOL;

	if(count($fn[0]) != count($fn[1])) die('???');
}

if(!empty($selectevery[0]))
{
	$f = ['['.implode(',', $selectevery[0]).'], []'];

	if($hastf || $hasbf)
	{
		$f[] = '['.implode(',', $selectevery[1]).']';

		if($hasbf)
		{
			$f[] = '['.implode(',', $selectevery[2]).']';
		}
	}

	echo 'fix = FixSlowMoI(, , 30000, pd = 0, f = [ \\'.PHP_EOL."\t".implode(", \\".PHP_EOL."\t", $f).' \\'.PHP_EOL."\t])".PHP_EOL;
}

?>