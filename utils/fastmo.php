<?php

/*

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

Output:

fix = FixSlowMoI(, , 30000, pd = 0, f = [ \
	[0,0,4,1,6,5,7,7,8,9,11,11,12,13,15,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,38,40,39,42,42,44,43,46,46,48,47,50,49,52,51,54,53,56,55,58,57,60,59,62,61,64,63,66,65,68,67,69,69,70,71,73,73,74,75,77,77,78,79,81,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,100,102,101,104,104,106,105,108,108,110,109,112,112,114,113,116,115,118,117,120,119,122,121,124,123,126,125,128,127,130,129,131,131,132,133,135,135,136,137,139,139,140,141,143,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,162,164,163,166,166,168,167,170,170,172,171,174,174,176,175,178,177,179,179], [], \
	[1,2,4,7,8,11,12,15,16,18,20,22,24,26,28,30,32,34,36,39,40,43,44,47,48,50,52,54,56,58,60,62,64,66,68,71,72,75,76,79,80,83,84,86,88,90,92,94,96,98,100,103,104,107,108,111,112,115,116,118,120,122,124,126,128,130,132,135,136,139,140,143,144,147,148,150,152,154,156,158,160,162,164,167,168,171,172,175,176,179,180,182,185] \
	])
	
It's a template you can put into your .avs after setting the correct start/end arguments.

First array will refer to all the good field pairs without gaps and dups. 

0,0 is frame 0
4,1 is frame 1
6,5 is frame 2
etc.

Where the same number repeats (0,0 or 7,7) there was only a single field available without a pair.

The second array will tell FixSlowMoI to apply a deinterlacer, which will interpolate the other field.

*/

$s = file_get_contents($argv[1]);

$tmp = [];
$frames = [];

$t_last = -1;
$b_last = -1;
$t_offset = 0;
$b_offset = 0;

$field_base = 0;

foreach(explode("\n", $s) as $row)
{
	if(($pos = strpos($row, ' ')) !== false && strlen($row) > $pos + 1 && $row[$pos + 1] != ' ')
	{
		$row = substr($row, $pos + 1);
	}

	$row = str_replace(' ', '', $row);
	
echo $row.PHP_EOL;
	$row = trim($row);
	
#	if(($pos = strrpos($row, ' ')) !== false)
#	{
#		$row = substr($row, $pos + 1);
#	}
echo $row.PHP_EOL;
	if(!preg_match_all('/[0-9]/', $row, $m))
	{
		$tmp = [];
		continue;
	}
	
	$tmp[] = $m[0];
	
	if(count($tmp) != 2) continue;

	if(count($tmp[0]) != count($tmp[1])) {print_r($tmp); die('???');}
	
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
	
	$field_base += count($tmp[0]);
	
	$tmp = [];
}

$selectevery = [[], []];
$tfm = [];
$tfm_deint = [];
$fc = 0;

foreach($frames as $fields)
{
	if(isset($fields['t']) && isset($fields['b']))
	{
		$selectevery[0][] = $fields['t'];
		$selectevery[0][] = $fields['b'];
		$selectevery[1][] = $fc * 2 + 0;
		
		$tfm[] = 'c';
		$tfm_deint[] = '-';
	}
	else if(isset($fields['t']))
	{
		$selectevery[0][] = $fields['t'];
		$selectevery[0][] = $fields['t'];
		$selectevery[1][] = $fc * 2 + 1;
		
		$tfm[] = 'l';
		$tfm_deint[] = '+';
	}
	else if(isset($fields['b']))
	{
		$selectevery[0][] = $fields['b'];
		$selectevery[0][] = $fields['b'];
		$selectevery[1][] = $fc * 2 + 1; # TODO: * 3 + 2? may need to choose the second field for the deinterlacer, we'll see
		
		$tfm[] = 'h';
		$tfm_deint[] = '+';
	}
	else
	{
		print_r($fields);
		die('???');
	}
	
	$fc++;
}

echo 'fix = FixSlowMoI(, , 30000, pd = 0, f = [ \\'.PHP_EOL;
echo "\t[".implode(',', $selectevery[0]).'], [], \\'.PHP_EOL;
echo "\t[".implode(',', $selectevery[1]).'] \\'.PHP_EOL;
echo "\t])".PHP_EOL;
echo implode('', $tfm).PHP_EOL;
echo implode('', $tfm_deint).PHP_EOL;

?>