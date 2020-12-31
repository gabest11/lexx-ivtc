<?php

if(!file_exists($argv[1])) die('check file name');

$title = preg_replace('/\\.[^\\.]+$/i', '', $argv[1]);

function sanitycheck($title, &$bogusframes)
{
	// find auto-deinterlaced frames that should be progressive

	$frames = [];

	foreach(explode("\n", file_get_contents("$title-tfm-ovr.txt")) as $row)
	{
		$row = trim($row);
	
		if(preg_match('/^([0-9]+)(,([0-9]+))? +([cpbnu]+)/i', $row, $m))
		{
			if(is_numeric($m[3])) 
			{
				if((int)$m[1] >= (int)$m[3]) {echo 'check row '.$row.PHP_EOL;}
				
				// should be one for every "scene change", but we basically mark every single one of them
				
				$frames[$m[1]]['first'] = true; 

			}
			
			if(empty($m[3])) $m[3] = $m[1];
		
			for($i = (int)$m[1], $j = (int)$m[3], $k = 0; $i <= $j; $i++)
			{
				if(isset($frames[$i]['type'])) die($row);
				
				$frames[$i]['type']['value'] = $m[4][$k];
				$frames[$i]['type']['row'] = $row;
		
				if(++$k == strlen($m[4])) $k = 0;
			}
		}
		else if(preg_match('/^([0-9]+)(,([0-9]+))? +([\\+\\-]+)/i', $row, $m))
		{
			if(is_numeric($m[3])) 
			{
				if((int)$m[1] >= (int)$m[3]) {echo 'check row '.$row.PHP_EOL;}
			}
			
			if(empty($m[3])) $m[3] = $m[1];
		
			for($i = (int)$m[1], $j = (int)$m[3], $k = 0; $i <= $j; $i++)
			{
				//if(isset($frames[$i]['deint'])) die($row);
				
				$frames[$i]['deint']['value'] = $m[4][$k];
				$frames[$i]['deint']['row'] = $row;
		
				if(++$k == strlen($m[4])) $k = 0;
			}
		}
		else if(preg_match('/^([0-9]+)(,([0-9]+))? +i +([0-9]+)/i', $row, $m))
		{
			if(empty($m[3])) $m[3] = $m[1];

			for($i = (int)$m[1], $j = (int)$m[3]; $i <= $j; $i++)
			{
				$frames[$i]['MI']['value'] = $m[4];
				$frames[$i]['MI']['row'] = $row;
			}
		}
	}

	$bogusframes = [];

	foreach(explode("\n", file_get_contents("$title-tfm.txt")) as $row)
	{
		$row = trim($row);

		if(!preg_match('/^([0-9]+) +([cpbnuhl]) +([\\+\\-]) +\\[([\-0-9]+)\\]/i', $row, $m)) continue;

		$i = (int)$m[1];
		
		if(isset($frames[$i]['type']))
		{
			if($m[3] == '-')
			{
				// first frame p and not deinterlaced
			
				if(isset($frames[$i]['first'])
				&& $frames[$i]['type']['value'] == 'p'
				&& isset($frames[$i]['deint']) && $frames[$i]['deint']['value'] == '-')
				{
					$bogusframes[$i] = $frames[$i];
				}
/*
				else if($m[4] >= 30 && !isset($frames[$i]['MI']) && !isset($frames[$i]['deint']))
				{
					$bogusframes[$i] = $frames[$i];
				}
*/				
			}
			else if($m[3] == '+' || $m[4] >= 60)
			{
				// ignore:
				// - first of the scene (maybe check if it's type c, those are often single field and look ugly)
				// - indirectly deinterlaced by MI level
				// - directly deinterlaced

				if(!isset($frames[$i]['first'])
				&& !isset($frames[$i]['MI'])
				&& !(isset($frames[$i]['deint']) && $frames[$i]['deint']['value'] == '+'))
				{
					// still auto-deinterlaced by TFM, examine the reason

					$bogusframes[$i] = $frames[$i];
				}
			}
		}
	}
}

$cthresh = 9;
$MI = 80;
$PP = 6;

// avs

$avs = <<<EOT
d2vpath="$title.d2v"
MPEG2Source(d2vpath,cpu=4)
deint=yadifmod2(mode=0)
TFM(d2v=d2vpath,clip2=deint,mode=0,slow=2,cthresh=$cthresh,MI=$MI,PP=$PP,chroma=true,display=true,ovr="$title-tfm-ovr.txt")
#TDecimate(mode=0,hybrid=1,denoise=true,ovr="$title-tdec-ovr.txt")
EOT;

if(!file_exists("$title.avs")) file_put_contents($title.'.avs', $avs);

// 1st pass

$avs = <<<EOT
d2vpath="$title.d2v"
MPEG2Source(d2vpath,cpu=4)
deint=yadifmod2(mode=0)
TFM(d2v=d2vpath,clip2=deint,mode=0,slow=2,cthresh=$cthresh,PP=$PP,MI=$MI,chroma=true,output="$title-tfm.txt",ovr="$title-tfm-ovr.txt")
TDecimate(mode=4,denoise=true,output="$title-tdec.txt")
crop(344,224,-344,-224)
EOT;

if(!file_exists("$title-1.avs")) file_put_contents("$title-1.avs", $avs);
if(!file_exists("$title-tfm-ovr.txt")) file_put_contents("$title-tfm-ovr.txt", '');
if(!file_exists("$title-tdec-ovr.txt")) file_put_contents("$title-tdec-ovr.txt", '');
//if(!file_exists("$title-tdeint-ovr.txt")) file_put_contents("$title-tdeint-ovr.txt", '');

$cmd = <<<EOT
"e:\\tmp\\media\\util\\ffmpeg_x86\\bin\\ffmpeg.exe" -hide_banner
-i "$title-1.avs"
-c copy -f null -
EOT;

$cmd = preg_replace('/[\r\n]+/', ' ', $cmd);

if(!file_exists("$title-tfm.txt") || !file_exists("$title-tdec.txt"))
{
	echo $cmd.PHP_EOL;
	
	$ret = 0;
	passthru($cmd, $ret);
	if(!empty($ret)) die($ret);
}

// sanity check

$bogusframes = [];

sanitycheck($title, $bogusframes);

$rows = [];

$typerow = '';

foreach($bogusframes as $i => $bf)
{
	if($typerow != $bf['type']['row'])
	{
		if(!empty($rows)) $rows[] = '';
		$rows[] = $bf['type']['row'].(isset($bf['deint']['row']) ? PHP_EOL.$bf['deint']['row'] : '');
		$rows[] = '';
		
		$typerow = $bf['type']['row'];
	}
	
	$s = ' '.$i.' '.$bf['type']['value'];
	
	if(isset($bf['deint'])) $s .= ' '.$bf['deint']['value'];
	if(isset($bf['MI'])) $s .= ' '.$bf['MI']['value'];
	
	$rows[] = $s;
}

file_put_contents("$title-bogusframes.txt", implode(PHP_EOL, $rows));

// 2nd pass

$avs = <<<EOT
d2vpath="$title.d2v"
MPEG2Source(d2vpath,cpu=4)
deint=yadifmod2(mode=0)
TFM(d2v=d2vpath,clip2=deint,mode=0,slow=2,cthresh=$cthresh,MI=$MI,PP=$PP,chroma=true,input="$title-tfm.txt",ovr="$title-tfm-ovr.txt")
# If your source is not anime or cartoon then add
# vfrDec=0  into the line below
TDecimate(mode=5,hybrid=2,denoise=true,vfrDec=0,input="$title-tdec.txt",tfmIn="$title-tfm.txt",mkvOut="$title-timecodes.txt",ovr="$title-tdec-ovr.txt")
EOT;

if(!file_exists("$title-2.avs")) file_put_contents("$title-2.avs", $avs);
if(!file_exists("$title-tfm-ovr.txt")) file_put_contents("$title-tfm-ovr.txt", '');
if(!file_exists("$title-tdec-ovr.txt")) file_put_contents("$title-tdec-ovr.txt", '');
//if(!file_exists("$title-tdeint-ovr.txt")) file_put_contents("$title-tdeint-ovr.txt", '');

$cmd = <<<EOT
"e:\\tmp\\media\\util\\ffmpeg_x86\\bin\\ffmpeg.exe" -hide_banner
-i $title-2.avs
-map 0:v
-c:v huffyuv
-aspect 720:480
"$title-huffyuv.mkv"
EOT;

$cmd = preg_replace('/[\r\n]+/', ' ', $cmd);

if(file_exists("$title-tfm.txt") && file_exists("$title-tdec.txt") 
&& (!file_exists("$title-timecodes.txt") || !file_exists("$title-huffyuv.mkv")))
{
	echo $cmd.PHP_EOL;
	
	$ret = 0;
	passthru($cmd, $ret);
	if(!empty($ret)) die($ret);
}

// ranges
/*
$eFrame = 1000000; // TODO

$cmd = <<<EOT
"e:\\tmp\\media\\util\\TIVTC\\Retreive Ranges\\RetrieveRanges.exe" 
"$title-timecodes.txt" 
29.970 
$eFrame
EOT;

$cmd = preg_replace('/[\r\n]+/', ' ', $cmd);

$output = '';
$ret = 0;
exec($cmd, $output, $ret);
if(!empty($ret)) die($ret);

file_put_contents("$title-ranges.txt", implode(PHP_EOL, $output));
*/

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