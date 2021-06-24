Import("../../common.avsi")

LoadEpisodeWithAlt("S04E17", 80470, \
	["..\..\S04(Acorn)\V05\title_t00.d2v"], \
	["..\..\S04(Acorn)\D09\title_t00.d2v"])
	
# moth flying over the clouds

# 22760 cpccc pcccc pccpc cccpc cpccc cpccc cpccp ccccp ccpcc ccpcc
#       ccpcc ccpcc pcccc pcccc pccpc cccpc cpccc cpccc pcccp ccccp
# 22810 cpccc pcccc pccpc cccpc cpccc cpccc cpccp ccccp ccpcc ccpcc
#       ccpcc ccpcc cpccc pcccc pccpc cccpc cpccc cpccc cpccp ccccp
# 22860 c
#       c
      
fix1 = FixSlowMoI(22760, 22860, 31600, fin = 30, f = [ \
	[0,2,3,4,6,7,8,9,11,12,14,15,16,17,19,20,22,23,24,25,27,28,29,30,32,33,35,36,37,38,40,41,43,44,45,46,48,49,50,52,53,54,56,57,58,59,61,62,64,65,66,67,69,70,72,73,74,75,77,78,79,80,82,83,85,86,87,88,90,91,93,94,95,96,98,99,100], \
	[0,1,3,4,5,6,8,9,11,12,13,14,16,17,18,19,21,22,24,25,26,27,29,30,32,33,34,35,37,38,39,41,42,43,45,46,47,48,50,51,53,54,55,56,58,59,60,62,63,64,66,67,68,69,71,72,74,75,76,77,79,80,82,83,84,85,87,88,89,90,92,93,95,96,97,98,100] \
	])

# another moth fly-by, wings dragging space-time a bit
	
# 62170                                                        cpcp
#                                                              cpcc
# 62175 ccpcp ccpcc pccpc cpccp ccpcp ccpcp ccpcc pccpc cpccp ccpcp
#       pccpc cpccp cpccp cpccp ccpcc pccpc cpccp cpccp cpccp ccpcc
# 62225 ccpcp ccpcc pccpc cpccp ccpcp ccpcp ccpcc p
#       pccpc cpccp cpccp cpccp ccpcc pccpc cpccp c
      
fix2 = FixSlowMoI(62171, 62260, 37700, fc = 50, f = [ \
	[0,2,4,5,7,9,10,12,13,15,16,18,19,21,22,24,25,27,29,30,32,34,35,37,38,40,41,43,44,46,47,49], \
	[0,2,3,5,6,8,9,11,12,14,16,17,19,21,22,24,25,27,28,30,31,33,34,36,37,39,41,42,44,46,47,49] \
	])

Trim(0, 22759) + \
fix1 + \
Trim(22861, 62170) + \
fix2 + \
Trim(62261, 0)
