"e:\tmp\media\util\ffmpeg_x86\bin\ffmpeg.exe" -hide_banner -i "%1-1.avs" -c copy -f null - 
"e:\tmp\media\util\ffmpeg_x86\bin\ffmpeg.exe" -hide_banner -i "%1-2.avs" -map 0:v -c:v huffyuv -aspect 720:480 "%1-huffyuv.mkv"
"e:\tmp\media\util\TIVTC\Retreive Ranges\RetrieveRanges.exe" "%1-timecodes.txt" 29.970 200000 > "%1-ranges.txt"