c1 = MPEG2Source("..\S04(Acorn)\D03\title_t00.d2v",cpu=4)
c2 = MPEG2Source("..\S04(Acorn)\D04\title_t01.d2v",cpu=4)

Trim(c1, 0, 11209) + Trim(c2, 18410, 18531) + Trim(c1, 11332, -0)

deint2=yadifmod2(order=0)
deint3=yadifmod2(order=1)

TFM(clip2=deint2,clip3=deint3,mode=0,slow=2,cthresh=9,MI=80,PP=6,chroma=true,display=false,ovr="S04E05-tfm-ovr.txt")
TDecimate(mode=3,hybrid=2,denoise=true,vfrDec=0,mkvOut="S04E05-timecodes.txt",ovr="S04E05-tdec-ovr.txt")