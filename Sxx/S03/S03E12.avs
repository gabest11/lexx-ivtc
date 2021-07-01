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

Trim(0, 6373) + \
Trim(6374, 6384).BlendFields + \
Trim(6385, 6472).BlendFieldsWithText(238, 374, 492, 430) + \
Trim(6473, 6478).BlendFields + \
Trim(6479, 6563) + \
Trim(6564, 6659).BlendFieldsWithText(148, 368, 568, 432) + \
Trim(6660, 6791) + \
Trim(6792, 6807).BlendFields + \
Trim(6808, 6896).BlendFieldsWithText(154, 370, 562, 430) + \
Trim(6897, 6911).BlendFields + \
Trim(6912, 6996).BlendFieldsWithText(206, 370, 514, 430) + \
Trim(6997, 7096) + \
Trim(7097, 7112).BlendFields + \
Trim(7113, 7201).BlendFieldsWithText(148, 370, 570, 432) + \
Trim(7202, 7212).BlendFields + \
Trim(7213, 7253) + \
Trim(7254, 7285).BlendFields + \
Trim(7286, 7370).BlendFieldsWithText(212, 368, 502, 430) + \
Trim(7371, 7408).BlendFields + \
Trim(7409, 7500).BlendFieldsWithText(138, 366, 584, 430) + \
Trim(7501, 7590).BlendFields + \
Trim(7591, 11821) + \
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
