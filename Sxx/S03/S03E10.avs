Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S03E10", 86050, \
	["..\..\S03(Alliance)\V03\title_t02.d2v", -15], \
	["..\..\S03(Acorn)\V03\title_t02.d2v"], \
	["..\..\S03(Acorn)\D05\title_t01.d2v"])

#return detect240p
#return showfields(false)
	
# denoise single field sections

Fix240p(title)

#

Trim(0, 53) + \
Trim(54, 170).BlendFieldsWithText(278, 388, 650, 430) + \
Trim(171, 6078) + \
Trim(6079, 6089).BlendFields + \
Trim(6090, 6178).BlendFieldsWithText(238, 372, 492, 430) + \
Trim(6179, 6210).BlendFields + \
Trim(6211, 6299).BlendFieldsWithText(148, 368, 566, 430) + \
Trim(6300, 6326).BlendFields + \
Trim(6327, 6566) + \
Trim(6567, 6572).BlendFields + \
Trim(6573, 6661).BlendFieldsWithText(148, 368, 570, 430) + \
Trim(6662, 6687).BlendFields + \
Trim(6688, 6776).BlendFieldsWithText(210, 368, 502, 428) + \
Trim(6777, 6782).BlendFields + \
Trim(6783, 6795).BlendFields + \
Trim(6796, 6883).BlendFieldsWithText(138, 366, 586, 428) + \
Trim(6884, 6892).BlendFields + \
Trim(6893, 6989) + \
Trim(6990, 7010).BlendFields + \
Trim(7011, 7099).BlendFieldsWithText(210, 364, 506, 428) + \
Trim(7100, 7130).BlendFields + \
Trim(7131, 7219).BlendFieldsWithText(154, 362, 564, 426) + \
Trim(7220, 7380).BlendFields + \
Trim(7381, 78672) + \
FixPP(78673, 78724, 2) + \
Trim(78725, 78747) + \
FixPP(78748, 78790, 1, mv_blksize=32, mv_overlap=4) + \
Trim(78791, 0)

