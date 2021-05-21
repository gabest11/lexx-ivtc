Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S03E13", 86025, \
	["..\..\S03(Alliance)\V04\title_t02.d2v", -20], \
	["..\..\S03(Acorn)\V04\title_t04.d2v"], \
	["..\..\S03(Acorn)\D07\title_t02.d2v"])

#return detect240p
	
# denoise single field sections

Fix240p(title)
