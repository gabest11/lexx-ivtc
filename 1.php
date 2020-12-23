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
	
		if(!preg_match('/^([0-9]+) ([cpbnuhl]) \\+/i', $row, $m)) continue;
	
		$i = (int)$m[1];
	
		// ignore:
		// - unknown
		// - directly deinterlaced
		// - indirectly deinterlaced by MI level
		// - first of the scene (maybe check if it's type c, those are often single field and look ugly)

		if(!isset($frames[$i]['type']) 
		|| isset($frames[$i]['deint']) && $frames[$i]['deint']['value'] == '+' 
		|| isset($frames[$i]['MI'])
		|| isset($frames[$i]['first']))
		{
			continue;
		}
		
		// still auto-deinterlaced by TFM, examine the reason
	
		$bogusframes[$i] = $frames[$i];
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

?>