Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S03E09", 86050, \
	["..\..\S03(Alliance)\V03\title_t01.d2v", -15], \
	["..\..\S03(Acorn)\V03\title_t01.d2v"], \
	["..\..\S03(Acorn)\D05\title_t00.d2v"])

#return detect240p
#return showfields(false)
	
# denoise single field sections

Fix240p(title)

#

# TODO: text

Trim(0, 5807) + \
Trim(5808, 5896).BlendFieldsWithText(164, 364, 558, 430) + \
Trim(5897, 5918).BlendFields + \ 
Trim(5919, 6662) + \
Trim(6663, 6694).BlendFields + \
Trim(6695, 6782).BlendFieldsWithText(206, 368, 512, 430) + \
Trim(6783, 6814).BlendFields + \
Trim(6815, 6902).BlendFieldsWithText(148, 370, 572, 432) + \
Trim(6903, 6934).BlendFields + \
Trim(6935, 7022).BlendFieldsWithText(210, 368, 504, 430) + \
Trim(7023, 7064).BlendFields + \
Trim(7065, 18160) + \
Trim(18161, 18313).OutsideToFilm(3, 280, 300, 530, 480) + \
Trim(18314, 60384) + \
Trim(60385, 60464).InsideToFilm(4, 320, 0, 410, 70) + \
Trim(60465, 60630) + \
Trim(60631, 60745).InsideToFilm(4, 462, 90, 600, 220) + \
Trim(60746, 60823).InsideToFilm(4, 430, 40, 530, 140) + \
Trim(60824, 64181) + \
FixPP(64182, 64298, 3) + \
Trim(64299, 65115) + \
FixPP(65116, 65199, 2) + \
Trim(65200, 0)
