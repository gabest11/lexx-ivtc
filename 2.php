<?php

$src = $argv[1];
$dst = $argv[2];
$codec = $argv[3];
$preset = $argv[4];
$resolution = !empty($argv[5]) ? $argv[5] : 720;
$crf = !empty($argv[6]) ? $argv[6] : ($codec == 'h265' ? 19 : 17);
$tune = !empty($argv[7]) ? $argv[7] : 'grain';
$keyframes = '';
$timecodes = '';
$audio = [];
$subtitle = [];
$about = dirname(__FILE__).'/about.txt';
$title = '';

$dst = preg_replace('/\\.mkv$/i', '-'.$codec.$preset.preg_replace('/(([0-9]+):)?([0-9]+)$/', '\\3', $resolution).'crf'.$crf.'.mkv', $dst);

$resolution = explode(':', $resolution);

if(count($resolution) == 1 && is_numeric($resolution[0]))
{
	$h = (int)$resolution[0];
	
	if($h == 480 || $h == 576)
	{
		$resolution = [720, $h];
	}
	else
	{
		//$resolution = [$h * 4 / 3, $h];
		$resolution = [-1, $h];
	}
}

function is51($fn)
{
	$str = shell_exec('ffprobe -hide_banner -show_streams "'.$fn.'" -print_format json');
	$obj = json_decode($str, true);
	return $obj['streams'][0]['channels'] == 6;
}			

if(preg_match('/(.+title_t[0-9]+[^-]*-)/i', $src, $m)
|| preg_match('/(.+S[0-9]+E[0-9]+-)/i', $src, $m))
{
	$fn = $m[1].'keyframes.txt';

	if(file_exists($fn))
	{
		$keyframes = [];	
	
		foreach(explode("\n", file_get_contents($fn)) as $row)
		{
			$row = trim($row);
			if(empty($row)) continue;
			$keyframes[] = $row;
		}

		$keyframes = implode(',', $keyframes);
	}

	$fn = $m[1].'timecodes.txt';
	
	if(file_exists($fn)) $timecodes = $fn;
	
	$fn = $m[1].'tfm-ovr.txt';
	
	if(file_exists($fn)) $tfm_ovr = $fn;
	
	$fn = $m[1].'tdec-ovr.txt';
	
	if(file_exists($fn)) $tdec_ovr = $fn;
	
	foreach(['eng', 'hun', 'fra', 'rus'] as $lang)
	{
		$fn2 = rtrim($m[1], '-');
		
		foreach(['mka', 'wav'] as $format)
		{
			$fn = $fn2.'_'.$lang.'.'.$format;
			
			if(file_exists($fn)) $audio[] = ['fn' => $fn, 'lang' => $lang, 'format' => $format, 'is51' => $format == 'wav' && is51($fn)];
		
			for($i = 1; ; $i++)
			{
				$fn = $fn2.'_'.$lang.$i.'.'.$format;
			
				if(!file_exists($fn)) break;
				
				$audio[] = ['fn' => $fn, 'lang' => $lang, 'format' => $format, 'is51' => $format == 'wav' && is51($fn)];
			}
		}
		
		foreach(['mks', 'srt', 'sub', 'ssa', 'ass'] as $format)
		{
			$fn = $fn2.'_'.$lang.'.'.$format;

			if(file_exists($fn)) $subtitle[] = ['fn' => $fn, 'lang' => $lang, 'format' => $format];
		
			for($i = 1; ; $i++)
			{
				$fn = $fn2.'_'.$lang.$i.'.'.$format;
			
				if(!file_exists($fn)) break;
			
				$subtitle[] = ['fn' => $fn, 'lang' => $lang, 'format' => $format];
			}
		}
	}
}

if(!empty($tfm_ovr) && file_exists($tfm_ovr))
{
	foreach(explode("\n", file_get_contents($tfm_ovr)) as $row)
	{
		if(!preg_match('/^# *S([0-9]+)E([0-9]+) +-?(.+)$/i', $row, $m)) continue;
		
		$title = sprintf("Lexx S%02dE%02d - %s", (int)$m[1], (int)$m[2], trim($m[3]));
		
		break;
	}
}

$cmd = [];

$cmd[] = 'ffmpeg -hide_banner';
if($resolution[1] >= 720) $cmd[] = '-colorspace bt709';
if(preg_match('/^(.+):([0-9]+)$/i', $src, $m)) {$src = $m[1]; $cmd[] = '-start_number '.$m[2];}
$cmd[] = '-i "'.$src.'"';
foreach($audio as $a) $cmd[] = ($a['is51'] ? '-channel_layout 5.1 ' : '').'-i "'.$a['fn'].'"';
foreach($subtitle as $s) $cmd[] = '-i "'.$s['fn'].'"';
if(strpos($codec, 'p10') !== false) $cmd[] = '-pix_fmt yuv420p10le';
else $cmd[] = '-pix_fmt yuv420p';
$cmd[] = '-map 0:v';
foreach($audio as $index => $a) $cmd[] = '-map '.($index + 1).':a';
foreach($subtitle as $index => $s) $cmd[] = '-map '.($index + count($audio) + 1).':s';
$cmd[] = '-map_chapters -1';
$cmd[] = '-c copy';
foreach($audio as $index => $a) {$cmd[] = '-metadata:s:a:'.$index.' language='.$a['lang']; if($a['format'] == 'wav') $cmd[] = '-c:a:'.$index.' aac';}
foreach($subtitle as $index => $s) {$cmd[] = '-metadata:s:s:'.$index.' language='.$s['lang'];}
if($codec == 'h264') $cmd[] = '-c:v libx264 -profile:v high -level:v 4.1';
else if($codec == 'h264p10') $cmd[] = '-c:v libx264 -profile:v high10 -level:v 4.1';
else if($codec == 'h265') $cmd[] = '-c:v libx265';
else if($codec == 'h265p10') $cmd[] = '-c:v libx265 -profile:v main10';
$cmd[] = '-preset '.$preset.' -crf '.$crf;
$cmd[] = '-vf "scale='.implode(':', $resolution).':flags=lanczos"';
if(!empty($tune) && $tune != 'notune') $cmd[] = '-tune '.$tune;
$cmd[] = '-aspect 4:3';
$cmd[] = '-movflags +faststart';
if(!empty($keyframes)) $cmd[] = '-force_key_frames '.$keyframes;
$cmd[] = '-metadata title="'.$title.'"';
$cmd[] = '-metadata description="https://github.com/gabest11/lexx-ivtc" ';
$cmd[] = '-metadata:s title= ';
/*
// does not work correctly, ffmpeg chops off the audio early, calculated from the vfr rate, do a 2pass
if(!empty($timecodes) && preg_match('/# TDecimate Mode [0-9]+: +Last Frame = ([0-9]+)/i', file_get_contents($timecodes), $m))
{
	$cmd[] = '-frames:v '.($m[1] + 1);
}
*/
$cmd[] = '"'.$dst.'"';

// TODO: chapters for keyframes

$cmd = implode(' ', $cmd);

echo $cmd.PHP_EOL;

$ret = 0;
passthru($cmd, $ret);
if(!empty($ret)) die($ret);

if(!empty($timecodes))
{

$dstvfr = preg_replace('/\\.mkv$/i', '-vfr.mkv', $dst);

$cmd = <<<EOT
E:\\tmp\\media\\util\\mkvtoolnix\\mkvmerge.exe ^
--output "$dstvfr" ^
--language 0:und ^
--default-track 0:yes ^
--default-track 1:yes ^
--timestamps "0:$timecodes" ^
--fix-bitstream-timing-information 0:1 ^
--attachment-description "VFR timecodes" ^
--attachment-mime-type text/plain ^
--attach-file "$timecodes" ^

EOT;

foreach($subtitle as $index => $s) 
{
	$cmd .= '--default-track '.($index + count($audio) + 1).':no ^'.PHP_EOL;
}

if(file_exists($tfm_ovr))
{
$cmd .= <<<EOT
--attachment-description "TFM overrides" ^
--attachment-mime-type text/plain ^
--attach-file "$tfm_ovr" ^

EOT;
}

if(file_exists($tdec_ovr))
{
$cmd .= <<<EOT
--attachment-description "TDecimate overrides" ^
--attachment-mime-type text/plain ^
--attach-file "$tdec_ovr" ^

EOT;
}

if(file_exists($about))
{
$cmd .= <<<EOT
--attachment-description "About this release" ^
--attachment-mime-type text/plain ^
--attach-file "$about" ^

EOT;
}

$cmd .= '"'.$dst.'"';

$cmd = preg_replace('/[\r\n]+/', ' ', $cmd);

echo $cmd.PHP_EOL;
	
$ret = 0;
passthru($cmd, $ret);
if(!empty($ret)) die(sprintf("%d\n", $ret));

echo 'del '.$dst.PHP_EOL;

if(!unlink($dst)) echo 'cannot delete...'.PHP_EOL;
}

?>