d2vpath="title_t00p1.d2v"
MPEG2Source(d2vpath,cpu=4)
Letterbox(0,0,2,2)
deint=yadifmod2()
TFM(d2v=d2vpath,clip2=deint,mode=0,slow=2,cthresh=9,MI=80,PP=6,chroma=true,display=true,ovr="title_t00p1-tfm-ovr.txt")
#
TDecimate(mode=0,hybrid=1,denoise=true,ovr="title_t00p1-tdec-ovr.txt")