Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S03E12", 86035, \
	["..\..\S03(Alliance)\V04\title_t01.d2v", -10], \
	["..\..\S03(Acorn)\V04\title_t03.d2v"], \
	["..\..\S03(Acorn)\D06\title_t03.d2v"])

#return detect240p
#return showfields(false)
	
# denoise single field sections

Fix240p(title)

#

Trim(0, 11821) + \
Trim(11822, 11851).InsideToFilm(1, 438, 228, 484, 244) + \
Trim(11852, 11923).InsideToFilm(1, 470, 232, 560, 270) + \
Trim(11924, 12175) + \
Trim(12176, 12279).InsideToFilm(3, 574, 254, 720, 304) + \
Trim(12280, 17576) + \
FixPP(17577, 17842, 3) + \
Trim(17843, 18027) + \
FixPP(18028, 18159, 5) + \
Trim(18160, 18233) + \
FixPP(18234, 18337, 1) + \
Trim(18338, 0)
