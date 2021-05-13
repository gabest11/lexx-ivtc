Import("../../common.avsi")

# Allience release (better bitrate) and the missing section from Koch's, cut to match Koch's audio track

c1 = MPEG2Source("..\..\S01(Alliance)\D02\title_t00.d2v",cpu=4)
c2 = MPEG2Source("..\..\S01(Koch)\D02\title_t00p1.d2v",cpu=4).Letterbox(0,0,2,2)
c3 = MPEG2Source("..\..\S01(Alliance)\D01\title_t00.d2v",cpu=4)

function FixSatellite(clip c)
{
	# we need to create 76 frames somehow
	
	# first get rid of the blue plasma thing shooting up from the planet
	
	c1 = Trim(c, 46715, 46752)
	c2 = c1.FreezeFrame(0, c1.FrameCount, 0).Crop(432, 0, 128, 128)
	Overlay(c1, c2, x = 432, y = 0, mode = "Blend")
	
	SeparateFields()
	# ivtc + double every frame
	SelectEvery(10, 0,1, 0,1, 2,3, 2,3, 6,5, 6,5, 8,9, 8,9)
	# pulldown
	SelectEvery(8, 0,1, 2,3, 2,5, 4,7, 6,7)
	# got a few frames more, trim it down
	Weave().Trim(0, 75)
	AssumeFPS(30000, 1001)
	# ccppc
	
	# MFlowFps looks strange here, the satellite moves very slowly and only interpolated in larger blocks, its parts advance with a 1 pixel difference
}

#0
#14315 moth landing in better quality, but not zoomed in that much
#14553
#30355 encoding error
#30539
#45031 tunnel in better quality
#45120
#55290 tunnel again
#55379
#104819 satellites
#104880
#107667 encoding error
#108035
#168046

Trim(c1, 15, 14329) + \
Trim(c3, 110947, 111169) + \
Trim(c1, 14553, 30369) + \
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

# Acorn's frame numbering from here

function FixShower(clip c)
{
	# 21430,21754: 325 frames

	last = c
	
	f1 = FixSlowMoI(21430, 21559, pd = 0, f = [ \
		[1,3,5,6,9,10,13,14,16,18,20,21,24,25,27,29,31,32,34,36,38,39,41,43,46,47,48,49,51,53,55,56,58,60,62,63,66,67,69,71,73,74,76,78,80,82,84,85,87,89,91,92,95,97,99,100,102,103,105,107,110,111,113,114,117,118,120,121,124,125,127,129], \
		[1,2,5,6,8,10,12,13,16,17,19,21,23,25,26,28,30,31,34,36,37,39,41,42,45,46,48,49,51,52,54,56,58,59,61,63,65,67,69,70,72,74,76,77,80,81,83,85,87,88,90,92,95,97,98,99,102,103,105,106,109,110,112,114,116,117,120,121,123,125,127,128] \
		])
	
	f2 = FixSlowMoI(21530, 21702, pd = 0, f = [ \
		[1,2,4,7,8,10,12,13,15,17,19,20,22,24,26,27,30,31,33,35,37,39,41,42,44,46,48,49,52,53,55,57,59,60,62,64,66,67,69,71,73,74,77,78,80,82,84,85,87,89,91,92,94,96,98,99,102,103,105,107,109,110,112,114,116,117,119,121,123,125,127,128,130,132,134,136,137,139,141,143,145,146,148,150,152,153,155,157,159,160,162,164,166,167,170,171], \
		[0,2,4,6,8,9,11,13,15,16,18,20,22,23,26,27,29,31,33,34,37,38,40,42,44,45,47,49,51,53,55,56,58,60,62,63,65,67,69,70,73,74,76,78,80,81,83,85,87,88,90,92,94,95,98,99,101,103,105,106,108,110,112,113,115,117,119,120,123,125,126,128,130,131,133,135,137,139,140,142,144,146,148,149,151,153,155,156,158,160,162,163,165,167,169,170] \
		])

	f3 = FixSlowMoI(21655, 21754, pd = 0, f = [ \
		[0,2,3,5,7,9,11,12,14,16,18,20,21,23,25,27,28,30,32,34,36,37,39,41,43,44,46,48,50,51,54,55,57,58,60,62,64,65,67,69,71,72,74,76,78,79,82,83,85,87,89,90,92,94,97,98,99], \
		[0,1,3,5,6,8,10,12,14,15,17,19,21,23,24,26,28,30,32,33,35,37,39,40,42,44,46,47,50,51,53,55,56,57,60,61,63,65,67,68,70,72,74,75,78,79,81,83,85,86,88,90,92,93,96,97,99] \
		])
		
	# not using FixSlowMoI time stretching or pulldown, the three clips must be joined first

	Trim(f1, 0, 15) + \
	Trim(f1, 16, 16).nnedi3 + \
	Trim(f1, 17, 59) + \
	Trim(f2, 5, 80) + \
	Trim(f3, 12, 0)

	# 181 frames
	
	# flowing water is a difficult task...
	#super = MSuper(pel=4, hpad=0, vpad=0)
	#backward_vec = MAnalyse(super, blksize=32, overlap=4, isb = true, search=3)
	#forward_vec = MAnalyse(super, blksize=32, overlap=4, isb = false, search=3)
	super = MSuper(pel=1, hpad=0, vpad=0)
	backward_vec = MAnalyse(super, blksize=32, isb = true, search=0, searchparam=1)
	forward_vec = MAnalyse(super, blksize=32, isb = false, search=0, searchparam=1)
	# 50% speed, 360 frames, only every other frame is blended, but cannot slow down the whole clip, it is a bit too much
	#MFlowFps(super, backward_vec, forward_vec, num=2*FramerateNumerator(last), den=FramerateDenominator(last))
	# 55% speed, exactly 325 frames
	#MFlowFps(super, backward_vec, forward_vec, num=54000, den=1001)
	# 70% speed, 260 frames, needs pulldown
	MFlowFps(super, backward_vec, forward_vec, num=43170, den=1001)

	# 260 frames

	SeparateFields
	SelectEvery(8, 0,1, 2,3, 2,5, 4,7, 6,7)
	Weave
	
	# 325 frames again
	
	AssumeFPS(c)
}

# cogwheels spinning up 

fix2 = FixSlowMoI(88173, 88227, 37000, f = [ \
	[0,1,2,4,6,7,8,10,12,13,15,16,18,19,21,22,24,25,27,29,30,32,34,35,37,38,40,41,43,44,46,47,49,51,52,54], \
	[0,1,2,4,5,7,8,9,11,12,14,15,17,19,21,22,24,25,27,28,30,31,33,34,36,37,39,41,43,44,46,47,49,50,52,53] \
	])

# more spinning wheels

fix3 = FixSlowMoI(88228, 88272, 37000, f = [ \
	[0,1,2,3,4,5,6,8,9,11,12,14,15,17,19,21,22,24,25,27,29,31,32,34,35,37,39,41,42,44], \
	[0,1,2,3,4,5,6,7,8,10,12,14,15,17,18,20,22,24,25,27,28,30,32,33,35,37,38,40,41,43] \
	])

# disc on a slice of Kai's body (same method)

fix4 = FixSlowMoI(130265, 130342, 37000, f = [ \
	[0,1,2,4,6,7,9,11,12,14,15,17,18,20,21,23,24,26,27,29,31,32,34,36,37,39,40,42,43,45,46,48,49,51,52,54,56,57,59,61,62,64,65,67,68,70,71,73,74,76,77], \
	[0,1,2,4,5,7,8,10,11,13,14,16,18,19,21,23,24,26,27,29,30,32,33,35,36,38,39,41,43,44,46,48,49,51,52,54,55,57,58,60,61,63,64,66,68,69,71,73,74,76,77] \
	])

# Zev on floor tile switch thingy (bg is a little bent in two frames, mv_search = 7 maybe?)

fix5 = FixSlowMoI(60387, 60416, 35500, f = [ \
	[1,2,3,5,6,8,9,11,12,13,15,16,17,19,20,22,23,25,26,28,29], \
	[0,2,3,4,6,7,8,10,11,13,14,16,17,19,20,21,23,24,25,27,28] \
	])

# first conveyor belt scene (side sync, amazingly this also makes mid row go in sync)

#fix6 = FixSlowMoI(3661, 3675, 53000, pd = 0, f = [ \
fix6 = FixSlowMoI(3661, 3675, 41500, f = [ \
	[0,2,3,5,7,8,10,12,13], \
	[0,1,3,5,6,8,10,12,13] \
	])
	
# Zev in her dream land

fix7 = FixSlowMoI(79962, 80058, 40600, pd = 0, f = [ \
	[1,2,3,4,6,7,9,10,11,13,14,15,17,18,19,21,22,23,25,26,28,29,30,31,33,34,36,37,38,39,41,42,44,45,46,47,49,50,52,53,54,55,57,58,60,61,62,63,65,66,68,69,70,71,73,74,76,77,78,79,81,82,84,85,86,87,89,90,92,93,94,96], \
	[0,1,3,4,6,7,8,9,11,12,14,15,16,17,19,20,22,23,24,25,27,28,30,31,32,33,35,36,38,39,40,41,43,44,46,47,48,50,51,52,54,55,56,58,59,60,62,63,64,66,67,68,70,71,73,74,75,76,78,79,81,82,83,84,86,87,89,90,91,92,94,95] \
	])

# Stanley's torture #1

fix8 = FixSlowMoI(91648, 91707, 44100, f = [ \
	[1,3,5,7,8,10,12,14,15,18,19,21,23,25,26,29,30,32,34,36,37,39,41,43,45,47,48,50,52,54,55,58,59], \
	[0,3,4,6,8,10,11,13,15,17,19,21,22,24,26,28,29,32,33,35,37,39,40,43,44,46,48,50,51,53,55,57,59] \
	])

# Stanley's torture #2

fix9 = FixSlowMoI(92164, 92206, 44100, f = [ \
	[0,2,4,5,7,9,11,13,15,16,18,20,22,24,26,27,29,31,33,34,37,38,40,42], \
	[0,1,3,5,7,8,11,12,14,16,18,19,22,23,25,27,29,30,32,34,36,38,40,41] \
	])

function FixTowers(clip c)
{
	last = c

	c1 = Trim(107667, 107867)
	c1 = c1.Crop(192, 0, -136, -100).Tweak(bright = -2) # brightness just below the other clip, we only need to transfer the blue light rings
	c2 = Trim(110736, 110811).Reverse()
	c3 = c2 + BlankClip(c2, c1.FrameCount - c2.FrameCount)
	c3 = c3.FreezeFrame(c2.FrameCount, c1.FrameCount - 1, c2.FrameCount - 1)
	#Overlay(c3, Overlay(c3, c1, x = 192, mode = "lighten"), mode = "difference").Levels(92,1,160,0,255)
	Overlay(c3, c1, x = 192, mode = "lighten")
}

Trim(0, 3660) + \
fix6 + \
Trim(3676, 21429) + \
FixShower + \
Trim(21755, 60386) + \
fix5 + \
Trim(60417, 79961) + \
fix7 + \
Trim(80059, 88172) + \
fix2 + \
fix3 + \
Trim(88273, 91647) + \
fix8 + \
Trim(91708, 92163) + \
fix9 + \
Trim(92207, 107666) + \
FixTowers + \
Trim(107868, 130264) + \
fix4 + \
Trim(130343, 0)

