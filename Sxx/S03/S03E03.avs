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
