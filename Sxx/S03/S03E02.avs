Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

# TODO: when Acorn isn't available, try to load Alliance as-is

LoadEpisodeWithAlt("S03E02", 86050, \
	["..\..\S03(Acorn)\V01\title_t01.d2v"], \
	["..\..\S03(Acorn)\D01\title_t01.d2v"])

try
{
	c1 = LoadEpisodeWithAlt("S03E02", 86050, \
		["..\..\S03(Alliance)\V01\title_t01.d2v", -15])
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

#

_fix1 = FixSlowMoI(37457, 37613, 31600, pd = 2, f = [ \
	[0,2,3,4,6,7,8,10,11,12,14,15,16,18,19,20,22,23,24,26,27,28,30,31,32,33,35,36,37,39,40,41,43,44,45,47,48,49,51,52,53,55,56,57,59,60,61,63,64,65,66,68,69,70,72,73,74,76,77,78,80,81,82,84,85,86,88,89,90,92,93,94,95,97,98,99,101,102,103,105,106,107,109,110,111,113,114,115,117,118,119,121,122,123,125,126,127,128,130,131,132,134,135,136,138,139,140,142,143,144,146,147,148,150,151,152,154,155,156], \
	[0,2,3,4,6,7,8,10,11,12,14,15,16,18,19,20,22,23,24,26,27,28,30,31,32,33,35,36,37,39,40,41,43,44,45,47,48,49,51,52,53,55,56,57,59,60,61,63,64,65,66,68,69,70,72,73,74,76,77,78,80,81,82,84,85,86,88,89,90,92,93,94,95,97,98,99,101,102,103,105,106,107,109,110,111,113,114,115,117,118,119,121,122,123,125,126,127,128,130,131,132,134,135,136,138,139,140,142,143,144,146,147,148,150,151,152,154,155,156] \
	])

fix1 = Trim(37457, 37613) # too many blended frames, keep the original

# two planets in a repeating cpc pattern, ccppc works, but 30fps is nicer

#fix2 = FixSlowMoI(45554, 45691, 36000, pd = 3, fc = 3, f = [ \    
fix2 = FixSlowMoI(45554, 45691, 45200, pd = 0, fc = 3, f = [ \    
        [0,2], \
        [0,2] \
        ])

#

Trim(0, 60).BlendFields + \
Trim(61, 176).BlendFieldsWithText(298, 320, 634, 350) + \
Trim(177, 2730) + \
Trim(2731, 2819).BlendFields + \
Trim(2820, 2908).BlendFieldsWithText(248, 348, 472, 430) + \
Trim(2909, 2940).BlendFields + \
Trim(2941, 3028).BlendFieldsWithText(220, 370, 498, 430) + \
Trim(3029, 3060).BlendFields + \
Trim(3061, 3149).BlendFieldsWithText(128, 370, 592, 430) + \
Trim(3150, 3232).BlendFields + \
Trim(3233, 3303) + \
Trim(3304, 3393).BlendFieldsWithText(240, 372, 490, 430) + \
Trim(3394, 3482).BlendFields + \
Trim(3483, 3570).BlendFieldsWithText(156, 372, 562, 430) + \
Trim(3571, 3579).BlendFields + \
Trim(3580, 3658).BlendFieldsWithText(128, 368, 594, 430) + \
Trim(3659, 3914) + \
Trim(3915, 4002).BlendFieldsWithText(154, 370, 560, 430) + \
Trim(4003, 4034).BlendFields + \
Trim(4035, 4123).BlendFieldsWithText(206, 368, 512, 428) + \
Trim(4124, 4182).BlendFields + \
Trim(4183, 4271).BlendFieldsWithText(148, 370, 570, 430) + \
Trim(4272, 4315).BlendFields + \
Trim(4316, 4403).BlendFieldsWithText(210, 368, 502, 428) + \
Trim(4404, 4417).BlendFields + \
Trim(4418, 4505).BlendFieldsWithText(200, 366, 520, 428) + \
Trim(4506, 4512).BlendFields + \
Trim(4513, 4813) + \
Trim(4814, 4902).BlendFieldsWithText(210, 364, 506, 428) + \
Trim(4903, 4944).BlendFields + \
Trim(4945, 5011) + \
Trim(5012, 5022).BlendFields + \
Trim(5023, 5111).BlendFieldsWithText(232, 364, 490, 428) + \
Trim(5112, 5205).BlendFields + \
Trim(5206, 37456) + \
fix1 + \
Trim(37614, 45553) + \
fix2 + \
Trim(45692, 0)
