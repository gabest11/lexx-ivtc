Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S03E05", 86090, \
	["..\..\S03(Alliance)\V02\title_t00.d2v", -30], \
	["..\..\S03(Acorn)\V02\title_t00.d2v"], \
	["..\..\S03(Acorn)\D03\title_t00.d2v"])

#return ConvertToY8.Detect240p.Levels(96,1,160,0,255)

# denoise single field sections

Fix240p(title)

Trim(0, 4223) + \
Trim(4224, 4234).BlendFields + \
Trim(4235, 4323).BlendFieldsWithText(248, 404, 472, 434) + \
Trim(4324, 4399).BlendFieldsWithText(184,372,534,430) + \
Trim(4400, 4480).BlendFieldsWithText(238,372,492,428) + \
Trim(4481, 4501).BlendFields + \
Trim(4502, 4588).BlendFieldsWithText(150,368,564,430) + \
Trim(4589, 4658) + \
Trim(4659, 4748).BlendFieldsWithText(154,370,560,430) + \
Trim(4749, 4790).BlendFields + \
Trim(4791, 5455) + \
Trim(5456, 5532).BlendFieldsWithText(138,366,588,430) + \
Trim(5533, 6182) + \
Trim(6183, 6278).BlendFieldsWithText(212,364,506,428) + \
Trim(6279, 6372).BlendFieldsWithText(230,364,492,428) + \
Trim(6373, 10230) + \
Trim(10231, 10472).BlendFields + \
Trim(10473, 10693) + \
Trim(10694, 10769).BlendFields + \
Trim(10770, 30142) + \
Trim(30143, 30178).BlendFields + \
Trim(30179, 31929) + \
Trim(31930, 32002).BlendFields + \
Trim(32003, 32984) + \
Trim(32985, 33047).BlendFields + \
Trim(33048, 72932) + \
Trim(72933, 72980).BlendFields + \
Trim(72981, 73536) + \
Trim(73537, 73639).BlendFields + \
Trim(73640, 75543) + \
Trim(75544, 75616).BlendFields + \
Trim(75617, 0)


