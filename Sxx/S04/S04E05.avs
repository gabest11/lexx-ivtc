Import("../../common.avsi")

LoadEpisodeWithAlt("S04E05", 81270, \
	["..\..\S04(Acorn)\V02\title_t00.d2v"], \
	["..\..\S04(Acorn)\D03\title_t00.d2v"])
	
# contestants emerging from the ocean (single field, nnedi3 before fps change)

#fix1 = FixSlowMoI(16166, 16325, 75750, pd = 0, fc = 10, fin = 160, f = [ \
fix1 = FixSlowMoI(16166, 16325, 60500, fc = 10, fin = 160, f = [ \
	[0,2,6,8], \
	[0,2,6,8] \
	])

fix2 = FixSlowMoI(16326, 16384, 61000, fc = 10, fin = 59, f = [ \
	[0,2,6,8], \
	[0,2,6,8] \
	]).Letterbox(0,0,6,6)

# Xev, just doubling the frames in an even distribution, interpolation looks wierd

fix3 = FixSlowMoI(16532, 16621, fin = 90, fc = 10, f = [ \
	[1,1,3,3,7,7,9,9], \
	[1,1,3,3,7,7,9,9] \
	])

# moth flying over some terran

fix4 = FixSlowMoI(38497, 38574, 34400, f = [ \
	[0,2,3,5,6,8,9,10,12,13,15,16,18,19,20,22,23,25,26,27,29,30,32,33,35,36,37,39,40,42,43,44,46,47,49,50,52,53,54,56,57,59,60,61,63,64,66,67,69,70,71,73,74,76,77], \
	[0,1,3,4,6,7,9,10,11,13,14,16,17,19,20,22,23,24,26,27,28,30,31,33,34,35,37,38,40,41,43,44,45,47,48,50,51,52,54,55,57,58,60,61,62,64,65,67,68,69,71,72,74,75,77] \
	])

# Lexx and a moth flying towards the Earth (TODO: this is one of those parity changing scenes)
#
# too long with pulldown
# too short with no dups
# space-time bends with fps change
# 
# Trim the pulldown version, -9 frames

#_fix5 = FixSlowMoI(11210, 11331, 34600, pd = 0, fc = 15, f = [ \
fix5 = FixSlowMoI(11210, 11331, 30000, fc = 15, f = [ \
	[0,1,3,4,5,6,7,8,9,11,12,13,14], \
	[0,1,2,3,4,6,7,8,9,10,11,12,14] \
	]).Trim(0, length = 11331 - 11210 + 1)

try
{
	# better alternative to fix5, if you have S04E08
	# it has exactly the same shorter frame count, just sharper

	c = LoadEpisodeWithAlt("S04E08", 81285, \
		["..\..\S04(Acorn)\V02\title_t03.d2v"], \
		["..\..\S04(Acorn)\D04\title_t01.d2v"])
		
	fix5 = Trim(c, 18410, 18531)
}
catch(msg)
{
}		
	
Trim(0, 11209) + \
fix5 + \
Trim(11332, 16165) + \
fix1 + \
fix2 + \
Trim(16385, 16531) + \
fix3 + \
Trim(16622, 38496) + \
fix4 + \
Trim(38575, 0)
