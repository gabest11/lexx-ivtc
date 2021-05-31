Import("../../common.avsi")

LoadEpisodeWithAlt("S02E07", 86100, \
	["..\..\S02(Acorn)\V02\title_t04.d2v"], \
	["..\..\S02(Acorn)\D04\title_t00.d2v"])

function FixTV(clip c, int s, int e, int i, int l, int t)
{
	cc = FixPP(c, s, e, i, mv_blksize=8, mv_overlap=4)
	
	Trim(c, s, e).Overlay(cc.Crop(l, t, 130, 100), x = l, y = t)
}

Trim(0, 3211) + \
FixTV(3212, 3338, 2, 530, 210) + \
Trim(3339, 17032) + \
FixTV(17033, 17146, 1, 520, 180) + \
FixTV(17147, 17206, 3, 520, 180) + \
Trim(17207, 33047) + \
FixPP(33048, 33217, 3) + \
Trim(33218, 0)

