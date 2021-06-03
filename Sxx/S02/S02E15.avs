Import("../../common.avsi")

LoadEpisodeWithAlt("S02E15", 86105, \
	["..\..\S02(Acorn)\V04\title_t04.d2v"], \
	["..\..\S02(Acorn)\D08\title_t00.d2v"])

Trim(0, 11864) + \
Trim(11865, 11893) + FixPP(11894, 12014, 2, mv_blksize=8) + \
Trim(12015, 13652) + \
FixPP(13653, 13826, 1, mv_blksize=8) + \
Trim(13827, 17348) + \
Trim(17349, 17423).InsideToFilm(2, 328, 48, 468, 124) + \
Trim(17424, 18037) + \
Trim(18038, 18142).InsideToFilm(5, 328, 48, 468, 112) + \
Trim(18143, 19862) + \
Trim(19863, 20005).InsideToFilm(5, 328, 48, 468, 124) + \
Trim(20006, 20082) + \
Trim(20083, 20172).InsideToFilm(5, 328, 48, 468, 124) + \
Trim(20173, 20307) + \
Trim(20308, 20373).InsideToFilm(5, 328, 48, 468, 124) + \
Trim(20374, 20380) + \
Trim(20381, 20402).InsideToFilm(2, 328, 48, 468, 124) + \
Trim(20403, 21948) + \
Trim(21949, 22020).InsideToFilm(1, 312, 48, 452, 134) + \
Trim(22021, 22576) + \
Trim(22577, 22675).InsideToFilm(4, 312, 48, 452, 134) + \
Trim(22676, 23029) + \
Trim(23030, 23134).InsideToFilm(3, 312, 48, 452, 134) + \
Trim(23135, 23356) + \
Trim(23357, 23432).InsideToFilm(4, 312, 48, 452, 134) + \
Trim(23433, 24050) + \
Trim(24051, 24300).InsideToFilm(3, 352, 160, 432, 342) + \
Trim(24301, 24466) + \
Trim(24467, 24697).InsideToFilm(5, 356, 160, 436, 342) + \
Trim(24698, 25082) + \
Trim(25083, 25102).InsideToFilm(1, 356, 160, 436, 342) + \
Trim(25103, 26607) + \
Trim(26608, 26659).InsideToFilm(2, 312, 48, 452, 134) + \
Trim(26660, 27065) + \
Trim(27066, 27173).InsideToFilm(2, 312, 48, 452, 134) + \
Trim(27174, 79441) + \
Trim(79442, 79526) + \
Trim(79527, 0)

#Trim(24467, 24697) + \

#FixPP(79442, 79526, 1) + \

#Trim(0, 56902) + \
#Trim(56903, 57867).Letterbox(0, 0, 0, 8) + \
#Trim(57868, 0)
