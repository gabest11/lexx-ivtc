Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S03E07", 86080, \
	["..\..\S03(Alliance)\V02\title_t02.d2v", -30], \
	["..\..\S03(Acorn)\V02\title_t03.d2v"], \
	["..\..\S03(Acorn)\D04\title_t02.d2v"])

#return detect240p

# denoise single field sections

Fix240p(title)
