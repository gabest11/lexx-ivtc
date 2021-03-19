# Allience release (better bitrate) and the missing section from Koch's, cut to match Koch's audio track

c1 = MPEG2Source("..\S01(Alliance)\D02\title_t00.d2v",cpu=4)
c2 = MPEG2Source("..\S01(Koch)\D02\title_t00p1.d2v",cpu=4).Letterbox(0,0,2,2)
c3 = MPEG2Source("..\S01(Alliance)\D01\title_t00.d2v",cpu=4)

function FixSatellite(clip c)
{
	# we need to create 76 frames somehow
	
	# first get rid of the blue plasma thing shooting up from the planet
	
	c1 = Trim(c, 46715, 46752)
	c2 = c1.FreezeFrame(0, c1.FrameCount, 0).Crop(432, 0, 128, 128)
	Overlay(c1, c2, x = 432, y = 0, mode = "Blend")
	
	SeparateFields()
	# ivtc + double every frame
	SelectEvery(10, 0, 1, 0, 1, 2, 3, 2, 3, 6, 5, 6, 5, 8, 9, 8, 9)
	# pulldown
	SelectEvery(8, 0, 1, 2, 3, 2, 5, 4, 7, 6, 7)
	# got a few frames more, trim it down
	Weave().Trim(0, 75)
	AssumeFPS(30000, 1001)
	# ccppc
}

#FixSatellite2(c1)
#ShowFramenumber(x=5,y=25)
#return last

#0
#30355
#30539
#45031
#45120
#55290
#55379
#104819
#104880
#107667
#108035
#168046

Trim(c1, 15, 30369) + \
Trim(c2, 30355, 30538) + \
Trim(c1, 30554, 45045) + \
Trim(c3, 136067, 136155) + \
Trim(c1, 45135, 55304) + \
Trim(c3, 136067, 136155) + \
Trim(c1, 55394, 104818) + \
FixSatellite(c1) + \
Trim(c1, 104895, 107681) + \
Trim(c2, 107667, 108034) + \
Trim(c1, 108048, 168058)


deint2=yadifmod2(order=0)
deint3=yadifmod2(order=1)

TFM(clip2=deint2,clip3=deint3,mode=0,slow=2,cthresh=9,MI=80,PP=6,chroma=true,display=false,ovr="S01E02-tfm-ovr.txt")
TDecimate(mode=3,hybrid=2,denoise=true,vfrDec=0,mkvOut="S01E02-timecodes.txt",ovr="S01E02-tdec-ovr.txt")