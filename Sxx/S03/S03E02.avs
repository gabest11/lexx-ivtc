Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S03E02", 86050, \
	["..\..\S03(Acorn)\V01\title_t01.d2v"], \
	["..\..\S03(Acorn)\D01\title_t01.d2v"])

try
{
	c1 = LoadEpisodeWithAlt("S03E02", 86050, \
		["..\..\S03(Alliance)\V01\title_t01.d2v", -15])
	c2 = ConvertToBFF()

	# correct Alliance levels

	c1 = c1.ColorCorrectAllianceS03()

	# denoise single field sections

	c1 = Fix240p(c1, title)
	c2 = Fix240p(c2, title)

	# replace the clipped brighter pixels with Acorn's

	Overlay(c1, c2, mode="lighten")
}
catch(msg)
{
	last # clip undefined if the script ends here
}
