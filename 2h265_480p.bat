@echo off
ffmpeg.exe ^
-hide_banner ^
-i %1 ^
-pix_fmt yuv420p ^
-map 0:v ^
-c:v libx265 -preset %3 -crf %4 ^
-vf "scale=720:480:flags=lanczos" ^
-tune grain ^
-aspect 4:3 ^
-movflags +faststart ^
%2

rem S01E0102 -force_key_frames 0:01:01.8,0:47:00.92 ^
