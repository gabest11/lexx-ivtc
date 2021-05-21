Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S03E11", 86040, \
	["..\..\S03(Alliance)\V04\title_t00.d2v", -10], \
	["..\..\S03(Acorn)\V04\title_t00.d2v"], \
	["..\..\S03(Acorn)\D06\title_t00.d2v"])

#return detect240p
	
# denoise single field sections

Fix240p(title)

