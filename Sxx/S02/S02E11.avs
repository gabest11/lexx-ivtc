Import("../../common.avsi")

LoadEpisodeWithAlt("S02E11", 86045, \
	["..\..\S02(Acorn)\V03\title_t02.d2v"], \
	["..\..\S02(Acorn)\D06\title_t00.d2v"])

function FixCanteen(clip c)
{
	# each group of people has a certain pattern, reorder them to be the same
	
	# tl cccpp tr cppcc bl cppcc br pcccp (tr bl is the same, but whatever)
	
	c = Trim(c, 8940, 9123)
	
	c.SeparateFields
	
	tl = SelectEvery(10, 0,1, 2,3, 4,5, 8,7).Weave
	tr = SelectEvery(10, 0,1, 4,3, 6,7, 8,9).Weave
	bl = SelectEvery(10, 0,1, 4,3, 6,7, 8,9).Weave
	br = (Trim(0, -2).AssumeFPS(48000, 1001) + Trim(2, 0).SelectEvery(10, 0,1, 2,3, 4,5, 8,7)).Weave
	
	c = tl
	c = c.Overlay(bl.Crop(0, 380, 360, 100), 0, 380)
	c = c.Overlay(tr.Crop(360, 0, 360, 380), 360, 0)
	c = c.Overlay(br.Crop(360, 380, 360, 100), 360, 380)

	# cppcc
	
	c.SeparateFields.SelectEvery(8, 0,1, 0,3, 2,5, 4,5, 6,7).Weave
	
	# it's somehow one frame longer than the original
	
	Trim(0, length = 9123 - 8940 + 1)
}

Trim(0, 2078) + \
FixPP(2079, 2147, 2) + \
Trim(2148, 2471) + \
FixPP(2472, 2553, 3) + \
Trim(2554, 6967) + \
FixPP(6968, 7248, 3, ignore=[7055,7056,7060,7061,7065,7066,7070,7071]) + \
Trim(7249, 7906) + \
FixPP(7907, 7953, 4) + \
Trim(7954, 8170) + \
FixPP(8171, 8246, 4) + \
Trim(8247, 8335) + \
FixPP(8336, 8496, 4) + \
Trim(8497, 8723) + \
FixPP(8724, 8792, 1, mv_blksize=8, mv_overlap=4, mv_searchparam=4) + \
Trim(8793, 8939) + \
FixCanteen + \
Trim(9124, 12759) + \
Trim(12760, 13011).TopToFilm(3, 144) + \
Trim(13012, 27578) + \
Trim(27579, 27859).LeftToFilm(3, 360) + \
Trim(27860, 40499) + \
FixPP(40500, 40599, 4) + \
Trim(40600, 50702) + \
FixPP(50703, 50768, 1) + \
Trim(50769, 81965) + \
FixPP(81966, 82175, 3) + \
Trim(82176, 0)



#

#FixPP(8171, 8246, 4, ignore=[8194,8195,8219,8220,8229,8230,8244,8245]) + \


#Trim(27579, 27859).RightToVideo(3, 360) + \
#return showfields