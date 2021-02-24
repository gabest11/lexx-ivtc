# Allience release (better bitrate) and the missing section from Koch's, cut to match Koch's audio track

c1 = MPEG2Source("..\S01(Alliance)\D04\title_t00.d2v",cpu=4)
c2 = MPEG2Source("..\S01(Koch)\D04\title_t00p1.d2v",cpu=4).Letterbox(0,0,2,2)

Trim(c1, 30, 75348) + Trim(c2, 75319, 75506) + Trim(c1, 75538, 107839) + Trim(c2, 107809, 107901) + Trim(c1, 107932, 158522) + Trim(c2, 158493, 158550) + Trim(c1, 158580, 167263)

deint2=yadifmod2(order=0)
deint3=yadifmod2(order=1)

TFM(clip2=deint2,clip3=deint3,mode=0,slow=2,cthresh=9,MI=80,PP=6,chroma=true,display=false,ovr="S01E04-tfm-ovr.txt")
TDecimate(mode=3,hybrid=2,denoise=true,vfrDec=0,mkvOut="S01E04-timecodes.txt",ovr="S01E04-tdec-ovr.txt")