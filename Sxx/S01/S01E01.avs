Import("../../common.avsi")

# Alliance vs Koch
#
# 0-107815 = 3-107818 +3
# 107816-108066 = 107819...108043 ??? terrible mess ???
# 108067- = 108044- -23

# Koch en  0
# Koch ru  0
# Koch fr  0
# Alliance   3 -23

LoadEpisodeWithAlt("S01E01", 167300, \
	["..\..\S01(Koch)\D01\title_t00.d2v", 0], \
	["..\..\S01(Koch)\D01\title_t00p1.d2v", -2])

# TODO: add V01\*
	
Letterbox(0,0,2,2)

allipath = "..\..\S01(Alliance)\D01\title_t00.d2v"

if(false)#if(Exist(allipath))
{
	c0 = ConvertToBFF()

	MPEG2Source(allipath, cpu=4)

	Trim(3, 107818) + \
	Trim(c0, 107816, 108066) + \
	Trim(108044, 0)

	Trim(0, c0.FrameCount - 1)

#	c1 = Spline64Resize(Width, Height, src_left = 0.3)
#	Merge(c1, c0)
#	MergeChroma(c1)
}

# transport ships flying in

# 18261,18725 by field (p: last c repeated, cap: picture shifts vertically)
#
# cpccc cpccP ccccp ccPcc ccpcc pcccc pccpc cccpc Cpccc cpccp
# cccpc cccpc cpccc cPccp ccccP ccpcc cPccc pcccP cccpc ccPcc
# ccccp ccpcc ccpcc pcccc pccpc cccPc cpccc cPccp ccccP ccpcc
# cpccc Pcccp ccPcc ccpcc Pcccc pccPc cccpc cpccc cpccp ccccp
# cPccc pcccP cccpc ccPcc cpccP ccccp ccPcc ccpcc Pcccc pccpc
# ccpcc ccpcc pcccc pccpc cccpc cpccc cpccp ccccP ccpcc ccPcc
# cccpc cpccc cpccp ccccp ccpcc ccpcc pcccc pccpc cccPc cpccc
# pcccc Pccpc ccPcc cpccc Pcccp cccPc ccpcc Pcccc pccPc cccpc
# cPccp ccccP ccpcc cPccc pcccP cccpc ccPcc cpccc Pcccp ccPcc
# cPccc cpccp ccccp ccpcc ccpcc pcccc pcCpc cccpc cpccc cpccp
# ccpcc pcccc pccPc cccpc cpccc cpccp ccccp ccpcc ccpcC pcccc
# ccccp ccpcc ccPcc pcccc Pccpc cccpc cpccc Pcccp cccPc ccpcc
# pccpc cccpc cpccc cpccp ccccp ccpcc ccPcc pcccc pccpc cccPc
# cPccc pcccP cccpc cPccc cpccP ccccp ccPcc ccpcc Pcccc pccpc
# cpccc Pcccp cccPc ccpcc cPccc pccPc cccpc cPccc cpccP ccccp
# cccpc cpccc cpcCp ccccp Ccpcc ccpcc pcccc pCcpc cccpC cpccc
# ccPcc ccpcc Pcccc pcCpc cccpc Cpccc cpccp ccccp ccpcc ccpcc
# cPccp ccccP ccpcc ccPcc pcccP cccpc ccPcc cpccc Pcccp ccPcc
# pcccc pccpc cccPc
# ccpcc Pcccc pccPc

#fix1 = FixSlowMoI(18261, 18725, 32170, f = [ \
_fix1 = FixSlowMoI(18261, 18725, 40200, pd = 0, deint = 5, f = [ \
	[0,2,3,4,5,7,8,10,11,12,13,15,16,18,19,20,21,23,24,26,27,28,29,31,32,34,35,36,37,39,40,42,43,44,45,47,48,50,51,52,53,55,56,58,59,60,61,63,64,66,67,68,69,71,72,74,75,76,77,79,80,82,83,84,85,87,88,90,91,92,93,95,96,98,99,100,102,103,104,106,107,108,110,111,112,114,115,116,118,119,120,122,123,125,126,127,128,130,131,133,134,135,136,138,139,141,142,143,144,146,147,149,150,151,152,154,155,157,158,159,160,162,163,165,166,167,168,170,171,173,174,175,176,178,179,181,182,183,184,186,187,189,190,191,192,194,195,197,198,199,200,202,203,205,206,207,208,210,211,213,214,215,217,218,219,221,222,223,225,226,227,229,230,231,233,234,235,237,238,239,241,242,243,245,246,248,249,250,251,253,254,256,257,258,259,261,262,264,265,266,267,269,270,272,273,274,275,277,278,280,281,282,283,285,286,288,289,290,291,293,294,296,297,298,299,301,302,304,305,306,307,309,310,312,313,314,315,317,318,320,321,322,323,325,326,328,329,330,331,333,334,336,337,338,339,341,342,344,345,346,347,349,350,352,353,354,356,357,358,360,361,362,364,365,366,368,369,370,372,373,374,376,377,379,380,381,382,384,385,387,388,389,390,392,393,395,396,397,398,400,401,403,404,405,406,408,409,411,412,413,414,416,417,419,420,421,422,424,425,427,428,429,430,432,433,435,436,437,438,440,441,443,444,445,446,448,449,451,452,453,454,456,457,459,460,461,462,464], \
	[0,1,2,4,5,6,7,9,10,12,13,14,15,17,18,20,21,22,23,25,26,28,29,30,32,33,34,36,37,38,40,41,42,44,45,46,48,49,50,52,53,54,56,57,58,60,61,63,64,65,66,68,69,71,72,73,74,76,77,79,80,81,82,84,85,87,88,89,90,92,93,95,96,97,98,100,101,103,104,105,106,108,109,111,112,113,114,116,117,119,120,121,122,124,125,127,128,129,130,132,133,135,136,137,138,140,141,143,144,145,146,148,149,151,152,153,154,156,157,159,160,161,163,164,165,167,168,169,171,172,173,175,176,177,179,180,181,183,184,186,187,188,189,191,192,194,195,196,197,199,200,202,203,204,205,207,208,210,211,212,213,215,216,218,219,220,221,223,224,226,227,228,229,231,232,234,235,236,237,239,240,242,243,244,245,247,248,250,251,252,253,255,256,258,259,260,261,263,264,266,267,268,269,271,272,274,275,276,277,279,280,282,283,284,286,287,288,290,291,292,294,295,296,298,299,300,302,303,304,306,307,308,310,311,312,314,315,317,318,319,320,322,323,325,326,327,328,330,331,333,334,335,336,338,339,341,342,343,344,346,347,349,350,351,352,354,355,357,358,359,360,362,363,365,366,367,368,370,371,373,374,375,376,378,379,381,382,383,384,386,387,389,390,391,392,394,395,397,398,399,400,402,403,405,406,407,408,410,411,413,414,415,416,418,419,421,422,423,425,426,427,429,430,431,433,434,435,437,438,439,441,442,443,445,446,448,449,450,451,453,454,456,457,458,459,461,462,464], \
	[1] \
	])

# single dup fields shift the parity, about every 16th field repeats
# they are pretty hard to find, sometimes it is not obvious which one to drop
# the goal is to end up with something that converts to progressive after a normal ivtc
# vertical field offset needs to be corrected too, that means blurring many of the frames with a sup-pixel move
# ... or blend the fields

# 0 hlh lh lhl hl hlh lh lhlh lh lhl hl hlh lh lhlh
#                           ?                     ?
# 35 lh lhl hl hlh lh lhlh lh lhl hl hlh lhl hlh lh lhl
#                     ?                    ?
# 72 hl hlh lhl hlh lh lhl hl hlh lhl hlh lh lhl hl hlh
#             ?                   ?
# 109 lhl hlh lh lhl hl hlhl hl hlh lh lhl hl hlhl hl hlh
#     ?                    ?                     ?
# 147 lh lhl hl hlhl hl hlh lh lhl hl hlhl hl hlh lh lhl
#               ?                     ?
# 184 hl hlhl hl hlh lh lhl hlh lhl hl hlh lh lhl hlh lhl
#        ?                    ?                   ?
# 222 hl hlh lh lhl hlh lhl hl hlh lh lhlh lh lhl hl hlh
#                   ?                    ?
# 259 lh lhlh lh lhl hl hlh lh lhlh lh lhl hl hlh lh lhlh
#           ?                     ?                  ?
# 297 lh lhl hl hlh lh lhlh lh lhl hl hlh lhl hlh lh lhl
#                      ?                    ?
# 334 hl hlh lhl hlh lh lhl hl hlh lhl hlh lh lhl hl hlhl
#            ?                     ?                 ?
# 372 hl hlh lh lhl hl hlhl hl hlh lh lhl hl hlhl hl hlh
#                         ?                     ?
# 409 lh lhl hl hlhl hl hlh lh lhl hlh lhl hl hlh lh lhl
#               ?                    ?
# 446 hlh lhl hl hlh lh lhl hlh lhl hl hlh lh lhl hlh lhl
#       ?                     ?                   ?
# 484 hl hlh lh lhlh lh lhl hl hlh lh lhlh lh lhl hl hlh
#                  ?                     ?
# 521 lh lhlh lh lhl hl hlh lh lhlh lh lhl hl hlh lh lhlh
#           ?                  ?                     ?
# 559 lh lhl hl hlh lhl hlh lh lhl hl hlh lhl hlh lh lhl
#                     ?                     ?
# 596 hl hlh lhl hlh lh lhl hl hlh lhl hlh lh lhl hl hlhl
#            ?                     ?                    ?
# 634 hl hlh lh lhl hl hlhl hl hlh lh lhl hl hlhl hl hlh
#                         ?                     ?
# 671 lh lhl hl hlhl hl hlh lh lhl hl hlhl hl hlh lh lhl
#               ?                     ?   
# 708 hlh lhl hl hlh lh lhl hlh lhl hl hlh lh lhl hlh lhl
#       ?                     ?                   ?
# 746 hl hlh lh lhlh lh lhl hl hlh lh lhlh lh lhl hl hlh
#                  ?                     ?
# 783 lh lhlh lh lhl hl hlh lh lhlh lh lhl hl hlh lh lhlh
#           ?                     ?                  ?
# 821 lh lhl hl hlh lh lhlh lh lhl hl hlh lhl hlh lh lhl
#                      ?                    ?
# 858 hl hlh lhl hlh lh lhl hl hlh lhl hlh lh lhl hl hlhl
#            ?                     ?                    ?
# 896 hl hlh lh lhl hl hlhl hl hlh lh lhl hl hlhl
#                         ?                  ? 

function FixTransportShips(clip c, bool blend)
{
	Trim(c, 18261, 18725)

	ConvertToYV24(interlaced = true)

	Separatefields

	DeleteFrame(18,34,47,63,79,93,109,125,141,154, \
		170,186,202,216,232,248,264,280,293,309, \
		325,339,355,371,387,400,416,432,448,464, \
		478,494,510,526,539,555,571,587,601,617, \
		633,649,665,678,694,710,726,740,756,772, \
		788,804,817,833,849,863,879,895,911,924)

	SelectEvery(10, 0,1, 4,3, 6,7, 8,9).Weave.AssumeFPS(c)

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

	FixSlowMoI(0, FrameCount - 1, 40200, pd = 0)
	#FixSlowMoI(0, FrameCount - 1, 32100)
}

fix1 = FixTransportShips(true)

# first conveyor belt scene (side sync, amazingly this also makes mid row go in sync)

# 46849,46968 by field (p: last c repeated, cap: picture shifts vertically)
#
# mid section
# 0,   ccpcc ppccp ccpcc ppccp cpcpc cpccp ccppc cpcpc cpcpc cpcpc 
#      ccpcc pccpc pcpcc pcpcc pcpcc ppccp ccpcc pcpcp ccppc cpccp 
# 50,  pccpc cpcpc pccpp ccpcc pccpc pcpcc pcpcc pcpcc ppccp ccpcc
#      ccppc cpcpc cpcpc cpccp pccpc cpccp pccpc pcpcc pccpc pcpcc
# 100, ppccp ccppc cpccp ccppc 
#      pcpcc pcpcc ppccp ccpcc
# left section
# 0,   cpccp cpccp cpccp cpcpc cpcpc cpcpc cppcc pccpc cpcpc pccpc
#      ccpcc pcpcc ppccp ccpcc ppccp cpccp cpccp ccppc cpcpc cpcpc
# 50,  pccpc pccpp ccpcp ccpcp ccpcc ppccp ccpcc ppccp cpccp cpccp
#      cpcpc pccpc cpcpc pccpc pccpc pccpp ccpcc pcpcc pcpcc ppccp
# 100, cpcpc cpcpc cpcpc cppcp 
#      ccpcc ppccp cpccp cpccp

#fix2 = FixSlowMoI(46849, 46968, 51000, pd = 0, f = [ \
fix2 = FixSlowMoI(46849, 46968, 40750, f = [ \
	[0,2,3,5,7,8,10,12,13,15,17,19,20,22,24,25,27,29,30,33,34,36,37,39,40,42,44,46,47,49,51,52,54,56,57,60,61,63,65,66,68,70,71,73,74,77,78,80,81,83,84,87,88,90,92,93,95,97,98,100,102,104,105,107,109,110,112,114,115,118,119], \
	[0,1,3,4,6,8,9,12,13,15,16,18,19,22,23,25,27,28,30,32,33,35,36,39,40,42,44,45,47,49,50,52,54,56,57,59,60,62,64,66,67,69,71,72,74,76,77,80,81,83,84,86,88,89,91,93,94,97,98,100,101,103,104,107,108,110,112,113,115,117,118] \
	])

# mid row sync:
# 0,1,3,4,7,8,10,11,13,14,17,18,20,22,24,25,27,28,30,31,34,35,37,39,40,42,44,45,47,49,51,52,54,55,57,59,61,62,65,66,68,69,71,72,74,76,78,79,81,83,84,86,88,89,92,93,95,96,98,99,102,103,105,106,109,110,112,113,115,116,119
# 0,1,3,4,6,7,9,11,13,14,16,18,19,21,23,24,27,28,30,31,33,34,36,38,40,41,44,45,47,48,50,51,54,55,57,59,60,62,64,65,67,68,71,72,74,75,77,78,81,82,84,86,88,89,91,92,94,96,98,99,101,103,104,106,108,109,112,113,115,116,118

# megashadow harpooning the lexx

# 141673,141880 by field (p: last c repeated, cap: picture shifts vertically)
#
# pcPcc ccpcc cPccc PccPc cPccp ccpcc pccpc cpccP ccPcc PcccP
# cPcPc ccccp ccpcc pccpc cPccP cccPc cPccc PccPc cPccp ccpcc
# ccPcc cPccP ccPcc pccpc cpccp ccpcc Pccpc cPccc PccPc ccPcc
# pccpc cpccP ccPcc PcccP ccPcc cPccP ccpcc pccpc cpccp ccpcc
# Pccpc cpccp ccpcc pccpc cPccP cccPc cPccP cccPc cPccp ccpcc
# PccPc cPccc PccPc ccPcc Pccpc cpccp ccpcc pccpc cPccP cccPc
# pcCpc CpcCp ccPcc PcccP ccPcc cPccP ccPcc pccpc cpccp ccpcc
# cPccc PccPc cPccp ccpcc pccpc cpccP ccPcc PcccP ccPcc cPccP
# PccPc cPc
# ccPcc pcc

_fix3 = FixSlowMoI(141673, 141880, 35110, deint = 5, f = [ \
	[1,3,4,5,6,8,9,10,12,13,15,16,18,19,20,22,23,25,26,28,29,31,32,34,35,37,38,40,41,43,44,46,47,49,50,51,53,54,56,57,58,60,61,63,64,66,67,69,70,72,73,75,76,78,79,81,82,84,85,87,88,90,91,92,94,95,97,98,99,101,102,104,105,107,108,110,111,113,114,116,117,119,120,122,123,125,126,128,129,130,132,133,135,136,138,139,140,142,143,145,146,148,149,151,152,154,155,157,158,160,161,163,164,166,167,169,170,171,173,174,176,177,178,180,181,183,184,186,187,189,190,192,193,195,196,198,199,201,202,204,205,207], \
	[0,2,4,5,6,7,8,10,11,13,14,16,17,19,20,22,23,25,26,28,29,30,32,33,35,36,37,39,40,42,43,45,46,48,49,51,52,54,55,57,58,60,61,63,64,66,67,69,70,71,73,74,76,77,78,80,81,83,84,86,87,89,90,92,93,95,96,98,99,101,102,104,105,107,108,110,111,112,114,115,117,118,119,121,122,124,125,127,128,130,131,133,134,136,137,139,140,142,143,145,146,148,149,150,152,153,155,156,158,159,160,162,163,165,166,168,169,171,172,174,175,177,178,180,181,183,184,186,187,189,190,191,193,194,196,197,198,200,201,203,204,206], \
	[1] \
	])

	
# 0 h lhlh lhl hl <-- WTF
#
# 10 hl hlh lh lhl hlh lhl hl hlhl hl hlhl hl hlhl hl hlhl hl hlh
#                    ?        ?       ?       ?          ? 
# 55 lhl hlh lhl hlh lh lhlh lh lhlh lh lhlh lh lhlh lh lhl hlh lhl hlh lhl hl hlhl hl 
#    ?         ?        ?       ?          ?       ?        ?         ?        ?       
# 116 hlhl hl hlhl hl hlhl hl hlh lhl hlh lhl hlh lh lhlh lh lhlh lh lhlh lh lhlh lh
#        ?    ?          ?        ?         ?        ?       ?          ?       ?
# 175 lhl hlh lhl hlh lhl hl hlhl hl hlhl hl hlhl hl hlhl hl hlh lhl hlh lhl hlh lh 
#         ?         ?        ?          ?       ?       ?        ?         ?       
# 233 lhlh lh lhlh lh lhlh lh lhl hlh lhl hlh lhl hlh lhl hl hlhl hl hlhl hl hlhl
#     ?       ?          ?        ?         ?       ?        ?          ?       ?
# 290 hl hlh lhl hlh lhl hlh lh lhlh lh lhlh lh lhlh lh lhlh lh lhl hlh lhl hlh lhl
#            ?         ?        ?       ?       ?          ?        ?         ?
# 348 hl hlhl hl hlhl hl hlhl hl hlhl hl hlh lhl hlh lhl hlh lh lhlh lh lhlh lh lhlh lh lhlh lh l
#        ?       ?          ?       ?        ?         ?        ?          ?    ?          ?
	
function FixMegashadow(clip c, bool blend)
{
	Trim(c, 141673, 141880)
	
	ConvertToYV24(interlaced = true)

	Separatefields
	
	# first 5 frames are strange, starts on a half frame and the last has same fields with no pair anywhere
	
	c1 = Trim(0, 9).SelectEvery(10, 0,1, 4,3, 6,5, 8,9).Weave.AssumeFPS(c)
	c1 = c1.Trim(0,-1).nnedi3 + c1.Trim(1,0)

	if(blend)
	{
		c1 = c1.ScriptClip("BobMerge(GetParity(current_frame))")
	}
	
	DeleteFrame(22,28,34,40,49, \
		55,63,69,75,84,90,96,104,110, \		
		119,122,131,137,145,151,157,166,172, \
		178,186,192,201,207,213,219,227, \
		233,239,248,254,262,268,274,283,289, \
		295,303,309,315,321,330,336,344, \
		350,356,365,371,377,385,391,400,403,412)

	Trim(10, 0).SelectEvery(10, 0,1, 2,3, 6,5, 8,9).Weave.AssumeFPS(c)
	
	if(blend)
	{
		ScriptClip("BobMerge(GetParity(current_frame))")
	}
	else
	{
		ScriptClip("FixFieldOffset(GetParity(current_frame), offset = 0.25)")
	}
		
	c2 = last

	last = c1 + c2
	
	if(c.GetParity) {AssumeTFF}
	else {AssumeBFF}

	ConvertToYV12(interlaced = true)

	#FixSlowMoI(0, FrameCount - 1, 43850, pd = 0)
	FixSlowMoI(0, FrameCount - 1, 34950)
}

fix3 = FixMegashadow(true)

# prisoner flattened (first swing looks better without vertical mv search)

fix4_f = [ \
	[0,2,3,5,7,9,10,12,14,16,17,19,20,22,24,26,27,29,31,33,34,36,38,40,41,43,44,46,48,50,51,53,55,57,58,60,62,64,65,67,68], \
	[0,1,3,5,6,8,10,12,13,15,17,19,20,22,23,25,27,29,30,32,34,36,37,39,40,43,44,46,47,49,51,53,54,56,58,60,61,63,64,67,68] \
	]
fix4_1 = FixSlowMoI(41230, 41299, 52000, pd = 0, f = fix4_f, mv_search=6)
fix4_2 = FixSlowMoI(41230, 41299, 52000, pd = 0, f = fix4_f)
fix4 = Trim(fix4_1, 0, 13) + Trim(fix4_2, 14, 0)

# Zev on the bridge trying to command the Lexx with her hand (spoiler, did not work)

# 114071 c
#        c
# 114072 pccpc cpcpc cpcpc cpccp ccpcp cpccp ccpcc pccpc pcpcc pccpc
#        cpcpc cpccp ccpcc pcpcp ccpcc pccpc pccpc pccpc cpccp cpccp
# 114122 cpccp cpcpc cpccp ccpcp ccpcp ccpcc pccpc pccpc pccpc cpccp
#        cpccp ccpcc pcpcc pcpcc pccpc cpcpc pccpc cpccp ccpcp cpccp
# 114172 cpccp cpccp ccpcc pcpcp ccpcc pccpc cpcpc pccpc cpccp ccpcp
#        ccpcc pccpc pcpcc pccpc cpcpc cpcpc cpccp ccpcp ccpcp ccpcc
# 114222 cpccp ccpcc pccpc pcpcc pccpc cpcpc cpcpc cpccp ccpcp ccpcp
#        pccpc pccpc pccpc cpccp cpcpc cpccp ccpcc pcpcp ccpcc pccpc
# 114272 ccpcc pccpc pcpcc pccpc cpccp cpcpc cpccp ccpcc pcpcp ccpcc
#        cpcpc pccpc cpccp ccpcp cpccp ccpcc pcpcc pcpcc pccpc cpcpc
# 114322 pc
#        cp

#fix5 = FixSlowMoI(114071, 114323, 48300, pd = 0, f = [ \
fix5 = FixSlowMoI(114071, 114323, 38500, f = [ \
	[0,2,3,5,6,8,10,11,13,15,16,18,19,21,22,24,26,28,29,31,32,34,35,37,38,40,42,44,45,47,48,50,51,53,54,56,58,60,61,63,64,66,67,69,71,72,74,76,77,79,80,82,83,85,87,88,90,92,93,95,96,98,99,101,103,104,106,108,109,111,112,114,115,117,119,121,122,124,125,127,128,130,131,133,135,137,138,140,141,143,144,146,147,149,151,153,154,156,157,159,160,162,163,165,167,169,170,172,173,175,176,178,180,181,183,185,186,188,189,191,192,194,196,197,199,201,202,204,205,207,208,210,212,214,215,217,218,220,221,223,224,226,228,230,231,233,234,236,237,239,240,242,244,246,247,249,250,252], \
	[0,1,3,5,6,8,9,11,12,14,15,17,19,21,22,24,25,27,28,30,32,33,35,37,38,40,41,43,44,46,48,49,51,53,54,56,57,59,60,62,64,65,67,69,70,72,73,75,76,78,80,82,83,85,86,88,89,91,92,94,96,98,99,101,102,104,105,107,108,110,112,114,115,117,118,120,121,123,125,126,128,130,131,133,134,136,137,139,141,142,144,146,147,149,150,152,153,155,157,158,160,162,163,165,166,168,169,171,173,175,176,178,179,181,182,184,185,187,189,191,192,194,195,197,198,200,201,203,205,207,208,210,211,213,214,216,217,219,221,223,224,226,227,229,230,232,234,235,237,239,240,242,243,245,246,248,250,251] \
	])

# Bug Bomb (TM) falling down from the cable (one frame longer than needed, a half frame was hiding at 64092, keep that, drop last)

# 64085    cc ccccc
#          cc ccccc
# 64092 pcccp pcccp ccccp ccccp ccccp ccccp ccccp ccccp ccccp ccccp
#       Pcccp cpccc cpccc cpccc cpccc cpccc cpccc cpccc cpccc cpccc
# 64142 ccccp ccccp cccpc cccpc cccpc cccpc cccpc cccpc cc
#       cpccc cpccc cpccc pcccc pcccc pcccc pcccc pcccc pc

fix6 = FixSlowMoI(64085, 64183, f = [ \
	[0,1,2,3,4,5,6,7,8,9,10,11,12,13,15,15,16,17,18,19,20,21,26,25,28,29,30,31,34,33,36,35,38,39,40,41,44,43,46,45,48,49,50,51,54,53,56,55,58,59,60,61,64,63,66,65,68,69,70,71,74,73,76,75,78,79,80,81,84,83,86,85,88,89,90,91,94,93,96,95,98,99,100,101,104,103,106,105,108,109,110,111,114,113,116,115,118,119,120,121,124,123,126,125,128,129,130,131,134,133,136,135,138,139,142,141,144,143,146,147,148,149,152,151,154,153,156,157,158,159,162,161,164,163,166,167,168,169,172,171,174,173,176,177,178,179,182,181,184,183,186,187,188,189,192,191,194,193,196,197], [], \
	[0,2,4,6,8,10,12,15,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,118,120,122,124,126,128,130,132,134,136,138,140,142,144,146,148,150,152,154,156,158], \
	[0,2,4,6,8,10,12,15,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,118,120,122,124,126,128,130,132,134,136,138,140,142,144,146,148,150,152,154,156,158] \
	]).Trim(0, 64183 - 64085)

# Fat Zev

# 72760    pc
#          cc
# 72762 cccpc cpccp ccpcc ccpcc pccpc cpccc pcccp ccpcc pcccp cccpc
#       pccpc ccpcc cpccp ccpcc cpccc pccpc cpccc pcccp ccpcc pccpc
# 72812 cpccp cccpc ccpcc pccpc ccpcc cpccp ccp
#       cccpc cpccp ccpcc ccpcc pccpc cpccc cpc
     
fix7 = FixSlowMoI(72760, 72844, 34500, f = [ \
	[1,2,3,4,6,7,9,10,12,13,15,16,17,18,20,21,23,24,26,27,29,30,31,33,34,35,37,38,40,41,43,44,45,47,48,49,51,52,54,55,57,58,59,61,62,63,65,66,68,69,71,72,73,75,76,77,79,80,82,83], \
	[0,1,3,4,6,7,8,10,11,12,14,15,17,18,20,21,22,24,25,26,28,29,31,32,34,35,36,38,39,40,42,43,45,46,48,49,51,52,53,54,56,57,59,60,62,63,65,66,67,68,70,71,73,74,76,77,79,80,81,82] \
	])

# escape on the Lexx, oval display

fix8 = FixSlowMoI(119634, 119874, 42150, f = [ \
	[0,1,3,5,6,8,10,12,13,15,17,19,20,22,24,26,27,29,31,33,34,36,38,40,41,43,45,47,48,50,52,54,55,57,59,60,62,64,66,68,69,71,73,75,77,78,80,82,84,85,87,89,91,92,94,96,98,99,101,103,105,106,108,110,112,113,115,117,119,120,122,124,126,127,129,131,133,134,136,138,140,141,143,145,147,148,150,152,154,155,157,159,161,163,164,166,168,170,171,173,175,177,178,180,182,184,185,187,189,191,192,194,196,198,199,201,203,205,206,208,210,212,213,215,217,219,220,222,224,226,227,229,231,233,234,236,238,240], \
	[0,1,2,4,6,8,9,11,13,15,16,18,20,22,23,25,27,29,30,32,34,36,37,39,41,43,44,46,48,50,51,53,55,57,58,60,62,64,65,67,69,71,73,74,76,78,80,81,83,85,87,88,90,92,94,95,97,99,101,102,104,106,108,109,111,113,115,116,118,120,122,123,125,127,129,130,132,134,136,137,139,141,143,144,146,148,150,151,153,155,157,158,160,162,164,166,167,169,171,173,174,176,178,180,181,183,185,187,188,190,192,194,195,197,199,201,202,204,206,208,209,211,213,215,216,218,220,222,223,225,227,229,230,232,234,236,237,239] \
	])
	
# Kai jumping off the bridge of the Lexx
	
# 148670 pc
#        cc
# 148672 pcccc pcccc pccpc cccpc cccpc cpccc cpccc cpccp ccccp ccccp ccc
#        ccpcc ccpcc ccpcc pcccc pcccc pccpc cccpc cccpc cpccc cpccc cpc

fix9 = FixSlowMoI(148670, 148724, 31500, f = [ \
	[1,3,4,5,6,8,9,10,11,13,14,16,17,18,19,21,22,23,24,26,27,29,30,31,32,34,35,36,37,39,40,42,43,44,45,47,48,49,50,52,53,54], \
	[1,2,3,5,6,7,8,10,11,12,13,15,16,18,19,20,21,23,24,25,26,28,29,31,32,33,34,36,37,38,39,41,42,44,45,46,47,49,50,51,52,54] \
	])

# His Shadow going up on the column (typed it in twice, forgot to record it twice)

#fix10 = FixSlowMoI(33334, 33423, 29300, pd = 0, f = [ \
fix10 = FixSlowMoI(33334, 33423, pd = 0, f = [ \
	[0,0,2,1,4,3,6,5,7,7,8,9,11,11,12,13,15,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,38,40,39,42,42,44,43,46,46,48,47,50,49,52,51,54,53,56,55,58,57,60,59,62,61,64,63,66,65,68,67,69,69,70,71,73,73,74,75,77,77,78,79,81,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,100,102,101,104,104,106,105,108,108,110,109,112,112,114,113,116,115,118,117,120,119,122,121,124,123,126,125,128,127,130,129,131,131,132,133,135,135,136,137,139,139,140,141,143,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,162,164,163,166,166,168,167,170,170,172,171,174,174,176,175,178,177,179,179], [], \
	[1,2,4,6,9,10,13,14,17,18,20,22,24,26,28,30,32,34,36,38,41,42,45,46,49,50,52,54,56,58,60,62,64,66,68,70,73,74,77,78,81,82,85,86,88,90,92,94,96,98,100,102,105,106,109,110,113,114,117,118,120,122,124,126,128,130,132,134,137,138,141,142,145,146,149,150,152,154,156,158,160,162,164,166,169,170,173,174,177,178,181,182,184,187], \
	[0,2,4,6,9,10,13,14,17,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,73,74,77,78,81,82,85,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,118,120,122,124,126,128,130,132,134,137,138,141,142,145,146,149,150,152,154,156,158,160,162,164,166,168,170,172,174,176,178,180,182,184,187] \
	]).Trim(4, 0) # first frame is blank, and with 3 more trimmed there is no need to change the fps

# Bug Bomb spinning

# every other frame, no blending
# fix11 = FixSlowMoI(64775, 64814, 15000, f = [ \

# blended frames, feels kinda nice
# fix11 = FixSlowMoI(64775, 64814, 19000, pd = 0, f = [ \

# it's rotating and the same frames are repeating, get the required number
fix11 = FixSlowMoI(64775, 64814, 30000, pd = 0, f = [ \
	[0,0,1,1,2,2,3,3,4,5,6,6,7,7,8,8,10,9,11,11,12,12,13,13,14,15,16,16,17,17,18,18,20,19,21,21,22,22,23,23,24,25,26,26,28,27,29,29,30,30,31,31,32,33,34,34,35,35,36,36,38,37,39,39,40,40,41,41,42,43,44,44,45,45,46,46,48,47,49,49,50,50,51,51,52,53,54,54,55,55,56,56,58,57,59,59,60,61,62,62,63,63,64,64,66,65,67,67,68,68,69,69,70,71,72,72,73,73,74,74,76,75,77,77,78,78,79,79], [], \
	[1,3,5,7,8,11,13,15,16,19,21,23,24,27,29,31,32,35,37,39,40,43,44,47,49,51,52,55,57,59,60,63,65,67,68,71,73,75,76,79,81,83,84,87,89,91,92,95,96,99,101,103,104,107,109,111,112,115,117,119,120,123,125,127] \
	]).Trim(0, 64814 - 64775)

# hand weave
	
# 85474 011 24455 68899 02233 46
#       012 33456 77890 11234 55

#_fix12 = FixSlowMoI(85210, 85546, 30000, pd = 2, fc = 10, deintf = -1, f = [ \
#_fix12 = FixSlowMoI(85210, 85546, 30000, pd = 2, fc = 10, deint = 3, deintf = 1, f = [ \
#	[0,1,4,3,5,5,6,9], [], \
#	[0,2,5,6] \
#	]).Trim(0, 85546 - 85210)
#_fix12 = FixSlowMoI(85474, 85546, 30000, pd = 0, fc = 40, f = [ \
#	[0,1,2,3,6,5,7,7,8,11,12,13,16,15,17,17,18,21,22,23,26,25,27,27,28,31,32,33,36,35,37,37,38,38], [], \
#	[0,2,4,7,8,10,12,15,16,18,20,23,24,26,28,31,33], \
#	[0,2,4,7,8,10,12,15,16,18,20,23,24,26,28,31,32] \
#	])
#return _fix12

# no motion-adaptive deinterlacer yet, a single frame looks better if deinterlaced by a TFM override

fix12 = Trim(85210, 85546)

# brain zoom-in

# 135446 0 13456 79012 34578 90134 56790 12356 78912 34
#        1 23457 89013 45679 01235 67891 23457 89013 45
       
fix13 = FixSlowMoI(135446, 135483, 25000, pd = 0, f = [ \
	[0,0,2,1,3,3,4,5,6,7,8,9,10,10,12,11,13,13,14,15,16,17,18,19,20,20,22,21,24,23,26,25,27,27,28,29,30,30,32,31,34,33,36,35,37,37,38,39,40,40,42,41,44,43,46,45,47,47,48,49,50,50,52,51,54,53,56,55,57,57,58,59,60,60,62,61,64,63,66,65,67,67,68,69,70,70,72,71,74,73,75,75], [], \
	[1,2,5,6,8,10,13,14,17,18,20,22,25,26,28,30,33,34,37,38,40,42,45,46,49,50,52,54,57,58,61,62,64,66,69,70,73,74,76,78,81,82,85,86,88,91] \
	])
	
# lizard #1

# 137348 0224 56789 01234 66890 12345 67
#        1234 56880 12345 67890 12446 78

#fix14 = FixSlowMoI(137348, 137373, 27800, pd = 0, f = [ \
fix14 = FixSlowMoI(137348, 137373, 30000, pd = 0, f = [ \
	[0,0,1,1,2,3,5,5,6,7,8,9,10,11,12,12,14,13,16,16,18,17,20,19,22,21,24,23,26,25,27,27,28,29,31,31,32,33,34,35,36,37,38,39,40,41,42,42,44,43,46,46,48,47,50,49,51,51], [], \
	[1,3,4,7,8,10,12,15,16,19,20,22,24,26,28,31,32,35,36,38,40,42,44,47,48,51,52,54,57], \
	[0,3,4,7,8,10,12,14,16,18,20,22,24,26,28,31,32,35,36,38,40,42,44,46,48,50,52,54,57] \
	]).Trim(0, length = 137373 - 137348 + 1)

# lizard #2

# 137274 001 23445 
#        012 23456
# 137282 78902 34568 90124 56780 12346 78901 23456 78901 23
#        78012 34678 90234 56890 12456 79012 34567 89012 34
       
#fix15 = FixSlowMoI(137274, 137323, 30000, pd = 0, f = [ \
fix15 = FixSlowMoI(137274, 137323, 27750, pd = 0, f = [ \
	[0,1,4,3,6,5,8,9,10,11,14,13,15,15,16,17,18,19,20,20,22,21,23,23,24,25,26,27,28,29,30,30,32,31,33,33,34,35,36,37,38,39,40,40,42,41,43,43,44,45,46,47,48,49,50,50,52,51,53,53,54,55,56,57,58,59,60,60,62,61,63,63,64,65,66,67,68,68,70,69,72,71,74,73,76,75,78,77,80,79,82,81,84,83,86,85,88,87,90,89,92,91,94,93,96,95,98,97,99,99], [], \
	[0,2,4,6,8,10,13,14,16,19,20,23,24,26,28,31,32,35,36,38,40,43,44,47,48,50,52,55,56,59,60,62,64,67,68,71,72,74,77,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,109], \
	[0,2,4,6,8,10,13,14,16,18,20,23,24,26,28,30,32,35,36,38,40,42,44,47,48,50,52,54,56,59,60,62,64,66,68,71,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,109] \
	])

# bridge to the Lexx #3

# 102297 pcccc pccpc cccpc cpccc cpccp cccpc ccpcc cpc
#        ccpcc pcccc pccpc cccpc cpccc cpccp ccccp ccp

fix16 = FixSlowMoI(102297, 102334, 32300, pd = 3, f = [ \
	[1,2,3,4,6,7,9,10,11,12,14,15,17,18,19,20,22,23,25,26,27,29,30,31,33,34,35,37], \
	[0,1,3,4,6,7,8,9,11,12,14,15,16,17,19,20,22,23,24,25,27,28,30,31,32,33,35,36] \
	])
	
# blinking cursor (60 fps)

fix17 = Trim(72686, 72759).InsideToFilm(3, 550, 300, 580, 340, blend_fields = true)
fix18 = Trim(72845, 72959).InsideToFilm(4, 550, 300, 580, 340, blend_fields = true)
fix19 = Trim(73326, 73429).InsideToFilm(1, 604, 340, 630, 374, blend_fields = true)

#return showfields(false)

Trim(0,18260) + \
fix1 + \
Trim(18726,33333) + \
fix10 + \
Trim(33424,41229) + \
fix4 + \
Trim(41300,46848) + \
fix2 + \
Trim(46969,64084) + \
fix6 + \
Trim(64184,64774) + \
fix11 + \
Trim(64815,72685) + \
fix17 + \
fix7 + \
fix18 + \
Trim(72960,73325) + \
fix19 + \
Trim(73430,85209) + \
fix12 + \
Trim(85547,102296) + \
fix16 + \
Trim(102335,114070) + \
fix5 + \
Trim(114324,119633) + \
fix8 + \
Trim(119875,135445) + \
fix13 + \
Trim(135484,137273) + \
fix15 + \
Trim(137324,137347) + \
fix14 + \
Trim(137374,141672) + \
fix3 + \
Trim(141881,148669) + \
fix9 + \
Trim(148725,0)
