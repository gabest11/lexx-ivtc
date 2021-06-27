Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S03E11", 86040, \
	["..\..\S03(Alliance)\V04\title_t00.d2v", -10], \
	["..\..\S03(Acorn)\V04\title_t00.d2v"], \
	["..\..\S03(Acorn)\D06\title_t00.d2v"])

#return detect240p
#return showfields(false)
	
# denoise single field sections

Fix240p(title)

#

Trim(0, 6271) + \
Trim(6272, 6282).BlendFields + \
Trim(6283, 6371).BlendFieldsWithText(154, 368, 560, 430) + \
Trim(6372, 6433).BlendFields + \
Trim(6434, 6852) + \
Trim(6853, 6862).BlendFields + \
Trim(6863, 6952).BlendFieldsWithText(212, 368, 502, 430) + \
Trim(6953, 7009).BlendFields + \
Trim(7010, 0)
