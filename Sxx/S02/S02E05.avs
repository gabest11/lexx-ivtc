Import("../../common.avsi")

LoadEpisodeWithAlt("S02E05", 86075, \
	["..\..\S02(Acorn)\V02\title_t00.d2v"], \
	["..\..\S02(Acorn)\D03\title_t00.d2v"])

c0 = SeparateFields
c0.SelectEven
ScriptClip("Spline64Resize(Width, Height, src_top = f0_offset, src_height = Height)")
ConditionalReader("S02E05-var-f0_offset.txt", "f0_offset")
c1 = last
c0.SelectOdd
ScriptClip("Spline64Resize(Width, Height, src_top = f1_offset, src_height = Height)")
ConditionalReader("S02E05-var-f1_offset.txt", "f1_offset")
c2 = last

#c3 = overlay(c1, c2, mode = "difference").levels(96,1,160,0,255)
#stackhorizontal(c1, c2)

Interleave(c1, c2).Weave()

#return showfields

Trim(0,7208) + \
Trim(7209, 7316).TopToFilm(3, 180) + \
Trim(7317, 7367) + \
Trim(7368, 7423).TopToFilm(3, 180) + \
Trim(7424, 7605) + \
Trim(7606, 7641).TopToFilm(2, 280) + \
Trim(7642, 7705) + \
Trim(7706, 7786).TopToFilm(1, 280) + \
Trim(7787, 17585) + \
FixPP(17586, 17752, 1, mv_blksize=16, mv_overlap=2, ignore=[17702,17707,17712,17717]) + \
Trim(17753, 18069) + \
FixPP(18070, 18340, 2) + \
FixPP(18341, 18425, 3) + \
FixPP(18426, 18644, 2, mv_blksize=8, mv_searchparam=10) + \
Trim(18645, 23593) + \
FixPP(23594, 23805, 2, ignore=[23601,23606,23611,23616,23621,23626]) + \
Trim(23806, 24744) + \
FixPP(24745, 24866, 5) + \
Trim(24867, 24978) + \
FixPP(24979, 25188, 5) + \
FixPP(25189, 25299, 5) + \
Trim(25300, 28156) + \
FixPP(28157, 28215, 2) + \
FixPP(28216, 28320, 2) + \
Trim(28321, 31948) + \
FixPP(31949, 32183, 2) + \
Trim(32184, 35643) + \
FixPP(35644, 35759, 4) + \
FixPP(35760, 35852, 2) + \
Trim(35853, 42121) + \
FixPP(42122, 42295, 1) + \
Trim(42296, 48792) + \
FixPP(48793, 48901, 4) + \
Trim(48902, 62278) + \
Trim(62279, 62334).InsideToFilm(5, 274, 64, 650, 420) + \
Trim(62335, 66983) + \
FixPP(66984, 67079, 2) + \
Trim(67080, 69007) + \
FixPP(69008, 69134, 3) + \
Trim(69135, 70149) + \
FixPP(70150,70228, 3) + \
Trim(70229, 0)
