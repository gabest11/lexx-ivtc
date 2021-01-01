d2vpath="title_t00p1.d2v"
MPEG2Source(d2vpath,cpu=4)
Letterbox(0,0,2,2)
deint=yadifmod2(mode=0)
TFM(d2v=d2vpath,clip2=deint,mode=0,slow=2,cthresh=9,PP=6,MI=80,chroma=true,micout=2,output="title_t00p1-tfm.txt",ovr="title_t00p1-tfm-ovr.txt")
TDecimate(mode=4,denoise=true,output="title_t00p1-tdec.txt")
crop(344,224,-344,-224)