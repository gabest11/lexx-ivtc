Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

# TODO: when Acorn isn't available, try to load Alliance as-is

LoadEpisodeWithAlt("S03E04", 86075, \
	["..\..\S03(Acorn)\V01\title_t04.d2v"], \
	["..\..\S03(Acorn)\D02\title_t02.d2v"])

try
{
	c1 = LoadEpisodeWithAlt("S03E04", 86075, \
		["..\..\S03(Alliance)\V01\title_t03.d2v", -15])
	c2 = ConvertToBFF()

	# the ending is cut, replace it from the other

	Trim(c1, 0, 86032) + Trim(c2, 86033, 0)
}
catch(msg)
{
	last # clip undefined if the script ends here
}

# denoise single field sections

Fix240p(title)

#

Trim(0, 5429) + \
Trim(5430, 5518).BlendFieldsWithText(202, 348, 518, 434) + \
Trim(5519, 5538).BlendFields + \
Trim(5539, 5617).BlendFieldsWithText(208, 370, 512, 434) + \
Trim(5618, 5638).BlendFields + \
Trim(5639, 5728).BlendFieldsWithText(222, 402, 498, 434) + \
Trim(5729, 5814).BlendFieldsWithText(126, 402, 594, 430) + \
Trim(5815, 5903).BlendFieldsWithText(248, 402, 474, 434) + \
Trim(5904, 5942).BlendFields + \
Trim(5943, 6032).BlendFieldsWithText(232, 366, 486, 432) + \
Trim(6033, 6080).BlendFields + \
Trim(6081, 6170).BlendFieldsWithText(150, 362, 568, 432) + \
Trim(6171, 6322) + \
Trim(6323, 6412).BlendFieldsWithText(158, 364, 566, 432) + \
Trim(6413, 6480).BlendFields + \
Trim(6481, 6709) + \
Trim(6710, 6798).BlendFieldsWithText(206, 364, 514, 432) + \
Trim(6799, 6817).BlendFields + \
Trim(6818, 6979) + \
Trim(6980, 7069).BlendFieldsWithText(148, 368, 574, 434) + \
Trim(7070, 7075).BlendFields + \
Trim(7076, 7124) + \
Trim(7125, 7214).BlendFieldsWithText(210, 368, 504, 430) + \
Trim(7215, 7241).BlendFields + \
Trim(7242, 7297) + \
Trim(7298, 7387).BlendFieldsWithText(200, 364, 522, 430) + \
Trim(7388, 7422).BlendFields + \
Trim(7423, 7469) + \
Trim(7470, 7559).BlendFieldsWithText(210, 306, 508, 436) + \
Trim(7560, 7626) + \
Trim(7627, 7647).BlendFields + \
Trim(7648, 7736).BlendFieldsWithText(230, 360, 490, 428) + \
Trim(7737, 7770).BlendFields + \
Trim(7771, 0)
