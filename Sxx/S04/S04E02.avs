Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S04E02", 81230, \
	["..\..\S04(Koch)\V01\title_t01.d2v"], \
	["..\..\S04(Acorn)\D01\title_t01.d2v"])

# denoise single field sections

Fix240p(title)


