Import("../../common.avsi")

LoadEpisodeWithAlt("S02E12", 86135, \
	["..\..\S02(Acorn)\V03\title_t03.d2v"], \
	["..\..\S02(Acorn)\D06\title_t01.d2v"])

Trim(0, 5392) + \
FixPP(5393, 5490, 4).Letterbox(0, 0, 8, 8) + \
Trim(5491, 49585) + \
Trim(49586, 49619) + \
Trim(49620, 49644).InsideToFilm(2, 60, 120, 120, 210) + \
Trim(49645, 49664).InsideToFilm(2, 60, 120, 160, 210) + \
Trim(49665, 49675).InsideToFilm(2, 60, 120, 200, 210) + \
Trim(49676, 77302) + \
FixPP(77303, 77597, 3) + \
Trim(77598, 0)


