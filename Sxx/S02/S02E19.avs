Import("../../common.avsi")

LoadEpisodeWithAlt("S02E19", 86105, \
	["..\..\S02(Koch)\V05\title_t05.d2v"], \
	["..\..\S02(Acorn)\D10\title_t00.d2v"])

try
{
	c = LoadEpisodeWithAlt("S02E05", 0, \
		["..\..\S02(Acorn)\V02\title_t00.d2v"], \
		["..\..\S02(Acorn)\D03\title_t00.d2v"])

	# Trim(0, 7039) + Trim(c, 12742, 13192) + Trim(7491, 0)
}
catch(msg)
{
}

fix1 = Overlay(FixPPVideo(67390, 67471, 1), Trim(67390, 67471).Crop(180, 40, 200, 200), 180, 40)

#fix2 = Trim(71288, 71393)
#fix2_2 = fix2.LeftToFilm(5, 380)
#fix2 = fix2.Overlay(fix2_2.Crop(180, 32, 380 - 180, 170 - 32), 180, 32)
#fix2 = fix2.Overlay(fix2_2.Crop(180, 170, 360 - 180, 220 - 170), 180, 170)

fix2 = Trim(71288, 71393).InsideToVideo(5, 350, 170, 720, 480)

Trim(0, 52799) + \
FixPP(52800, 52890, 3) + \
Trim(52891, 67389) + \
fix1 + \
Trim(67472, 71287) + \
fix2 + \
Trim(71394, 0)
