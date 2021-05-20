Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S03E05", 86090, \
	["..\..\S03(Alliance)\V02\title_t00.d2v", -30], \
	["..\..\S03(Acorn)\V02\title_t00.d2v"], \
	["..\..\S03(Acorn)\D03\title_t00.d2v"])

#return detect240p
	
# denoise single field sections

Fix240p(title)

Info