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
