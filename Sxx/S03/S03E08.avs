Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S03E08", 86060, \
	["..\..\S03(Alliance)\V03\title_t00.d2v", -15], \
	["..\..\S03(Acorn)\V03\title_t00.d2v"], \
	["..\..\S03(Acorn)\D04\title_t00.d2v"])

#return detect240p
	
# denoise single field sections

Fix240p(title)
