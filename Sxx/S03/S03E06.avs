Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S03E06", 86060, \
	["..\..\S03(Alliance)\V02\title_t01.d2v", -30], \
	["..\..\S03(Acorn)\V02\title_t01.d2v"], \
	["..\..\S03(Acorn)\D03\title_t01.d2v"])

#return detect240p
#return showfields(false)
	
# denoise single field sections

Fix240p(title)
