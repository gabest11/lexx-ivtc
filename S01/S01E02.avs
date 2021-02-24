# Allience release (better bitrate) and the missing section from Koch's, cut to match Koch's audio track

c1 = MPEG2Source("..\S01(Alliance)\D02\title_t00.d2v",cpu=4)
c2 = MPEG2Source("..\S01(Koch)\D02\title_t00p1.d2v",cpu=4).Letterbox(0,0,2,2)

Trim(c1, 15, 107681) + Trim(c2, 107667, 108034) + Trim(c1, 108048, 168058)

deint2=yadifmod2(order=0)
deint3=yadifmod2(order=1)

TFM(clip2=deint2,clip3=deint3,mode=0,slow=2,cthresh=9,MI=80,PP=6,chroma=true,display=true,ovr="S01E02-tfm-ovr.txt")
#TDecimate(mode=3,hybrid=2,denoise=true,vfrDec=0,mkvOut="S01E02-timecodes.txt",ovr="S01E02-tdec-ovr.txt")