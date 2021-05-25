Import("../../common.avsi")

# Alliance vs Koch
#
# 0-107867 +15
# 107868- +13 107868=107881, the last/first frames are missing from the two scenes here

# 0
# 14315 moth landing in better quality, but not zoomed in that much
# 14553
# 30355 encoding error
# 30539
# 45031 tunnel in better quality
# 45120
# 55290 tunnel again
# 55379
# 104819 satellites
# 104880
# 107667 encoding error
# 108035
# 168046 end

# if your audio is synced to the original Koch release, remove 2002/30000 ms from the beginning
# I don't know how it happened, first dvd rip started 2 frames earler, too late now

# Koch en        30
# Koch ru        30
# Koch fr  0
# Alliance            43
# .avs          28

LoadEpisodeWithAlt("S01E02", 168045, \
	["..\..\S01(Koch)\V02\title_t15.d2v", 2], \
	["..\..\S01(Koch)\D02\title_t00.d2v", 2], \
	["..\..\S01(Koch)\D02\title_t00p1.d2v"], \
	["..\..\S01(Koch)\V02\title_t05.d2v", -28]) # French (lower bitrate)

Letterbox(0,0,2,2)

allipath1 = "..\..\S01(Alliance)\D01\title_t00.d2v"
allipath2 = "..\..\S01(Alliance)\D02\title_t00.d2v"

if(Exist(allipath1) && Exist(allipath2))
{
	c0 = ConvertToBFF

	c1 = MPEG2Source(allipath1, cpu=4)
	c2 = MPEG2Source(allipath2, cpu=4)

	Trim(c2, 15, 14329) + \
	Trim(c1, 110947, 111169) + \
	Trim(c2, 14553, 30369) + \
	Trim(c0, 30355, 30538) + \
	Trim(c2, 30554, 45045) + \
	Trim(c1, 136067, 136155) + \
	Trim(c2, 45135, 55304) + \
	Trim(c1, 136067, 136155) + \
	Trim(c2, 55394, 107681) + \
	Trim(c0, 107667, 108034) + \
	Trim(c2, 108048, 0)

	Trim(0, c0.FrameCount - 1)
}


function FixShower(clip c)
{
	# 21430,21754: 325 frames

	# 21430 pcpcp ccppc cpcpc pccpp ccpcp cpccp pccpc pcpcc pcpcp pcccc
	#       pccpp ccpcp cpccp cpcpc pcpcc pcpcp ccppc cpcpc pccpp ccpcc
	# 21480 pcpcp ccpcp cpccp pccpc pcpcc pcpcp cpcpc cpcpc pccpp ccpcp
	#       pccpc pcpcc pcpcp cpcpc cpcpc pccpp ccpcp cpccp cpcpc pcpcc
	# 21530 cpccp cpcpc pcpcc pcpcp ccppc cpcpc ...
	#       pcpcp ccppc cpcpc pccpc pcpcp cpccp ...
	# ...crossfade...
	# 21530 pccpp ccpcp cpccp cpcpc cpcpc pccpp ccpcp cpcpc pccpc pcpcc
	#       pccpc pcpcc pcpcp ccpcp cpccp pccpc pcpcc ppccp cpcpc cpcpc
	# 21580 ppccp cpcpc cpcpc pccpc pcpcc ppccp cpcpc cpcpc pccpc pcpcc
	#       pcpcp ccpcp cpccp cpcpc cppcc pcpcp ccpcp cpccp cpcpc cppcc
	# 21630 ppccp cpcpc cpcpc pccpc pcpcp cpccp cpcpc cpcpc pccpp ccpcp
	#       pcpcp ccpcp cpccp cpcpc cppcc pcpcp ccpcp cpccp cpcpc cppcc
	# 21680 cpccp cpcpc cpcpc pccpp ccp..
	#       pcpcp ccpcp cpccp cpcpc cpp..
	# ...crossfade...
	# 21655 cpccp
	#       ccpcc
	# 21660 cpccp pccpc pcpcc pcpcp ccpcp cpccp pccpc pcpcc pcpcp ccppc
	#       pcpcp ccppc cpcpc pccpc pcpcc ppccp cpcpc cpcpc pccpp ccpcp
	# 21710 cpccp cpcpc cpcpc pccpc pcpcc ppccp cpcpc cpcpc ppccc cpccc
	#       cccpp ccpcp cpccp cpcpc cppcc pcpcp ccpcp cpccp pccpc cccpc

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

# cogwheels spinning up 

# 88173    pc cpcpc
#          pc cpccp
# 88180 ccpcp ccpcc pccpc cpccp cpccp cpccp ccpcc pccpc cpcpc cpc
#       cccpc cpccp cpcpc cpccp ccpcc pccpc cpcpc pccpc cpccp ccp

fix2 = FixSlowMoI(88173, 88227, 37000, f = [ \
	[0,1,2,4,6,7,8,10,12,13,15,16,18,19,21,22,24,25,27,29,30,32,34,35,37,38,40,41,43,44,46,47,49,51,52,54], \
	[0,1,2,4,5,7,8,9,11,12,14,15,17,19,21,22,24,25,27,28,30,31,33,34,36,37,39,41,43,44,46,47,49,50,52,53] \
	])

# more spinning wheels

# 88228    cc
#          cc
# 88230 ccccc pccpc cpccp cpcpc cpccp cpcpc cpccp cpcpc cpc
#       ccccc ccpcp cpccp ccpcp cpccp ccpcp ccpcp ccpcc pcp

fix3 = FixSlowMoI(88228, 88272, 37000, f = [ \
	[0,1,2,3,4,5,6,8,9,11,12,14,15,17,19,21,22,24,25,27,29,31,32,34,35,37,39,41,42,44], \
	[0,1,2,3,4,5,6,7,8,10,12,14,15,17,18,20,22,24,25,27,28,30,32,33,35,37,38,40,41,43] \
	])

# disc on a slice of Kai's body (same method)

# 130265 cccpc pccpc pccpc cpccp ccpcc pccpc pccpc pccpc cpccp ccpcc
#        cccpc cpccp ccpcc pcpcc pcpcc pccpc cpccp ccpcc pcpcc pcpcc
# 130315 pccpc pccpc pccpc cpccp ccpcc pcc
#        pccpc cpccp ccpcc pcpcc pcpcc pcc

fix4 = FixSlowMoI(130265, 130342, 37000, f = [ \
	[0,1,2,4,6,7,9,11,12,14,15,17,18,20,21,23,24,26,27,29,31,32,34,36,37,39,40,42,43,45,46,48,49,51,52,54,56,57,59,61,62,64,65,67,68,70,71,73,74,76,77], \
	[0,1,2,4,5,7,8,10,11,13,14,16,18,19,21,23,24,26,27,29,30,32,33,35,36,38,39,41,43,44,46,48,49,51,52,54,55,57,58,60,61,63,64,66,68,69,71,73,74,76,77] \
	])

# Zev on floor tile switch thingy (bg is a little bent in two frames, mv_search = 7 maybe?)

# 60387 pcc
#       cpc
# 60390 cpccp ccpcc cpccc pccpc cpccp cc
#       ccpcc cpccp ccpcc pcccp cccpc cp

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

# 79962   pcc ccpcc
#         ccp ccpcc
# 79970 pcccp cccpc ccpcc cpccp ccccp ccpcc ccpcc pcccc pccpc cccpc
#       ccpcc pcccc pccpc cccpc cpccc cpccp ccccp ccpcc cpccc pcccp
# 80020 cpccc cpccp ccccp ccpcc ccpcc pcccc pccpc ccpc
#       cccpc ccpcc cpccp ccccp ccpcc ccpcc pcccc pccp

fix7 = FixSlowMoI(79962, 80058, 40600, pd = 0, f = [ \
	[1,2,3,4,6,7,9,10,11,13,14,15,17,18,19,21,22,23,25,26,28,29,30,31,33,34,36,37,38,39,41,42,44,45,46,47,49,50,52,53,54,55,57,58,60,61,62,63,65,66,68,69,70,71,73,74,76,77,78,79,81,82,84,85,86,87,89,90,92,93,94,96], \
	[0,1,3,4,6,7,8,9,11,12,14,15,16,17,19,20,22,23,24,25,27,28,30,31,32,33,35,36,38,39,40,41,43,44,46,47,48,50,51,52,54,55,56,58,59,60,62,63,64,66,67,68,70,71,73,74,75,76,78,79,81,82,83,84,86,87,89,90,91,92,94,95] \
	])

# Stanley's torture #1

# 91648 pc
#       cp
# 91650 pcpcp ccpcp cpccp pccpc pcpcc ppccp cpcpc cpcpc pcpcp ccpcp
#       pccpc pcpcc pcpcp cpcpc cpcpc pccpp ccpcp cpccp pccpc pcpcc
# 91700 cpccp pcc
#       pcpcp cpc

_fix8 = FixSlowMoI(91648, 91707, 44100, deint = 5, f = [ \
	[1,3,5,7,8,10,12,14,15,18,19,21,23,25,26,29,30,32,34,36,37,39,41,43,45,47,48,50,52,54,55,58,59], \
	[0,3,4,6,8,10,11,13,15,17,19,21,22,24,26,28,29,32,33,35,37,39,40,43,44,46,48,50,51,53,55,57,59], \
	[1] \
	])


# 0 h lhlhl hlh lhlh lhl hlhl hlh lhlh lhl hlhlh lhl
#     ?   ?   ?    ?   ? ?    ?   ?    ?   ?   ?   ?
# 38 hlhl hlh lhlh lhl hlhlh lh lhlhl hlh lhlh lhl
#       ? ?   ?    ?   ?   ?    ?   ?   ?    ? ?
# 74 hlhl hlh lhlhl hlh lhlh lhl hlhl hlh lhlh lhl
#    ?    ?   ?   ?   ?    ?   ?    ? ?   ?    ?
# 110 hlhlh lhl hl
#     ?   ?   ?

function FixTorture1(clip c, bool blend)
{
	Trim(c, 91648, 91707)

	ConvertToYV24(interlaced = true)

	Separatefields

	DeleteFrame(1,5,8,12,15,16,20,23,27,30,34,37,\
		41,42,45,49,52,56,59,63,66,70,71,\
		74,78,81,85,88,92,95,99,100,103,107,\
		110,114,117)
	
	# pcccp (extend for ivtc)
	
	BlankClip(last, 2) + last
	
	# ppccc
	
	SelectEvery(10, 2,1, 4,5, 6,7, 8,9).Weave.AssumeFPS(c)
	
	# get rid of the half frames both ends
	
	Trim(1, FrameCount - 2) 

	if(blend)
	{
		ScriptClip("BobMerge(GetParity(current_frame))")
	}
	else
	{
		ScriptClip("FixFieldOffset(GetParity(current_frame), offset = 0.25)")
	}
	
	if(c.GetParity) {AssumeTFF}
	else {AssumeBFF}
	
	ConvertToYV12(interlaced = true)

	#FixSlowMoI(0, FrameCount - 1, 40200, pd = 0, mv_search=6)
	FixSlowMoI(0, FrameCount - 1, 45500, mv_search=6)
}

fix8 = FixTorture1(true)

# Stanley's torture #2

# 92164 c
#       c
# 92165 pcpcc pcpcp cpcpc cpcpc pcpcp ccpcp cpccp pccpc pc
#       cpcpc pccpp ccpcp cpccp pccpc pcpcc pcpcp cpcpc cc

_fix9 = FixSlowMoI(92164, 92206, 44100, deint = 5, f = [ \
	[0,2,4,5,7,9,11,13,15,16,18,20,22,24,26,27,29,31,33,34,37,38,40,42], \
	[0,1,3,5,7,8,11,12,14,16,18,19,22,23,25,27,29,30,32,34,36,38,40,41], \
	[1] \
	])
	
# 0 hlh 3 lhlh 7 lhl 10 hlhl 14 hlh 17 lhlhl 22 hlh 25 lhlh 29 lhl 32 hlhl 36 hlh 
# 39 lhlhl 44 hlh 47 lhlh 51 lhl 54 hlhl 58 hlh 61 lhlh 65 lhl 68 hlhlh 73 lhl
# 76 hlhl hlh lh l	

function FixTorture2(clip c, bool blend, bool sharp)
{
	Trim(c, 92164, 92206)

	ConvertToYV24(interlaced = true)

	Separatefields

	if(sharp)
	{
		DeleteFrame(2,6,7,10,14,17,21,24,25,29,35,36,39,\
			43,46,50,53,54,58,61,65,68,72,75,79,80)
	}
	else
	{
		DeleteFrame(0,3,9,13,16,20,21,22,28,31,32,38,39,\
			40,44,47,51,57,60,64,67,68,69,73,76,82)
	}
		
	# ccppc
	
	SelectEvery(10, 0,1, 2,3, 6,5, 8,9).Weave.AssumeFPS(c)

	# last frame half frame
		
	Trim(0, FrameCount - 2)

	if(blend)
	{
		ScriptClip("BobMerge(GetParity(current_frame))")
	}
	else
	{
		ScriptClip("FixFieldOffset(GetParity(current_frame), offset = -0.25)")
	}

	if(c.GetParity) {AssumeTFF}
	else {AssumeBFF}
	
	ConvertToYV12(interlaced = true)

	#FixSlowMoI(0, FrameCount - 1, 40200, pd = 0, mv_search=6)
	FixSlowMoI(0, FrameCount - 1, 45500, mv_search=6)
}

fix9 = FixTorture2(true, true)

# Zev in the intro

# 6170 ccccp cccpc cpccc cpccp pcpcc ccpcc pcccc pccpc cpccc cpccp
#      ccccc pcccp cccpc cpccc ppccp cccpc ccpcc pcccc pccpc ccpcc
# 6220 cccc
#      cpcc

fix10 = FixSlowMoI(6170, 6223, 32800, fin = 7, f = [ \
	[0,1,2,3,5,6,7,9,10,12,13,14,15,17,18,21,23,24,25,26,28,29,31,32,33,34,36,37,39,40,42,43,44,45,47,48,50,51,52,53], \
	[0,1,2,3,4,6,7,8,10,11,12,14,15,17,18,19,22,23,25,26,27,29,30,31,33,34,36,37,38,39,41,42,44,45,46,48,49,50,52,53] \
	])

# His Shadow going up on the column
	
# 8092 012 34567 88002 24567 89012 34566 8801
#      012 34568 89012 34567 89012 44667 8901

fix11 = FixSlowMoI(8092, 8123, 30000, pd = 0, f = [ \
	[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,14,16,15,19,19,20,21,23,23,24,25,27,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,46,48,47,50,50,52,51,55,55,56,57,59,59,60,61,62,63], [], \
	[0,2,4,6,8,10,12,15,16,19,20,23,24,27,28,30,32,34,36,38,40,42,44,47,48,51,52,55,56,59,60,62], \
	[0,2,4,6,8,10,12,14,16,19,20,23,24,27,28,30,32,34,36,38,40,42,44,46,48,50,52,55,56,59,60,62] \
	])
	
# Lexx fly-by (very few whole frames, almost 59.94i)

# 40715 01357 91357 80246 79134 57912 35789 13578 024
#       12468 02468 91356 80245 68012 46890 24679 135

_fix12 = FixSlowMoI(40715, 40752, 17500, pd = 0, f = [ \
	[0,0,2,1,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,16,16,17,17,18,18,20,19,21,21,22,22,23,23,24,24,25,25,26,26,27,27,28,29,30,30,31,31,32,32,33,33,34,34,35,35,36,36,38,37,40,39,41,41,42,42,43,43,44,44,45,45,46,47,48,49,50,50,51,51,52,52,53,53,54,54,56,55,58,57,59,59,60,60,61,61,62,62,63,63,64,64,65,65,66,67,68,68,69,69,70,70,71,71,72,72,73,73,74,74,75,75], [], \
	[1,2,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,36,39,41,43,45,47,49,51,52,55,57,59,61,63,65,67,68,70,73,75,77,79,81,82,84,87,89,91,93,95,96,98,101,103,105,107,109,111,113,114,117,119,121,123,125,127,129,131] \
	])

# satellites

function FixSat(clip c, bool rev)
{
	last = c
	
	# first get rid of the blue plasma thing shooting up from the planet
		
	c1 = Trim(46700, 46737)
	c2 = c1.FreezeFrame(0, c1.FrameCount, 0).Crop(432, 0, 128, 128)
	Overlay(c1, c2, x = 432, y = 0, mode = "Blend")

	#SeparateFields()
	#SelectEvery(10, 0,1, 2,3, 6,5, 8,9) # ivtc
	#Weave
	#AssumeFPS(c)
	#Trim(0, length = FrameCount - 2) # last frame not very nice
	#if(rev) {Reverse} # crashes
	#FixSlowMoI(0, FrameCount, 81000, pd = 0, fc = 2, f = [[0, 1], []])
	
	SeparateFields()
	SelectEvery(10, 0,1, 2,3, 6,5, 8,9) # ivtc
	SelectEvery(2, 0,1, 0,1) # double every frame (MFlowFps looks strange here)
	if(rev) {Weave.Reverse.Trim(1, 0).SeparateFields} # last frame not very nice
	SelectEvery(8, 0,1, 2,3, 2,5, 4,7, 6,7) # pulldown (ccppc)
	Weave
	AssumeFPS(c)
}

fix13 = FixSat(false).Trim(0, 104879 - 104804)
fix14 = FixSat(true).Trim(0, 115796 - 115723)

#_fix14 = FixSplitFields(115723, 115796)

Trim(0, 3660) + \
fix6 + \
Trim(3676, 6169) + \
fix10 + \
Trim(6224, 8091) + \
fix11 + \
Trim(8124, 21429) + \
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
Trim(92207, 104803) + \
fix13 + \
Trim(104880, 107666) + \
FixTowers + \
Trim(107868, 115722) + \
fix14 + \
Trim(115797, 130264) + \
fix4 + \
Trim(130343, 0)

