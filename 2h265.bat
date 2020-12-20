@echo off
ffmpeg.exe ^
-hide_banner ^
-colorspace bt709 ^
-i %1 ^
-pix_fmt yuv420p ^
-map 0:v ^
-c:v libx265 -preset %3 -crf %4 ^
-vf "scale=960:720:flags=lanczos" ^
-tune grain ^
-aspect 4:3 ^
-movflags +faststart ^
%2

rem S02D01 -force_key_frames 1:01.8,46:13.12,47:12.04,48:13.88,1:32:46.32 ^
rem S02D02 -force_key_frames 1:02.0,47:12.32,48:13.92 ^

