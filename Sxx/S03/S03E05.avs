Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S03E05", 86090, \
	["..\..\S03(Alliance)\V02\title_t00.d2v", -30], \
	["..\..\S03(Acorn)\V02\title_t00.d2v"], \
	["..\..\S03(Acorn)\D03\title_t00.d2v"])

#return ConvertToY8.Detect240p.Levels(96,1,160,0,255)

# denoise single field sections

Fix240p(title)

# two planets, every 68 frames repeat, irregular dups

#
# 12295 ccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccp
#       ccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccp
# 12363 ccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccp
#       ccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccp
# 12431 ccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccp
#       ccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccp
# 12499 ccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccp
#       ccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccpcccpccccp
# 12567 ccc
#       ccc

fix1 = FixSlowMoI(12295, 12569, 38500, pd = 0, fc = 68, f = [ \
	[0,1,2,3,5,6,7,9,10,11,12,14,15,16,18,19,20,21,23,24,25,27,28,29,30,32,33,34,36,37,38,39,41,42,43,45,46,47,48,50,51,52,54,55,56,57,59,60,61,63,64,65,66], \
	[0,1,2,3,5,6,7,9,10,11,12,14,15,16,18,19,20,21,23,24,25,27,28,29,30,32,33,34,36,37,38,39,41,42,43,45,46,47,48,50,51,52,54,55,56,57,59,60,61,63,64,65,66] \
	])

#fix1 = SeparateFields.SelectEven.AssumeFrameBased.FixSlowMoI(12295, 12569, 38500, pd = 0, fc = 68, f = [ \
#	[0,1,2,3,5,6,7,9,10,11,12,14,15,16,18,19,20,21,23,24,25,27,28,29,30,32,33,34,36,37,38,39,41,42,43,45,46,47,48,50,51,52,54,55,56,57,59,60,61,63,64,65,66], \
#	[0,1,2,3,5,6,7,9,10,11,12,14,15,16,18,19,20,21,23,24,25,27,28,29,30,32,33,34,36,37,38,39,41,42,43,45,46,47,48,50,51,52,54,55,56,57,59,60,61,63,64,65,66] \
#	]).AssumeFieldBased
#fix1 = Interleave(fix1, fix1).Weave

#

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
Trim(10770, 12294) + \
fix1 + \
Trim(12570, 30142) + \
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


