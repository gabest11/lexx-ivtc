Import("../../common.avsi")

LoadEpisodeWithAlt("S02E03", 86100, \
	["..\..\S02(Acorn)\V01\title_t04.d2v"], \
	["..\..\S02(Acorn)\D02\title_t00.d2v"])

Trim(0, 58757) + \
Trim(58758, 58947).TopToFilm(1, 138) + \
Trim(58948, 59308) + \
Trim(59309, 59539).TopToFilm(1, 138) + \
Trim(59540, 59895) + \
Trim(59896, 60061).TopToFilm(2, 60) + \
Trim(60062, 0)




