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

	# denoise single field sections

	c1 = c1.Fix240p(title)

	# correct Alliance levels

	c1 = c1.ColorCorrectAllianceS03()

	# replace the clipped brighter pixels with Acorn's, only Y values, BFF conversion also blurs chroma

	Overlay(c1, Overlay(c1, c2, mode="lighten"), mode="luma")
}
catch(msg)
{
	last # clip undefined if the script ends here
}

# Lexx firing, second field is dupped of course (replace it from other episode?)

# 34840 cpccp cccpc ccpcc cpccc pcccp ccpcc cpccc pcccp cccpc ccpcc
#       cpccp cccpc ccpcc cpccc pcccp ccpcc cpccc pcccp cccpc ccpcc
# 34890 pcccp cccpc ccpcc cpccc pccpc ccpcc cpccc pcccp cccpc cpccc
#       pcccp cccpc ccpcc cpccc pccpc ccpcc cpccc pcccp cccpc cpccc
# 34940 pcccp cccpc ccpcc cpcc
#       pcccp cccpc ccpcc cpcc

fix1 = FixSlowMoI(34840, 34958, 40700, pd = 0, f = [ \
	[0,2,3,5,6,7,9,10,11,13,14,15,17,18,19,21,22,23,25,26,28,29,30,32,33,34,36,37,38,40,41,42,44,45,46,48,49,51,52,53,55,56,57,59,60,61,63,64,65,67,68,69,71,72,74,75,76,78,79,80,82,83,84,86,87,88,90,91,92,94,95,97,98,99,101,102,103,105,106,107,109,110,111,113,114,115,117,118], \
	[0,2,3,5,6,7,9,10,11,13,14,15,17,18,19,21,22,23,25,26,28,29,30,32,33,34,36,37,38,40,41,42,44,45,46,48,49,51,52,53,55,56,57,59,60,61,63,64,65,67,68,69,71,72,74,75,76,78,79,80,82,83,84,86,87,88,90,91,92,94,95,97,98,99,101,102,103,105,106,107,109,110,111,113,114,115,117,118] \
	])

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
Trim(6051, 34839) + \
fix1 + \
Trim(34959, 0)

# this scene is incredibly grainy

Trim(0, 7418) + \
Trim(7419, 8184).Degrain + \
Trim(8185, 0)

# white balance fix for the important scenes

s0 = last
s1 = Tweak(bright=-32.0, cont=1.30, sat=1.0, dither=true)
s2 = Tweak(bright=-32.0, cont=1.20, sat=1.0, dither=true)
s3 = Tweak(bright=-16.0, cont=1.05, sat=1.0, dither=true)

s0.Trim(0,49174) + \
s1.Trim(49175,49892) + \
s3.Trim(49893,49919) + \
s1.Trim(49920,50140) + \
s3.Trim(50141,50252) + \
s0.Trim(50253,50318) + \
s1.Trim(50319,50503) + \
s0.Trim(50504,50604) + \
s1.Trim(50605,50833) + \
s0.Trim(50834,50906) + \
s1.Trim(50907,51207) + \
s0.Trim(51208,51334) + \
s1.Trim(51335,51444) + \
s0.Trim(51445,51513) + \
s1.Trim(51514,51896) + \
s0.Trim(51897,51965) + \
s1.Trim(51966,52075) + \
s0.Trim(52076,52144) + \
s1.Trim(52145,52463) + \
s0.Trim(52464,52527) + \
s1.Trim(52528,52641) + \
s0.Trim(52642,52701) + \
s1.Trim(52702,53002) + \
s0.Trim(53003,53174) + \
s1.Trim(53175,53313) + \
s0.Trim(53314,53532) + \
s1.Trim(53533,54349) + \
s0.Trim(54350,0)

# TODO: try to reduce the halo in scenes like 10126,10382 / 10438,11879
