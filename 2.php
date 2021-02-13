<?php

$src = $argv[1];
$dst = $argv[2];
$codec = $argv[3];
$preset = $argv[4];
$resolution = !empty($argv[5]) ? $argv[5] : 720;
$crf = !empty($argv[6]) ? $argv[6] : ($codec == 'h265' ? 20 : 17);
$tune = !empty($argv[7]) ? $argv[7] : 'grain';
$keyframes = '';
$timecodes = '';
$audio = [];

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
		$resolution = [$h * 4 / 3, $h];
	}
}

if(preg_match('/(.+title_t[0-9]+[^-]*-)/i', $src, $m))
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
	
	foreach(['eng', 'hun', 'rus'] as $lang)
	{
		$fn2 = rtrim($m[1], '-');
	
		$fn = $fn2.'_'.$lang.'.mka';

		if(file_exists($fn)) $audio[] = $fn;
		
		for($i = 1; ; $i++)
		{
			$fn = $fn2.'_'.$lang.$i.'.mka';
			
			if(!file_exists($fn)) break;
			
			$audio[] = $fn;
		}
	}
}

$cmd = [];

$cmd[] = 'ffmpeg -hide_banner';
if($resolution[1] >= 720) $cmd[] = '-colorspace bt709';
$cmd[] = '-i "'.$src.'"';
foreach($audio as $a) $cmd[] = '-i "'.$a.'"';
$cmd[] = '-pix_fmt yuv420p';
$cmd[] = '-map 0:v';
foreach($audio as $index => $a) $cmd[] = '-map '.($index + 1).':a';
$cmd[] = '-c copy';
if($codec == 'h264') $cmd[] = '-c:v libx264 -profile:v high -level:v 4.1';
else if($codec == 'h265') $cmd[] = '-c:v libx265';
$cmd[] = '-preset '.$preset.' -crf '.$crf;
$cmd[] = '-vf "scale='.implode(':', $resolution).':flags=lanczos"';
if(!empty($tune) && $tune != 'notune') $cmd[] = '-tune '.$tune;
$cmd[] = '-aspect 4:3';
$cmd[] = '-movflags +faststart';
if(!empty($keyframes)) $cmd[] = '-force_key_frames '.$keyframes;
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
--timestamps "0:$timecodes" ^
--fix-bitstream-timing-information 0:1 ^
--attachment-description "VFR timecodes" ^
--attachment-mime-type text/plain ^
--attach-file "$timecodes" ^

EOT;

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

$cmd .= '"'.$dst.'"';

$cmd = preg_replace('/[\r\n]+/', ' ', $cmd);

echo $cmd.PHP_EOL;
	
$ret = 0;
passthru($cmd, $ret);
if(!empty($ret)) die($ret);

unlink($dst);
}

?>