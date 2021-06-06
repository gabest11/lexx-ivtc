Import("../../common.avsi")

LoadEpisodeWithAlt("S02R02", 18030, \
	["..\..\S02(Acorn)\V02\title_t06.d2v"], \
	["..\..\S02(Acorn)\D03\title_t01.d2v"])

# prisoner flattened (first swing looks better without vertical mv search) (scene from S01E01)

fix4_f = [ \
	[0,2,3,5,7,9,10,12,14,16,17,19,20,22,24,26,27,29,31,33,34,36,38,40,41,43,44,46,48,50,51,53,55,57,58,60,62,64,65,67,68], \
	[0,1,3,5,6,8,10,12,13,15,17,19,20,22,23,25,27,29,30,32,34,36,37,39,40,43,44,46,47,49,51,53,54,56,58,60,61,63,64,67,68] \
	]
fix4_1 = FixSlowMoI(10926, 10995, 52000, pd = 0, f = fix4_f, mv_search=6)
fix4_2 = FixSlowMoI(10926, 10995, 52000, pd = 0, f = fix4_f)
fix4 = Trim(fix4_1, 0, 13) + Trim(fix4_2, 14, 0)

Trim(0, 10925) + \
fix4 + \
Trim(10996, 0)