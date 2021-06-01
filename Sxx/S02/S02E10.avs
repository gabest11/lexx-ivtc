Import("../../common.avsi")

LoadEpisodeWithAlt("S02E10", 86135, \
	["..\..\S02(Acorn)\V03\title_t01.d2v"], \
	["..\..\S02(Acorn)\D05\title_t01.d2v"])


Trim(0, 77724) + \
Trim(77725, 77880) + \
Trim(77881, 0)
#FixPP(77725, 77880, 5, mv_blksize=16, mv_overlap=4, ignore=[77734,77735,77739,77740,77774,77775,77784,77785]) + \
