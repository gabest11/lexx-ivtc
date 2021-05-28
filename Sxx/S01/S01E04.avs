Import("../../common.avsi")

# Alliance vs Koch
#
# Koch / Alliance
# 0-75361 = 30-75391 +30
# Alliance 75392 missing from Koch
# 75362-107808 = 75393-107839 +31
# Koch 107809 missing from Alliance
# 107810-158549 = 107840-158579 +30
# Koch 158550 missing from Alliance
# 158551- = 158580- +29

# Koch en  0
# Koch ru  0
# Koch fr  0
# Alliance       28

LoadEpisodeWithAlt("S01E04", 167095, \
	["..\..\S01(Koch)\V04\title_t15.d2v"], \
	["..\..\S01(Koch)\D04\title_t00.d2v"], \
	["..\..\S01(Koch)\V04\title_t06.d2v"]) # French (lower bitrate, also seems darker in a few places)

Letterbox(0,0,2,2)

allipath = "..\..\S01(Alliance)\D04\title_t00.d2v"

if(Exist(allipath))
{
	c0 = ConvertToBFF()

	MPEG2Source(allipath, cpu=4)

	Trim(28, 75348) + \
	Trim(c0, 75321, 75508) + \
	Trim(75538, 107839) + \
	Trim(c0, 107811, 107903) + \
	Trim(107932, 158522) + \
	Trim(c0, 158495, 158552) + \
	Trim(158580, 0)

	Trim(0, c0.FrameCount - 1)
}

# moth flying over the exploding gigashadow

# by field (they are the same, the first is 10 frame ahead, pattern repeats in every 19 frames)
#
# 132529 pcp
#        cpc
# 132532 ccpcc pccpc cpccp cpcpc cpccp ccpcc pccpc pcpcc pccpc cpccp
#        cpccp cpcpc cpccp ccpcc pccpc pcpcc pccpc cpccp ccpcp cpccp
# 132582 ccpcp cpccp ccpcc pccpc cpcpc pccpc cpccp ccpcc pcpcp ccpcc
#        ccpcc pccpc cpcpc pccpc cpccp ccpcc pcpcp ccpcc pccpc cpccp
# 132632 pccpc cpccp cpcpc cpccp ccpcc pccpc pcpcc pccpc cpccp ccpcp
#        cpcpc cpccp ccpcc pccpc pcpcc pccpc cpccp ccpcp ccpcp ccpcc
# 132682 c
#        p

# bit naughty asking for the last field outside the batch, but step size is just a step size, not a restriction

fix1 = FixSlowMoI(132529, 132682, 38130, fc = 19, f = [ \
	[1,3,5,6,7,9,10,12,13,15,16,19], \
	[0,2,3,5,6,8,10,12,13,15,16,18] \
	])

# Lexx firing at the gigashadow, watching on the oval display

# 138460    pc
#           cp
# 138462 pccpc cpcpc pccpc pcpcc pccpc pcpcc pccpp ccpcc pcpcp ccpcc
#        cpcpc cpccp cpcpc cpccp cpcpc cpcpc pccpc cpcpc pccpc pcpcc
# 138512 pcpcp ccpcp cpccp ccpcp cpccp ccpcp cpcc
#        pccpc pcpcc pccpc pcpcc pcpcp ccpcc pcpc
       
# it's already a morphing gfx, morphing it even harder at 29.97

fix2 = FixSlowMoI(138460, 138545, 51500, pd = 0, f = [ \
	[1,3,4,6,7,9,11,13,14,16,18,20,21,23,24,26,28,30,31,33,34,37,38,40,41,43,45,47,48,50,51,53,55,57,58,60,62,64,65,67,68,70,72,74,75,77,78,80,82,84,85], \
	[0,2,4,6,7,9,10,12,14,16,17,19,20,22,24,26,27,29,31,33,34,36,37,39,41,43,44,46,48,50,51,53,54,56,58,60,61,63,64,66,68,70,71,73,75,77,78,80,81,83,85] \
	])

# transport ships flying in

# 10086     c 
#           c 
# 10092 cpccc cpccp ccccp ccpcc ccPcc pcccc pccpc cccPc cpccc Pcccp
#       cccpc cPccc cpccP ccccp ccPcc ccpcc Pcccc pccpc cccpc cpccc
# 10142 cccPc ccpcc cPccc 
#       cpcCp ccccp Ccpcc 

fix3 = FixSlowMoI(10086, 10151, 39800, pd = 0, deint = 5, f = [ \
	[0,1,3,4,5,6,8,9,11,12,13,14,16,17,19,20,21,22,24,25,27,28,29,30,32,33,35,36,37,38,40,41,43,44,45,47,48,49,51,52,53,55,56,57,59,60,61,63,64,65], \
	[0,1,2,3,5,6,8,9,10,11,13,14,16,17,18,19,21,22,24,25,26,27,29,30,32,33,34,35,37,38,40,41,42,43,45,46,48,49,50,51,53,54,56,57,58,59,61,62,64,65], \
	[1] \
	])

# same scene in S01E01, only this part:
#
# 618 hl hlh lh lhl hl hlhl
#                         ?
# 634 hl hlh lh lhl hl hlhl hl hlh lh lhl hl hlhl hl hlh
#                         ?                     ?
# 671 lh lhl hl hlhl hl hlh lh lhl hl hlhl hl hlh lh lhl
#               ?                     ?   
# 708 hlh lhl hl hlh lh lhl hlh lhl hl hlh lh lhl hlh lhl
#       ?                     ?                   ?
# 746 hl hl

function FixTransportShips(clip c, bool blend)
{
	Trim(c, 10086, 10151)

	ConvertToYV24(interlaced = true)

	Separatefields

	DeleteFrame(15,31,47,60,76,92,108,122)

	SelectEvery(10, 0,1, 2,3, 6,5, 8,9).Weave.AssumeFPS(c)

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

	#FixSlowMoI(0, FrameCount - 1, 40200, pd = 0)
	FixSlowMoI(0, FrameCount - 1, 32100)
}

fix3 = FixTransportShips(true)

# brain #1

# 16194   cpc ccpcc
#         ccc pccpc
# 16202 pccpc ccpcc pccpc ccpcc pccpc ccpcc pccpc ccpcc pccpc ccpcc
#       cpccp cccpc cpccp cccpc cpccp cccpc cpccp cccpc cpccp cccpc
# 16252 p
#       c

fix4 = FixSlowMoI(16194, 16252, 34000, f = [ \
	[0,2,3,4,6,7,9,10,12,13,14,16,17,19,20,22,23,24,26,27,29,30,32,33,34,36,37,39,40,42,43,44,46,47,49,50,52,53,54,56,57], \
	[0,1,2,4,5,7,8,10,11,13,14,15,17,18,20,21,23,24,25,27,28,30,31,33,34,35,37,38,40,41,43,44,45,47,48,50,51,53,54,55,57,58] \
	])

# brain #2

# 19772 cpccc pccpc cpccc pccpc cpccc pccpc cpccc pccpc cpccc pccpc cpc
#       cccpc cpccp ccpcc cpccp ccpcc cpccp ccpcc cpccp ccpcc cpccp ccp
      
fix5 = FixSlowMoI(19772, 19824, 34200, f = [ \
	[0,2,3,4,6,7,9,10,12,13,14,16,17,19,20,22,23,24,26,27,29,30,32,33,34,36,37,39,40,42,43,44,46,47,49,50,52], \
	[0,1,2,4,5,7,8,10,11,13,14,15,17,18,20,21,23,24,25,27,28,30,31,33,34,35,37,38,40,41,43,44,45,47,48,50,51] \
	])
	
# first conveyor belt scene (side sync, amazingly this also makes mid row go in sync)

#fix6 = FixSlowMoI(1096, 1110, 53000, pd = 0, f = [ \
fix6 = FixSlowMoI(1096, 1110, 41500, f = [ \
	[0,2,3,5,7,8,10,12,13], \
	[0,1,3,5,6,8,10,12,13] \
	])

# gigashadow inside #1

# 133735    cc pccpc
#           cc pcccc
# 133742 cpccc pcccp ccpcc pcccp cccpc cpccp cccpc ccpcc pccpc ccpcc
#        pccpc cpccp ccccp ccpcc pccpc cccpc cpccp ccpcc ccpcc pccpc 
# 133792 cpccp ccpcc cpccc pccpc cpccc pcccp ccpcc pccpc cccpc cpccp
#        cpccc cpccp ccpcc pcccp cccpc cpccp cccpc ccpcc pccpc ccpcc
# 133842 ccpcc ccpcc pccpc cpccc cpccp ccpcc pcccc pccpc c
#        cpccp ccpcc cpccc pccpc cpccc pcccp ccpcc pcccp c

fix7 = FixSlowMoI(133735, 133882, 33500, pd = 2, f = [ \
	[0,1,3,4,6,7,9,10,11,13,14,15,17,18,20,21,23,24,25,27,28,29,31,32,34,35,37,38,39,41,42,43,45,46,48,49,51,52,53,55,56,57,59,60,62,63,65,66,67,69,70,71,73,74,76,77,79,80,81,83,84,85,87,88,90,91,93,94,96,97,98,99,101,102,104,105,107,108,110,111,112,113,115,116,118,119,121,122,124,125,126,127,129,130,132,133,135,136,138,139,140,141,143,144,146,147], \
	[0,1,3,4,5,6,8,9,11,12,14,15,17,18,19,20,22,23,25,26,28,29,31,32,33,34,36,37,39,40,42,43,45,46,47,48,50,51,53,54,56,57,59,60,61,62,64,65,67,68,70,71,73,74,75,77,78,79,81,82,84,85,87,88,89,91,92,93,95,96,98,99,101,102,103,105,106,107,109,110,112,113,115,116,117,119,120,121,123,124,126,127,129,130,131,133,134,135,137,138,140,141,143,144,145,147] \
	])
	
# scared Stanley and the shadow

# 151632 cpccc pcccc ppccc cpccc cpccc cpccp ccccp cccpc ccpcc ccpcc
#        ccpcc ccpcc pccpc cccpc cccpc cccpc cpccc cpccp ccccp ccpcc
# 151682 pcccc pccpc cccpc ccpcc cpccc
#        ccpcc ccpcc pcccc pccpc cccpc

fix9 = FixSlowMoI(151632, 151706, 31700, f = [ \
	[0,2,3,4,6,7,8,9,12,13,14,15,17,18,19,20,22,23,24,25,27,28,30,31,32,33,35,36,37,39,40,41,43,44,45,46,48,49,51,52,53,54,56,57,59,60,61,62,64,65,66,68,69,70,72,73,74], \
	[0,1,3,4,5,6,8,9,11,12,14,15,16,17,19,20,21,22,24,25,26,27,29,30,32,33,34,35,37,38,40,41,42,43,45,46,48,49,50,51,53,54,55,56,58,59,61,62,63,64,66,67,69,70,71,72,74] \
	])

# brain #0

# 9833  ccpc cpccc
#       cccp ccpcc
# 9842 pccpc cpccc pccpc cpccc pccpc cpccc pccpc cpccc pccpc cpccc
#      cpccp ccpcc cpccp ccpcc cpccp ccpcc cpccp ccpcc cpccp ccpcc
# 9892 pccpc cpccc pccpc cpccc pccpc cpccc pccpc cpccc pccpc
#      cpccp ccpcc cpccp ccpcc cpccp ccpcc cpccp ccpcc cpccp
#
# pccpc cpccc / cpccp ccpcc repeating
     
fix10 = FixSlowMoI(9833, 9936, 34200, f = [ \
	[0,1,3,4,6,7,8,10,11,13,14,16,17,18,20,21,23,24,26,27,28,30,31,33,34,36,37,38,40,41,43,44,46,47,48,50,51,53,54,56,57,58,60,61,63,64,66,67,68,70,71,73,74,76,77,78,80,81,83,84,86,87,88,90,91,93,94,96,97,98,100,101,103], \
	[0,1,2,4,5,7,8,9,11,12,14,15,17,18,19,21,22,24,25,27,28,29,31,32,34,35,37,38,39,41,42,44,45,47,48,49,51,52,54,55,57,58,59,61,62,64,65,67,68,69,71,72,74,75,77,78,79,81,82,84,85,87,88,89,91,92,94,95,97,98,99,101,102] \
	])

# gigashadow inside #2

# 131659 pcc
#        ccp
# 131662 pccpc cpccp ccpcc pccpc cpccp cpccp ccpcp ccpcc pccpc cpccp
#        ccpcc pcpcc pccpc pccpc cpccp ccpcc pccpc cpccp ccpcp ccpcp
# 131712 ccpcc pccpc cpcpc cpcpc cpccp ccpcc pccpc cpccp ccpcc pcpcc
#        ccpcc pccpc cpccp ccpcc pccpc cpcpc cpccp cpccp ccpcc pccpc
# 131762 pccpc pccpc cpccp ccpcc pccpc cpccp ccpcp ccpcp ccpcc pccpc
#        cpccp ccpcc pccpc pccpc cpcpc cpccp ccpcc pccpc cpccp ccpcp
# 131810 cpccp ccpcc
#        ccpcc pcpcc

fix11 = FixSlowMoI(131659, 131821, 36900, f = [ \
	[1,2,4,5,7,8,10,11,13,14,16,17,19,20,22,23,25,26,28,30,31,33,34,36,38,39,41,42,44,45,47,48,50,51,53,54,56,57,59,60,62,63,65,67,68,70,72,73,75,76,78,79,81,82,84,85,87,88,90,91,93,94,96,97,99,101,102,104,105,107,109,110,112,113,115,116,118,119,121,122,124,125,127,128,130,131,133,134,136,138,139,141,143,144,146,147,149,150,152,153,155,156,158,159,161,162], \
	[0,1,3,4,6,7,9,11,12,14,15,17,19,20,22,23,25,26,28,29,31,32,34,35,37,38,40,41,43,44,46,48,49,51,53,54,56,57,59,60,62,63,65,66,68,69,71,72,74,75,77,78,80,82,83,85,86,88,90,91,93,94,96,97,99,100,102,103,105,106,108,109,111,112,114,115,117,119,120,122,123,125,127,128,130,131,133,134,136,137,139,140,142,143,145,146,148,149,151,153,154,156,157,159,161,162] \
	])

# Zev in the intro (S01E02)

# 6172 ccccp cccpc cpccc cpccp pcpcc ccpcc pcccc pccpc cpccc cpccp
#      ccccc pcccp cccpc cpccc ppccp cccpc ccpcc pcccc pccpc ccpcc
# 6222 cccc
#      cpcc
     
fix12 = FixSlowMoI(3605, 3658, 32800, fin = 7, f = [ \
	[0,1,2,3,5,6,7,9,10,12,13,14,15,17,18,21,23,24,25,26,28,29,31,32,33,34,36,37,39,40,42,43,44,45,47,48,50,51,52,53], \
	[0,1,2,3,4,6,7,8,10,11,12,14,15,17,18,19,22,23,25,26,27,29,30,31,33,34,36,37,38,39,41,42,44,45,46,48,49,50,52,53] \
	])

# His Shadow going up on the column (S01E02)
	
# 8094 012 34567 88002 24567 89012 34566 8801
#      012 34568 89012 34567 89012 44667 8901

# use missing frame interpolation here, because the text looks bad with nnedi3

fix13 = FixSlowMoI(5527, 5558, 30000, pd = 0, deint = 3, f = [ \
	[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,14,16,15,19,19,20,21,23,23,24,25,27,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,46,48,47,50,50,52,51,55,55,56,57,59,59,60,61,62,63], [], \
	[0,2,4,6,8,10,12,15,16,19,20,23,24,27,28,30,32,34,36,38,40,42,44,47,48,51,52,55,56,59,60,62], \
	[0,2,4,6,8,10,12,14,16,19,20,23,24,27,28,30,32,34,36,38,40,42,44,46,48,50,52,55,56,59,60,62] \
	])

# last man standing

# 21159 023 45689 01245 6
#       123 46789 02345 6
      
fix14 = FixSlowMoI(21159, 21172, 30000, pd = 0, f = [ \
	[0,0,1,1,2,3,4,5,6,7,8,8,10,9,11,11,12,13,14,15,16,17,18,18,20,19,21,21,22,23,24,25,26,27], [], \
	[1,3,4,6,8,11,12,15,16,18,20,23,24,27,28,30,32], \
	[0,3,4,6,8,10,12,15,16,18,20,22,24,27,28,30,32] \
	])
	
# looking back behind the shoulder in slow-mo, every frame is just duplicated
# interpolate new ones while keeping the cccpp pattern

fix15 = FixSlowMoI(13910, 14061, pd = 4, deint = 3, fc = 10, f = [ \
	[0, 1, 2, 3, 4, 5, 8, 7], [], \
	[0, 3] \
	])

	
# shadow spreading on the bridge of the Lexx

# 0 hl hl hlh lh lhl hl|hl 16 h lh lhlh lh lhl hl 
#                       ??         ?
# 30 hlh lh lhlh lh lhl hl 46 hlh lh lhlh lh lhl hl 
#              ?                     ?
# 62 hlh lh lhlh lh lhl hl 78 hlh lh lhl hlh lhl hl 
#              ?                         ?
# 94 hlh lh lhl hlh lhl hl 110 hlh lh lhl hlh lhl hl 
#                 ?                         ?
# 126 hlh lh lhl hl hlhl hl 142 hlh lh lhl hl hlhl hl 
#                   ?                         ?
# 158 hlh lh lhl hl hlhl hl 174 hlh lh lhl hl hlhl hl 
#                   ?                            ?
# 190 hlh lh lhl hl hlhl hl 206 hlh lh lhl hl hlh lhl 
#                      ?                          ?
# 222 hlh lh lhl hl hlh lhl 238 hlh lh lhl hl hlh lhl
#                         ?                         ? 
# 254 hlh lh lhl hl hlh lh 269 lhlh lh lhl hl hlh lh 
#                              ?
# 285 lhlh l
#     ?    ?

# there is a funny part around 14-16, have to break it into two segments

function FixShadowOnTheBridge(clip c, bool blend)
{
	Trim(c, 149388, 149532)

	ConvertToYV24(interlaced = true)

	Separatefields

	DeleteFrame(14,15,19,38,51,70,86,104,120,136,152,168,187,203,219,237,253,269,285,289)
	
	c1 = Trim(0,13).SelectEvery(10, 0,1, 2,3, 4,5, 8,7)
	c2 = Trim(14,0).SelectEvery(10, 2,1, 4,5, 6,7, 8,9)
	
	c1 + c2
	
	Weave.AssumeFPS(c)

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

	# interpolate the cut frame? it does not add much
	
	#super = MSuper(pel=4)
	#backward_vectors = MAnalyse(super, isb = true, blksize=32, overlap=8, search=3, delta=2)
	#forward_vectors = MAnalyse(super, isb = false, blksize=32, overlap=8, search=3, delta=2)
	#c3 = MFlowInter(super, backward_vectors, forward_vectors, time=50, ml=70)
	#Trim(0, 5) + c3 + Trim(6, 0)
	
	#FixSlowMoI(0, FrameCount - 1, 40500, pd = 0)
	FixSlowMoI(0, FrameCount - 1, 32500)
}

fix8 = FixShadowOnTheBridge(true)

# after the guy leaves to the left, the fields start shaking randomly
# no idea what's going on, nothing moves	

function FixKetchapScene(clip c)
{
	c.Trim(10982, 11093)
	
	tv = Crop(74, 0, -72, 334)
	
	Bob(0, 1)
	Merge(SelectEven, SelectOdd)

	Overlay(tv, 74, 0)
}

fix16 = FixKetchapScene()

Trim(0, 1095) + \
fix6 + \
Trim(1111, 3604) + \
fix12 + \
Trim(3659, 5526) + \
fix13 + \
Trim(5559, 9832) + \
fix10 + \
Trim(9937, 10085) + \
fix3 + \
Trim(10152, 10981) + \
fix16 + \
Trim(11094, 13909) + \
fix15 + \
Trim(14062, 16193) + \
fix4 + \
Trim(16253, 19771) + \
fix5 + \
Trim(19825, 20903) + \
FixSplitFieldsVideo(20904, 20968) + \
Trim(20969, 21099).LeftToVideo(2, 600) + \
Trim(21100, 21133) + \
Trim(21134, 21158).LeftToVideo(1, 600) + \
fix14 + \
Trim(21176, 131658) + \
fix11 + \
Trim(131822, 132528) + \
fix1 + \
Trim(132683, 133734) + \
fix7 + \
Trim(133883, 138459) + \
fix2 + \
Trim(138546, 149387) + \
fix8 + \
Trim(149533, 151631) + \
fix9 + \
Trim(151707, 0)
