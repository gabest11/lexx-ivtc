<?php

$codec = !empty($argv[1]) ? $argv[1] : 'h265p10';
$preset = !empty($argv[2]) ? $argv[2] : 'veryslow';
$resolution = !empty($argv[3]) ? $argv[3] : '';
$height = $resolution;
if(preg_match('/[x:]([0-9]+)$/i', $height, $m)) $height = $m[1];

//

$exists = [];

foreach(scandir('.') as $fn)
{
	if(preg_match('/S0*([0-9]+)([ER])0*([0-9]+).+\\.mkv$/i', $fn, $m)
	&& strpos($fn, $codec) !== false
	&& strpos($fn, $preset) !== false
	&& strpos($fn, $height) !== false)
	{
		$exists[$m[2]][$m[1]][$m[3]] = true;
	}
}

print_r($exists);

$srcs = [
	'Sxx/S%02d/S%02dE%02d-huffyuv_1.50x_1080x720_ahq-12_tif16/%%06d.tif',
	'Sxx/S%02d/S%02dE%02d-huffyuv_1.50x_1080x720_ahq-13_png/%%06d.png',
	'Sxx/S%02d/S%02dE%02d-huffyuv_1.50x_1080x720_ahq-12_png/%%06d.png',
	'Sxx/S%02d/S%02dE%02d-huffyuv_1.50x_1080x720_ahq-11_png/%%06d.png'
	];
	

foreach([1 => 4, 2 => 20, 3 => 13, 4 => 24] as $season => $epcount)
{
	if(!empty($argv[4]) && $argv[4] != $season) continue;
	
	for($episode = 1; $episode <= $epcount; $episode++)
	{
		$dst = sprintf('S%02dE%02d.mkv', $season, $episode);
		
		echo $dst.PHP_EOL;
		
		$src = null;
		
		foreach($srcs as $tmp)
		{
			$tmp = sprintf($tmp, $season, $season, $episode);
			
			if(file_exists(sprintf($tmp, 0)))
			{
				$src = $tmp;
				break;
			}
		}

		$tmp = sprintf("Sxx/S%02d/S%02dE%02d-topaz-ahq.avs", $season, $season, $episode);

		if($season == 3)
		if(file_exists($tmp))
		{
			$src = $tmp;
		}
		
		if(empty($src)) die('no source');
	
		$cmd = sprintf('php 2.php "%s" "%s" %s %s %s', 
			$src, $dst, $codec, $preset, 
			!empty($resolution) ? $resolution : ($season == 3 ? 480 : 720));
	
		echo $cmd.PHP_EOL;
		
		if(file_exists($dst) || isset($exists['E'][$season][$episode])) {echo 'skip'.PHP_EOL; continue;}

		passthru($cmd);
	}
}

// S02/R01-R05

$srcs = [
	'Sxx/S%02d/S%02dR%02d-huffyuv_1.50x_1080x720_ahq-12_tif16/%%06d.tif',
	'Sxx/S%02d/S%02dR%02d-huffyuv_1.50x_1080x720_ahq-13_png/%%06d.png',
	'Sxx/S%02d/S%02dR%02d-huffyuv_1.50x_1080x720_ahq-12_png/%%06d.png',
	'Sxx/S%02d/S%02dR%02d-huffyuv_1.50x_1080x720_ahq-11_png/%%06d.png'
	];

foreach([2 => 5] as $season => $epcount)
{
	if(!empty($argv[4]) && $argv[4] != $season) continue;
	
	for($episode = 1; $episode <= $epcount; $episode++)
	{
		$dst = sprintf('S%02dR%02d.mkv', $season, $episode);
		
		echo $dst.PHP_EOL;
		
		$src = null;
		
		foreach($srcs as $tmp)
		{
			$tmp = sprintf($tmp, $season, $season, $episode);
			
			if(file_exists(sprintf($tmp, 0)))
			{
				$src = $tmp;
				break;
			}
		}

		
		$tmp = sprintf("Sxx/S%02d/S%02dR%02d-topaz-ahq.avs", $season, $season, $episode);

		if($season == 3)
		if(file_exists($tmp))
		{
			$src = $tmp;
		}
		
		if(empty($src)) die('no source');
	
		$cmd = sprintf('php 2.php "%s" "%s" %s %s %s', 
			$src, $dst, $codec, $preset, 
			!empty($resolution) ? $resolution : ($season == 3 ? 480 : 720));
	
		echo $cmd.PHP_EOL;
	
		if(file_exists($dst) || isset($exists['R'][$season][$episode])) {echo 'skip'.PHP_EOL; continue;}

		passthru($cmd);
	}
}

?>