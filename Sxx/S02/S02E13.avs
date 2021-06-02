Import("../../common.avsi")

LoadEpisodeWithAlt("S02E13", 86105, \
	["..\..\S02(Acorn)\V04\title_t00.d2v"], \
	["..\..\S02(Acorn)\D07\title_t00.d2v"])


#return showfields

function OverlayIntercom(clip c, clip ic, int dx)
{
	last = c
	
	Overlay(ic.Crop(224, 0, 544 - 224, 200), 224, 0)
	Overlay(ic.Crop(224, 200, 408 - 224 + dx, 262 - 200), 224, 200)
	Overlay(ic.Crop(408, 200, 508 - 408 + dx, 204 - 200), 408, 200)
	Overlay(ic.Crop(408, 204, 492 - 408 + dx, 208 - 204), 408, 204)
	Overlay(ic.Crop(408, 208, 466 - 408 + dx, 216 - 208), 408, 208)
	Overlay(ic.Crop(408, 216, 454 - 408 + dx, 224 - 216), 408, 216)
	Overlay(ic.Crop(408, 224, 444 - 408 + dx, 232 - 224), 408, 224)
	Overlay(ic.Crop(408, 232, 432 - 408 + dx, 240 - 232), 408, 232)
	Overlay(ic.Crop(408, 240, 424 - 408 + dx, 248 - 240), 408, 240)
	Overlay(ic.Crop(408, 248, 416 - 408 + dx, 256 - 248), 408, 248)
}

function FixIntercom(clip c, int s, int e, int isrc, int idst, int dx)
{
	ic = FixPP(c, s, e, isrc).FilmToFilm(isrc, idst)
	
	Trim(c, s, e)
	
	OverlayIntercom(ic, dx)
}

function FixIntercomAndForeground(clip c, int s, int e, int isrc, int idst, int dx)
{
	ic = FixPP(c, s, e, isrc).FilmToFilm(isrc, idst)
	
	FixPP(c, s, e, idst)
	
	OverlayIntercom(ic, dx)
}

Trim(0, 15188) + \
FixIntercom(15189, 15260, 1, 1, 0) + \
Trim(15261, 15468) + \
FixIntercom(15469, 15617, 4, 1, 20) + \
Trim(15618, 16307) + \
FixIntercom(16308, 16405, 4, 3, 32) + \
Trim(16406, 16822) + \
FixIntercom(16823, 16918, 3, 4, 32) + \
Trim(16919, 16987) + \
FixIntercomAndForeground(16988, 17073, 5, 4, 32) + \
Trim(17074, 17209) + \
FixIntercomAndForeground(17210, 17319, 3, 2, 32) + \
Trim(17320, 20801) + \
Trim(20802, 20995).LeftToVideo(1, 364) + \
Trim(20996, 41604) + \
FixPP(41605, 41820, 5, mv_blksize=8, mv_overlap=4) + \
Trim(41821, 42289) + \
FixPP(42290, 42343, 5, mv_blksize=8, mv_overlap=4, ignore=[42299,42300,42334,42335,42339,42340]) + \
Trim(42344, 42380) + \
FixPP(42381, 42464, 5, mv_blksize=8, mv_overlap=4) + \
FixPP(42465,42534, 2) + \
Trim(42535, 42558) + \
FixPP(42559, 42602, 2, ignore=[42570,42571,42575,42576,42580,42581,42585,42586]) + \
Trim(42603, 43001) + \
FixPP(43002, 43139, 5) + \
Trim(43140, 43246) + \
FixPP(43247, 43349, 1) + \
Trim(43350, 43393) + \
FixPP(43394, 43600, 4) + \
Trim(43601, 43675) + \
FixPP(43676, 43887, 3, ignore=[43803,43804,43878,43879]) + \
Trim(43888, 44453) + \
FixPP(44454, 44575, 1) + \
Trim(44576, 45407) + \
FixPP(45408, 45582, 1, mv_blksize=8, mv_overlap=4) + \
Trim(45583, 45831) + \
FixPP(45832, 46411, 5, mv_blksize=8, mv_overlap=4) + \
Trim(46412, 56633) + \
FixPP(56634, 56851, 4, mv_blksize=8, mv_overlap=4) + \
Trim(56852, 58208) + \
FixPP(58209, 58349, 2, mv_blksize=8, mv_overlap=4) + \
Trim(58350, 58750) + \
FixPP(58751, 58889, 2, mv_blksize=8, mv_overlap=4) + \
Trim(58890, 63312) + \
FixPP(63313, 63586, 4, mv_blksize=8, mv_overlap=4) + \
Trim(63587, 67919) + \
FixPP(67920, 68062, 4, ignore=[67928,67929,67933,67934,67938,67939,67943,67944,67948,67949,67963,67964]) + \
Trim(68063, 74254) + \
FixPP(74255, 74311, 1, mv_blksize=8, mv_overlap=4) + \
Trim(74312, 83544) + \
Trim(83545, 83675).OutsideToVideo(2, 224, 0, 550, 260) + \
Trim(83676, 0)

#FixPP(74255, 74311, 1) + \
