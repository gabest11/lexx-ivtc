Import("../../common.avsi")

LoadEpisodeWithAlt("S02E09", 86045, \
	["..\..\S02(Acorn)\V03\title_t00.d2v"], \
	["..\..\S02(Acorn)\D05\title_t00.d2v"])

Trim(0, 4179) + \
FixPP(4180, 4278, 2, mv_blksize=8, mv_overlap=4) + \
Trim(4279, 4469) + \
FixPP(4470, 4720, 3, ignore=[4512, 4513, 4522, 4523]) + \
Trim(4721, 6368) + \
Trim(6369, 6506).InsideToFilm(5, 230, 0, 490, 200) + \
Trim(6507, 9647) + \
FixPP(9648, 9715, 4) + \
Trim(9716, 75299) + \
FixPP(75300, 75385, 2, mv_blksize=8, mv_overlap=4) + \
Trim(75386, 75470) + \
FixPP(75471, 75526, 4, mv_blksize=8, mv_overlap=4) + \
Trim(75527, 78549) + \
FixPP(78550, 78611, 4, ignore=[78553,78554]) + \
Trim(78612, 79093) + \
FixPP(79094, 79222, 5, ignore=[79128,79129,79133,79134,79138,79139]) + \
Trim(79223, 79262) + \
FixPP(79263, 79332, 5, ignore=[79263,79332]) + \
Trim(79333, 81275) + \
FixPP(81276, 81374, 5, mv_blksize=32, mv_overlap=16) + \
Trim(81375, 0)
