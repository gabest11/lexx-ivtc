<?php

if(!file_exists($argv[1])) die('check file name');

$title = preg_replace('/\\.[^\\.]+$/i', '', $argv[1]);

$cthresh = 9;
$MI = isset($argv[2]) ? (int)$argv[2] : 80;
$PP = isset($argv[3]) ? (int)$argv[3] : 6;

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

file_put_contents($title.'-1.avs', $avs);

if(!file_exists("$title-tfm-ovr.txt")) file_put_contents("$title-tfm-ovr.txt", '');
if(!file_exists("$title-tdec-ovr.txt")) file_put_contents("$title-tdec-ovr.txt", '');
//if(!file_exists("$title-tdeint-ovr.txt")) file_put_contents("$title-tdeint-ovr.txt", '');

$cmd = <<<EOT
"e:\\tmp\\media\\util\\ffmpeg_x86\\bin\\ffmpeg.exe" -hide_banner
-i "$title-1.avs"
-c copy -f null -
EOT;

$cmd = preg_replace('/[\r\n]+/', ' ', $cmd);

$ret = 0;
passthru($cmd, $ret);
if(!empty($ret)) die($ret);

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

file_put_contents($title.'-2.avs', $avs);

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

$ret = 0;
passthru($cmd, $ret);
if(!empty($ret)) die($ret);

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