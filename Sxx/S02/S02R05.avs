Import("../../common.avsi")

LoadEpisodeWithAlt("S02R05", 17580, \
	["..\..\S02(Koch)\V05\title_t03.d2v"], \
	["..\..\S02(Acorn)\D10\title_t03.d2v"])

# moth flying over the exploding gigashadow (scene from S01E04)

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

fix1 = FixSlowMoI(10375, 10528, 38130, fc = 19, f = [ \
	[1,3,5,6,7,9,10,12,13,15,16,19], \
	[0,2,3,5,6,8,10,12,13,15,16,18] \
	])

Trim(0, 10374) + \
fix1 + \
Trim(10529, 0)