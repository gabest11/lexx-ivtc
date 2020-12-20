ffmpeg -hide_banner -i %1 -c copy -f mpeg2video %~n1.es
E:\tmp\media\util\dgmpgdec158.bak\DGIndex.exe -i %~n1.es -o %~n1 -exit