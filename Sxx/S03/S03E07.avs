Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S03E07", 86080, \
	["..\..\S03(Alliance)\V02\title_t02.d2v", -30], \
	["..\..\S03(Acorn)\V02\title_t03.d2v"], \
	["..\..\S03(Acorn)\D04\title_t02.d2v"])

#return detect240p

# denoise single field sections

Fix240p(title)

#

# 0,179
Trim(0, 179).BlendFieldsWithText(278, 388, 652, 430) + \
Trim(180, 5701) + \
Trim(5702, 5709).BlendFields + \
Trim(5710, 5798).BlendFieldsWithText(226, 372, 494, 430) + \
Trim(5799, 5807).BlendFields + \
Trim(5808, 5896).BlendFieldsWithText(240, 372, 492, 430) + \
Trim(5897, 6001) + \
Trim(6002, 6092).BlendFieldsWithText(148, 368, 568, 430) + \
Trim(6093, 6103).BlendFields + \
Trim(6104, 6192).BlendFieldsWithText(154, 368, 560, 432) + \
Trim(6193, 6204).BlendFields + \
Trim(6205, 6294).BlendFieldsWithText(206, 368, 512, 430) + \
Trim(6295, 6365) + \
Trim(6366, 6376).BlendFields + \
Trim(6377, 6465).BlendFieldsWithText(148, 368, 570, 430) + \
Trim(6466, 6492).BlendFields + \
Trim(6493, 6565) + \
Trim(6566, 6650).BlendFieldsWithText(210, 368, 502, 430) + \
Trim(6651, 6724) + \
Trim(6725, 6815).BlendFieldsWithText(138, 366, 586, 430) + \
Trim(6816, 6856).BlendFields + \
Trim(6857, 6945).BlendFieldsWithText(210, 306, 506, 436) + \
Trim(6946, 6997).BlendFields + \
Trim(6998, 7086).BlendFieldsWithText(184, 362, 536, 428) + \
Trim(7087, 7138).BlendFields + \
Trim(7139, 0)