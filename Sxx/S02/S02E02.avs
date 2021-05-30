Import("../../common.avsi")

LoadEpisodeWithAlt("S02E02", 86115, \
	["..\..\S02(Acorn)\V01\title_t01.d2v"], \
	["..\..\S02(Acorn)\D01\title_t00.d2v", 86115])

# Stanley pushed on a bed

# 18785 cpccp ccpcc pccpc cpccp ccpcc pccpc cpccp ccpcc cpccp cccpc
#       cpccp ccpcc pccpc ccpcc pcccp ccpcc pccpc cpccp ccpcc pccpc
# 18835 cpccp ccpcc pccpc cpccp ccpcc pccpc cpccp cccpc cpccc pccpc
#       cpccp ccpcc pcccp ccpcc cpccp ccpcc pccpc cpccp ccpcc pccpc
# 18885 cpccp ccpcc pccpc cpccp ccpcc pccpc cpccc pccpc c 
#       cpccp ccpcc cpccp cccpc cpccp ccpcc pccpc cpccp c

#fix1 = FixSlowMoI(18785, 18925, 44300, pd = 0, f = [ \
fix1 = FixSlowMoI(18785, 18925, 35500, f = [ \
	[0,2,3,5,6,8,9,11,12,14,15,17,18,20,21,23,24,26,27,29,30,32,33,35,36,38,39,40,42,43,45,46,47,49,50,52,53,55,56,58,59,61,62,64,65,67,68,70,71,73,74,76,77,79,80,82,83,85,86,87,89,90,92,93,94,96,97,99,100,102,103,105,106,108,109,111,112,114,115,117,118,120,121,123,124,126,127,129,130,132,133,134,136,137,139,140], \
	[0,2,3,5,6,8,9,11,12,14,15,16,18,19,21,22,23,25,26,28,29,31,32,34,35,37,38,40,41,43,44,46,47,49,50,52,53,55,56,58,59,61,62,63,65,66,68,69,70,72,73,75,76,78,79,81,82,84,85,87,88,90,91,93,94,96,97,99,100,102,103,105,106,108,109,110,112,113,115,116,117,119,120,122,123,125,126,128,129,131,132,134,135,137,138,140] \
	])

# funky bar

_fix2 = FixPP(33914, 34278, 4) # bg 29.97, does not look good when two frame is skipped and interpolated to one

fix2 = Trim(33914, 34278)

# old lady pushed out to space

fix3 = FixPPVideo(50880, 50917, 4)
fix4 = Trim(50950, 51024) # FixPPVideo(50950, 51024, 4, mv_searchparam = 1) # bad results, when the door opens

#

#return showfields
	
Trim(0, 18784) + \
fix1 + \
Trim(18926, 33913) + \
fix2 + \
Trim(34279, 50879) + \
fix3 + \
Trim(50918, 50949) + \
fix4 + \
Trim(51025, 0)
