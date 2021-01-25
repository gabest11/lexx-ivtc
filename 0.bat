ffmpeg -hide_banner -i %1 -c copy -f mpeg2video %~n1.es
E:\tmp\media\util\AvisynthRepository_361\AVSPLUS_x86\plugins\DGIndex.exe -i %~n1.es -o %~n1 -exit