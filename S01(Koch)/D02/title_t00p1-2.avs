d2vpath="title_t00p1.d2v"
MPEG2Source(d2vpath,cpu=4)
Letterbox(0,0,2,2)
deint=yadifmod2(mode=0)
TFM(d2v=d2vpath,clip2=deint,mode=0,slow=2,cthresh=9,MI=80,PP=6,chroma=true,input="title_t00p1-tfm.txt",ovr="title_t00p1-tfm-ovr.txt")
TDecimate(mode=5,hybrid=2,denoise=true,vfrDec=0,input="title_t00p1-tdec.txt",tfmIn="title_t00p1-tfm.txt",mkvOut="title_t00p1-timecodes.txt",ovr="title_t00p1-tdec-ovr.txt")