@echo off
ffmpeg.exe ^
-hide_banner ^
-i %1 ^
-pix_fmt yuv420p ^
-map 0:v ^
-c:v libx264 -profile high -level 4.1 -preset %3 -crf %4 ^
-vf "scale=720:480:flags=lanczos" ^
-aspect 4:3 ^
-movflags +faststart ^
%2

rem -force_key_frames 1:01.8,47:08.36,48:11.52 ^
rem -ss %5 ^
rem -tune grain ^
