d2vpath="title_t00.d2v"
MPEG2Source(d2vpath,cpu=4)

# better match with the original
#ConvertBits(16).Levels(396, 1, 65280, 0, 60416, coring=false).ConvertBits(8, dither=1)

# better fill of the whole luma range
ConvertBits(16).Levels(396, 1, 65280, 0, 63488, coring=false).ConvertBits(8, dither=1)

#separatefields.lanczosresize(720,480).Histogram("levels", 10.0).showframenumber(x=5,y=475)
#separatefields.Histogram("levels", 10.0).showframenumber(x=5,y=475).selectevery(2, 1)
#separatefields.selectevery(2, 1)
#Histogram("levels", 10.0).showframenumber(x=5,y=475)
#showframenumber(x=5,y=475).separatefields.lanczosresize(720,480)
#deint2=yadifmod2(order=0)
#deint3=yadifmod2(order=1)
#deint2=separatefields.selectevery(2, 0).Spline64Resize(720,480)
#deint3=separatefields.selectevery(2, 1).Spline64Resize(720,480)
#TFM(d2v=d2vpath,clip2=deint2,clip3=deint3,mode=0,slow=2,cthresh=9,MI=80,PP=6,chroma=true,display=true,ovr="title_t00-tfm-ovr.txt")
#TDecimate(mode=0,hybrid=1,denoise=true,ovr="title_t00-tdec-ovr.txt")

#separatefields.selectevery(2, 1).Spline64Resize(720,480)