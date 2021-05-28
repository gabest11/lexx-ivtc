Import("../../common.avsi")

LoadEpisodeWithAlt("S04E23", 81210, \
	["..\..\S04(Koch)\V0\title_t.d2v"], \
	["..\..\S04(Acorn)\D12\title_t03.d2v"])
	
Trim(0,829) + \
Trim(830,1201).BlendFields + \
Trim(1202,-0)

