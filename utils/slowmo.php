<?php

/*

Example input: (S01E02)

72758    pc
         cc

72760 cccpc cpccp ccpcc ccpcc pccpc cpccc pcccp ccpcc pcccp cccpc
      pccpc ccpcc cpccp ccpcc cpccc pccpc cpccc pcccp ccpcc pccpc

72810 cpccp cccpc ccpcc pccpc ccpcc cpccp ccp
      cccpc cpccp ccpcc ccpcc pccpc cpccc cpc

c means the field advances a frame, p that it is a duplicate, the empty lines are required separators

This is generated manually by looking at ShowFields and stepping frames, in case you were wondering.
      
Output:

fix = FixSlowMoI(, , 30000, pd = 0, f = [ \
	[1,2,3,4,6,7,9,10,12,13,15,16,17,18,20,21,23,24,26,27,29,30,31,33,34,35,37,38,40,41,43,44,45,47,48,49,51,52,54,55,57,58,59,61,62,63,65,66,68,69,71,72,73,75,76,77,79,80,82,83], \
	[0,1,3,4,6,7,8,10,11,12,14,15,17,18,20,21,22,24,25,26,28,29,31,32,34,35,36,38,39,40,42,43,45,46,48,49,51,52,53,54,56,57,59,60,62,63,65,66,67,68,70,71,73,74,76,77,79,80,81,82,84] \
	])

The two arrays select the c fields from the input list. 

Set start/end, adjust 30000 to a bigger value, keep or remove pd (pulldown, 0: none, 2: cppcc, 3: ccppc).

The goal is to match the input frame count.

*/

$s = file_get_contents($argv[1]);

$fc = [0, 0];
$fn = [[], []];

foreach(explode("\n", $s) as $i => $row)
{
	$f = $i % 3;
	
	if($f == 2) continue;
	
	for($j = 0; $j < strlen($row); $j++)
	{
		$c = $row[$j];
		
		if($c == 'c' || $c == 'C' || $c == 'p' || $c == 'P')
		{
			if($c == 'c' || $c == 'C')
			{
				$fn[$f][] = $fc[$f];
			}

			$fc[$f]++;
		}
	}
}

#print_r($fc);
#print_r($fn);

echo count($fn[0]).' '.count($fn[0]).PHP_EOL;
echo 'fix = FixSlowMoI(, , 30000, pd = 0, f = [ \\'.PHP_EOL;
echo "\t[".implode(',', $fn[0]).'], \\'.PHP_EOL;
echo "\t[".implode(',', $fn[1]).'] \\'.PHP_EOL;
echo "\t])".PHP_EOL;

if(count($fn[0]) != count($fn[1])) die('???');

?>