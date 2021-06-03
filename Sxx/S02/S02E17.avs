Import("../../common.avsi")

LoadEpisodeWithAlt("S02E17", 86105, \
	["..\..\S02(Koch)\V05\title_t00.d2v"], \
	["..\..\S02(Acorn)\D09\title_t00.d2v"])

Trim(0, 66813) + \
FixPPVideo(66814, 66894, 3, mv_blksize=16, mv_overlap=8) + \
Trim(66895, 0)
