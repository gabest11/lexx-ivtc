@echo off
ffmpeg.exe ^
-hide_banner ^
-i %1 ^
-map 0 ^
-c:v libx264 -profile:v high -preset:v veryslow -crf 18 -x264opts interlaced=1 ^
-c:a %3 ^
-aspect 4:3 ^
-movflags +faststart ^
%2