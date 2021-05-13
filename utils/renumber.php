<?php 

# adds an offset to the frame numbers in override files

$s = file_get_contents($argv[1]);
$n = (int)$argv[2];

foreach(explode("\n", $s) as $row)
{
	$row = trim($row);
	
	if(preg_match('/^(#? *)([0-9]+)[, ]([0-9]+)? *(.*)/', $row, $m))
	{
		if(!empty($m[3])) $row = $m[1].($m[2] + $n).','.($m[3] + $n).' '.$m[4];
		else $row = $m[1].($m[2] + $n).' '.$m[4];
	}

	echo $row.PHP_EOL;
	
}