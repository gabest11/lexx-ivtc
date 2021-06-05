Import("../../common.avsi")

LoadEpisodeWithAlt("S02E20", 86105, \
	["..\..\S02(Koch)\V05\title_t06.d2v"], \
	["..\..\S02(Acorn)\D10\title_t01.d2v"])

Trim(0, 2378) + \
FixPP(2379, 2540, 3) + \
Trim(2541, 14431) + \
Trim(14432, 14727).BottomToVideo(5, 240) + \
Trim(14728, 22610) + \
FixPP(22611, 22743, 2, mv_blksize=8, mv_overlap=4) + \
Trim(22744, 23906) + \
Trim(23907, 37016) + \
FixPP(37017, 37060, 1) + \
Trim(37061, 39089) + \
FixPP(39090, 39122, 3) + \
Trim(39123, 48160) + \
FixPP(48161, 48251, 4) + \
Trim(48252, 48398) + \
FixPP(48399, 48476, 3) + \
Trim(48477, 52130) + \
FixPP(52131, 52354, 3) + \
Trim(52355, 0)

