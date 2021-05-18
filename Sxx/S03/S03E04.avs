Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S03E04", 86075, \
	["..\..\S03(Acorn)\V01\title_t04.d2v"], \
	["..\..\S03(Acorn)\D02\title_t01.d2v"])

try
{
	c1 = LoadEpisodeWithAlt("S03E04", 86075, \
		["..\..\S03(Alliance)\V01\title_t03.d2v", -15])
	c2 = ConvertToBFF()

	# denoise single field sections

	c1 = Fix240p(c1, title)
	c2 = Fix240p(c2, title)

	# the ending is cut, replace it from the other

	Trim(c1, 0, 86032) + Trim(c2, 86033, 0)
}
catch(msg)
{
	last # clip undefined if the script ends here
}
