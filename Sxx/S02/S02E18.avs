Import("../../common.avsi")

LoadEpisodeWithAlt("S02E18", 86105, \
	["..\..\S02(Koch)\V05\title_t01.d2v"], \
	["..\..\S02(Acorn)\D09\title_t01.d2v"])

Trim(0, 45120) + \
FixPP(45121, 45255, 1) + \
Trim(45256, 45990) + \
FixPP(45991, 46081, 4) + \
Trim(46082, 46331) + \
FixPP(46332, 46558, 4) + \
Trim(46559, 0)
