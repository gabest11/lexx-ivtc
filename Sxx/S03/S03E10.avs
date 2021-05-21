Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S03E10", 86050, \
	["..\..\S03(Alliance)\V03\title_t02.d2v", -15], \
	["..\..\S03(Acorn)\V03\title_t02.d2v"], \
	["..\..\S03(Acorn)\D05\title_t01.d2v"])

#return detect240p
	
# denoise single field sections

Fix240p(title)
