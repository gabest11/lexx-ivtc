d2vpath="title_t00.d2v"
MPEG2Source(d2vpath,cpu=4)
ConvertBits(16).Levels(396, 1, 65280, 0, 60416, coring=false).ConvertBits(8, dither=1)
#showframenumber(x=5,y=475).separatefields.lanczosresize(720,480)
deint2=yadifmod2(order=0)
deint3=yadifmod2(order=1)
TFM(d2v=d2vpath,clip2=deint2,clip3=deint3,mode=0,slow=2,cthresh=9,MI=80,PP=6,chroma=true,input="title_t00-tfm.txt",ovr="title_t00-tfm-ovr.txt")
# If your source is not anime or cartoon then add
# vfrDec=0  into the line below
TDecimate(mode=5,hybrid=2,denoise=true,vfrDec=0,input="title_t00-tdec.txt",tfmIn="title_t00-tfm.txt",mkvOut="title_t00-timecodes.txt",ovr="title_t00-tdec-ovr.txt")