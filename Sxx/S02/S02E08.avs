Import("../../common.avsi")

LoadEpisodeWithAlt("S02E08", 86075, \
	["..\..\S02(Acorn)\V02\title_t05.d2v"], \
	["..\..\S02(Acorn)\D04\title_t00.d2v", 86100])

Trim(0, 39988) + \
Trim(39989, 40079).OutsideToVideo(4, 230, 320, 414, 450) + \
Trim(40080, 40155) + \
Trim(40156, 40223).OutsideToVideo(5, 230, 320, 414, 450) + \
Trim(40224, 49469) + \
FixPP(49470, 49578, 4) + \
Trim(49579, 80028) + \
Trim(80029, 80109).TopToVideo(3, 220) + \
Trim(80110, 0)

#Trim(39989,40079).BottomToFilm(4, 240) + \
