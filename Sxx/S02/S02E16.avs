Import("../../common.avsi")

LoadEpisodeWithAlt("S02E16", 86105, \
	["..\..\S02(Acorn)\V04\title_t05.d2v"], \
	["..\..\S02(Acorn)\D08\title_t01.d2v"])

# Web and Net are very similar episodes, one can be used to fix the other

try
{
	c = LoadEpisodeWithAlt("S02E17", 0, \
		["..\..\S02(Koch)\V05\title_t00.d2v"], \
		["..\..\S02(Acorn)\D09\title_t00.d2v"])

	Trim(0, 33442) + \
	Trim(c, 23159, 23225) + \
	Trim(33510, 33838) + \
	Trim(c, 23555, 23712) + \
	Trim(33997, 34116) + \
	Trim(c, 23833, 23866) + \
	Trim(34151, 0)
}
catch(msg)
{
	assert(false, "undo fix1 in the override files")
}

Trim(0, 74253) + \
FixPPVideo(74254, 74334, 3, mv_blksize=16, mv_overlap=8) + \
Trim(74335, 0)
