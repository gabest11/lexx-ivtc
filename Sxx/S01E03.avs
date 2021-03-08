# Allience release (better bitrate) and the missing section from Koch's, cut to match Koch's audio track

c1 = MPEG2Source("..\S01(Alliance)\D03\title_t00.d2v",cpu=4)
#c2 = MPEG2Source("..\S01(Koch)\D03\title_t00p1.d2v",cpu=4).Letterbox(0,0,2,2)

# nothing to replace so far... only a placeholder

Trim(c1, 35, 169633) #+ Trim(c2, , ) + Trim(c1, , -0) 

deint2=yadifmod2(order=0)
deint3=yadifmod2(order=1)

TFM(clip2=deint2,clip3=deint3,mode=0,slow=2,cthresh=9,MI=80,PP=6,chroma=true,display=false,ovr="S01E03-tfm-ovr.txt")
TDecimate(mode=3,hybrid=2,denoise=true,vfrDec=0,mkvOut="S01E03-timecodes.txt",ovr="S01E03-tdec-ovr.txt")