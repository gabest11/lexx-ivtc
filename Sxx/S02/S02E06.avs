Import("../../common.avsi")

LoadEpisodeWithAlt("S02E06", 86075, \
	["..\..\S02(Acorn)\V02\title_t01.d2v"], \
	["..\..\S02(Acorn)\D03\title_t00.d2v", 86160])

# Mega Shadow on Stanley's display (Alliance has a bit higher bitrate, but swapped field order)

try
{
	c = LoadEpisodeWithAlt("S01E04", 0, \
		["..\..\S01(Alliance)\D04\title_t00.d2v", 30, true], \
		["..\..\S01(Koch)\D04\title_t00p1.d2v"])

	# S02E06 38160,38216 (57) cppcc 38217,38402 c (186)
	# S01E04 38240,38296 (57) cppcc 38297,38396 pcccp (100)
	# turn S01E04's 38240,38396 (157) into 38160,38402 (243)

	#fix1 = FixSlowMoI(c, 38240, 38396, 46500, pd = 2, ivtc = 2)
	#fix1 = FixSlowMoI(c, 38240, 38396, 58100, pd = 0, ivtc = 2)	
	fix1 = Trim(c, 38240, 38249) + FixSlowMoI(c, 38250, 38396, 47500, pd = 2, ivtc = 2)
	
	Trim(0, 38159) + \
	fix1 + \
	Trim(38403, 0)
}
catch(msg)
{
	assert(false, "undo fix1 in the override files")
}

