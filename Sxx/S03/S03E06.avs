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

#

Trim(0, 3970) + \
Trim(3971, 3987).BlendFields + \
Trim(3988, 4076).BlendFieldsWithText(174, 322, 550, 428) + \
Trim(4077, 4128).BlendFields + \
Trim(4129, 4216).BlendFieldsWithText(240, 374, 492, 430) + \
Trim(4217, 4238).BlendFields + \
Trim(4239, 4328).BlendFieldsWithText(148, 368, 566, 432) + \
Trim(4329, 4349).BlendFields + \
Trim(4350, 4438).BlendFieldsWithText(154, 370, 560, 432) + \
Trim(4439, 4460).BlendFields + \
Trim(4461, 4549).BlendFieldsWithText(206, 370, 512, 430) + \
Trim(4550, 4628).BlendFields + \
Trim(4629, 4719).BlendFieldsWithText(148, 370, 572, 434) + \
Trim(4720, 4765) + \
Trim(4766, 4854).BlendFieldsWithText(210, 368, 502, 430) + \
Trim(4855, 4910).BlendFields + \
Trim(4911, 4993).BlendFieldsWithText(200, 364, 522, 430) + \
Trim(4994, 81473) + \
FixPP(81474, 81714, 2) + \
FixPP(81715, 82012, 3) + \
FixPP(82013, 82289, 1) + \
Trim(82290, 0)
