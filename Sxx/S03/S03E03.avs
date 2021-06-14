Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

# TODO: when Acorn isn't available, try to load Alliance as-is

LoadEpisodeWithAlt("S03E03", 86050, \
	["..\..\S03(Acorn)\V01\title_t03.d2v"], \
	["..\..\S03(Acorn)\D02\title_t01.d2v"])

try
{
	c1 = LoadEpisodeWithAlt("S03E03", 86050, \
		["..\..\S03(Alliance)\V01\title_t02.d2v", -25])
	c2 = ConvertToBFF()

	# correct Alliance levels

	c1 = c1.ColorCorrectAllianceS03()

	# replace the clipped brighter pixels with Acorn's, only Y values, BFF conversion also blurs chroma

	Overlay(c1, Overlay(c1, c2, mode="lighten"), mode="luma")
}
catch(msg)
{
	last # clip undefined if the script ends here
}

# denoise single field sections

Fix240p(title)

#

Trim(0, 84).BlendFields + \
Trim(85, 176).BlendFieldsWithText(84, 390, 426, 422) + \
Trim(177, 3738) + \
Trim(3739, 3827).BlendFieldsWithText(208, 348, 510, 432) + \
Trim(3828, 3889).BlendFields + \
Trim(3890, 3967).BlendFieldsWithText(222, 370, 496, 430) + \
Trim(3968, 4029).BlendFields + \
Trim(4030, 4107).BlendFieldsWithText(222, 370, 496, 428) + \
Trim(4108, 4169).BlendFields + \
Trim(4170, 4257).BlendFieldsWithText(128, 370, 592, 428) + \
Trim(4258, 4319).BlendFields + \
Trim(4320, 4407).BlendFieldsWithText(248, 370, 472, 432) + \
Trim(4408, 4469).BlendFields + \
Trim(4470, 4557).BlendFieldsWithText(240, 372, 492, 430) + \
Trim(4558, 4613).BlendFields + \
Trim(4614, 4701).BlendFieldsWithText(156, 372, 564, 430) + \
Trim(4702, 4743).BlendFields + \
Trim(4744, 4832).BlendFieldsWithText(128, 368, 594, 432) + \
Trim(4833, 4909).BlendFields + \
Trim(4910, 4997).BlendFieldsWithText(154, 370, 560, 430) + \
Trim(4998, 5100).BlendFields + \
Trim(5101, 5189).BlendFieldsWithText(206, 370, 512, 430) + \
Trim(5190, 5234).BlendFields + \
Trim(5235, 5458) + \
Trim(5459, 5554).BlendFieldsWithText(212, 368, 502, 428) + \
Trim(5555, 5585).BlendFields + \
Trim(5586, 5673).BlendFieldsWithText(138, 366, 586, 430) + \
Trim(5674, 5755) + \
Trim(5756, 5766).BlendFields + \
Trim(5767, 5855).BlendFieldsWithText(212, 308, 506, 436) + \
Trim(5856, 5877).BlendFields + \
Trim(5878, 5966).BlendFieldsWithText(228, 362, 490, 428) + \
Trim(5967, 6050).BlendFields + \
Trim(6051, 0)
