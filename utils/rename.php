<?php

# renames numbered pngs from start by an offset

# if the destination png exists (negative offset) it will exit with a ??? message

$i = (int)$argv[1];
$n = (int)$argv[2];

$imax = -1;
	
foreach(scandir('.') as $fn)
{
	if(!preg_match('/^0*([0-9]+)\\.png$/i', $fn, $m)) continue;

	$imax = max($imax, (int)$m[1]);
}

if($n < 0)
{
	for(; $i <= $imax; $i++)
	{
		$oldfn = sprintf("%06d.png", $i);
		$newfn = sprintf("%06d.png", $i + $n);
	
		echo "rename($oldfn, $newfn);".PHP_EOL;

		if(!file_exists($oldfn)) die('???');
	
		if(file_exists($newfn)) unlink($newfn);
		
		rename($oldfn, $newfn);
	}
}
else
{
	for($j = $i, $i = $imax; $i >= $j; $i--)
	{
		$oldfn = sprintf("%06d.png", $i);
		$newfn = sprintf("%06d.png", $i + $n);
	
		echo "rename($oldfn, $newfn);".PHP_EOL;

		if(!file_exists($oldfn)) die('???');
		
		rename($oldfn, $newfn);
	}
}

?>