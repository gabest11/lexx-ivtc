Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

# TODO: when Acorn isn't available, try to load Alliance as-is

LoadEpisodeWithAlt("S03E01", 86075, \
	["..\..\S03(Acorn)\V01\title_t00.d2v"], \
	["..\..\S03(Acorn)\D01\title_t00.d2v"])

try
{
	c1 = LoadEpisodeWithAlt("S03E01", 86075, \
		["..\..\S03(Alliance)\V01\title_t00.d2v", -15])
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

# Lexx drifting in space, original version has interpolated field, S03E09 very similar but full frame

fix1 = Trim(27447, 27563).nnedi3(field=1)

try
{
	c = LoadEpisodeWithAlt("S03E09", 86050, \
		["..\..\S03(Alliance)\V03\title_t01.d2v", -15])
		
	#fix1 = StackHorizontal(fix1, Trim(c, 10890, 11006)).Spline64Resize(Width, Height)
	
	fix1 = Trim(c, 10890, 11006)
}
catch(msg)
{
	last # clip undefined if the script ends here
}

Trim(0, 2056) + \
Trim(2057, 2145).BlendFieldsWithText(220, 372, 498, 430) + \
Trim(2146, 2192).BlendFields + \
Trim(2193, 2280).BlendFieldsWithText(126, 370, 592, 428) + \
Trim(2281, 2327).BlendFields + \
Trim(2328, 2414).BlendFieldsWithText(240, 374, 490, 428) + \
Trim(2415, 2456).BlendFields + \
Trim(2457, 2544).BlendFieldsWithText(156, 372, 562, 430) + \
Trim(2545, 2591).BlendFields + \
Trim(2592, 2679).BlendFieldsWithText(128, 368, 596, 432) + \
Trim(2680, 2726).BlendFields + \
Trim(2727, 2814).BlendFieldsWithText(156, 370, 562, 430) + \
Trim(2815, 2842).BlendFields + \
Trim(2843, 2930).BlendFieldsWithText(206, 370, 512, 430) + \
Trim(2931, 2978).BlendFields + \
Trim(2979, 3064).BlendFieldsWithText(148, 368, 570, 430) + \
Trim(3065, 3087).BlendFields + \
Trim(3088, 3155) + \
Trim(3156, 3162).BlendFields + \
Trim(3163, 3250).BlendFieldsWithText(210, 368, 502, 428) + \
Trim(3251, 3298).BlendFields + \
Trim(3299, 3385).BlendFieldsWithText(138, 366, 586, 430) + \
Trim(3386, 3432).BlendFields + \
Trim(3433, 3520).BlendFieldsWithText(212, 306, 506, 434) + \
Trim(3521, 3567).BlendFields + \
Trim(3568, 3655).BlendFieldsWithText(230, 364, 488, 428) + \
Trim(3656, 3748).BlendFields + \
Trim(3749, 27446) + \
fix1 + \
Trim(27564, 0)
