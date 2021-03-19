<?php

if(!file_exists($argv[1])) die('check file name');

$title = preg_replace('/\\.[^\\.]+$/i', '', $argv[1]);

$cmd = <<<EOT
"e:\\tmp\\media\\util\\ffmpeg_x86\\bin\\ffmpeg.exe" -hide_banner
-i $title.avs
-map 0:v
-c:v huffyuv
-aspect 720:480
"$title-huffyuv.avi"
EOT;

$cmd = preg_replace('/[\r\n]+/', ' ', $cmd);

echo $cmd.PHP_EOL;
	
$ret = 0;
passthru($cmd, $ret);
if(!empty($ret)) die($ret);

$s = file_get_contents("$title-timecodes.txt");

$frames = [];

$pef = -1;

foreach(explode("\n", $s) as $row)
{
	$row = trim($row);
	
	if(!preg_match('/^([0-9]+),([0-9]+),([0-9\\.]+)/i', $row, $m)) continue;
	
	$sf = (int)$m[1];
	$ef = (int)$m[2];
	
	if($sf > $pef + 1)
	{
		$frames[] = ['sf' => $pef + 1, 'ef' => $sf - 1, 'fps_num' => 30000, 'row' => ''];
	}

	$pef = $ef;
	
	if($m[3] == '29.97') $fps_num = 30000;
	else if($m[3] == '23.976024') $fps_num = 24000;
	else if($m[3] == '17.982018') $fps_num = 18000;
	else die('unknown fps '.$m[3]);
	
	$frames[] = ['sf' => $sf, 'ef' => $ef, 'fps_num' => $fps_num, 'row' => $row];
}

$frames[] = ['sf' => $pef + 1, 'ef' => 1000000, 'fps_num' => 30000, 'row' => '']; // TODO: last frame number?

//

$fp = fopen("$title-ranges.txt", 'w');

$tfc = 0;

foreach($frames as $f)
{
	$fc = ($f['ef'] - $f['sf'] + 1) * 30000 / $f['fps_num'];
		
	fprintf($fp, "%d,%d,%.3f # %s\n", (int)$tfc, (int)($tfc + $fc + 0.5), $f['fps_num'] / 1001, $f['row']);

	$tfc += $fc;
}

fclose($fp);

// keyframes

$s = file_get_contents("$title-tfm-ovr.txt");

$keyframes = [];

preg_match_all('/([0-9]+),([0-9]+).*# *keyframe/im', $s, $m);

//print_r($m);

for($i = 0; $i < count($m[0]); $i++)
{
	$frame = (int)$m[1][$i];

	//echo $frame.' => ';
	
	$tfc = 0;

	foreach($frames as $f)
	{
		$fc = ($f['ef'] - $f['sf'] + 1) * 30000 / $f['fps_num'];
		
		//print_r($f);
		//print_r([$tfc, $tfc + $fc, (int)($tfc + $fc + 0.5)]);
	
		if((int)$tfc <= $frame && $frame < (int)($tfc + $fc + 0.5))
		{
			$vfrframe = (int)($f['sf'] + ($frame - $tfc) * $f['fps_num'] / 30000 + 0.5);
			//$vfrframe = ceil($f['sf'] + ($frame - $tfc) * $f['fps_num'] / 30000);
			$vfrtime = $vfrframe / 25; // ffmpeg defaults to 25 fps for image seqs
			
			$ms = (int)(($vfrtime * 1000) % 1000);
			$ss = $vfrtime % 60; $vfrtime /= 60;
			$mm = $vfrtime % 60; $vfrtime /= 60;
			$hh = $vfrtime;
			$t = sprintf("%d:%02d:%02d.%03d", $hh, $mm, $ss, $ms);
			
			//print_r($f);
			//print_r([$frame, $tfc, $tfc + $fc, (int)($tfc + $fc + 0.5), $f['sf'] + ($frame - $tfc) * $f['fps_num'] / 30000]);
		
			//echo $vfrframe.' '.$t.PHP_EOL;
			
			$keyframes[] = $t; //['f' => $vfrframe, 't' => $t];

			break;
		}
	
		$tfc += $fc;
	}
}

file_put_contents("$title-keyframes.txt", implode(PHP_EOL, $keyframes));

//

?>