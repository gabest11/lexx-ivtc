Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S04E11", 79605, \
	["..\..\S04(Koch)\V03\title_t05.d2v"], \
	["..\..\S04(Acorn)\D06\title_t03.d2v"])
	
#return ConvertToY8.Detect240p.Levels(96,1,160,0,255)

# denoise single field sections

Fix240p(title)
