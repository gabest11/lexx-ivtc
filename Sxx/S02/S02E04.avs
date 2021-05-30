Import("../../common.avsi")

LoadEpisodeWithAlt("S02E04", 86130, \
	["..\..\S02(Acorn)\V01\title_t05.d2v"], \
	["..\..\S02(Acorn)\D02\title_t00.d2v", 86100])

c0 = SeparateFields
c0.SelectEven
ScriptClip("Spline64Resize(Width, Height, src_top = f0_offset, src_height = Height)")
ConditionalReader("S02E04-var-f0_offset.txt", "f0_offset")
c1 = last
c0.SelectOdd
ScriptClip("Spline64Resize(Width, Height, src_top = f1_offset, src_height = Height)")
ConditionalReader("S02E04-var-f1_offset.txt", "f1_offset")
c2 = last

#c3 = overlay(c1, c2, mode = "difference").levels(96,1,160,0,255)
#stackhorizontal(c1, c2)

Interleave(c1, c2).Weave

#

# Trim(29551, 29634).RightToVideo(4, 400) + \

#return Trim(30549, 30703).InsideToFilm(4, 390, 80, 520, 150)
#return Trim(30549, 30703).OutsideToVideo(4, 390, 80, 520, 150, 37600)
#Trim(32583, 32716).OutsideToVideo(2, 280, 260, 400, 360, 37700) + \

function FixHoloXev(clip c, int i)
{
	# non-rectangular, arm is under the hologram
	
	c2 = c.RightToVideo(i, 320)
	c = c.Overlay(c2.Crop(388, 0, -0, -0), 388, 0)
	c = c.Overlay(c2.Crop(356, 448, 32, -0), 356, 448)
	c = c.Overlay(c2.Crop(372, 432, 16, -0), 372, 432)
	c = c.Overlay(c2.Crop(340, 464, 16, -0), 340, 464)
	return c
}

function FixHoloXevFilm(clip c, int i)
{
	# non-rectangular, arm is under the hologram
	
	c2 = c.LeftToFilm(i, 388)
	c2 = c2.Overlay(c.Crop(388, 0, -0, -0), 388, 0)
	c2 = c2.Overlay(c.Crop(356, 448, 32, -0), 356, 448)
	c2 = c2.Overlay(c.Crop(372, 432, 16, -0), 372, 432)
	c2 = c2.Overlay(c.Crop(340, 464, 16, -0), 340, 464)
	return c2
}

hx1 = Trim(36780, 37205).FixHoloXevFilm(2)
hx1 = Trim(hx1, 0, length = 36830 - 36780) + Trim(36830, 36844) + Trim(hx1, 36845 - 36780, length = 37206 - 36845)
#hx1 = Trim(36780, 37205)

#Trim(29635, 29771).RightToVideo(4, 378) + \
#Trim(30549, 30703).OutsideToVideo(4, 390, 80, 520, 150, 37600) + \
#Trim(30704, 30843).FixHoloXev(1) + \
#Trim(30704, 30843).FixHoloXevFilm(1) + \

Trim(0, 12683) + \
Trim(12684, 12879).BottomToVideo(3, 240) + \
Trim(12880, 13416) + \
Trim(13417, 13472).BottomToVideo(3, 240) + \
Trim(13473, 15061) + \
Trim(15062, 15135).BottomToVideo(3, 308) + \
Trim(15136, 15763) + \
Trim(15764, 15823).BottomToVideo(3, 240) + \
Trim(15824, 17074) + \
Trim(17075, 17225).BottomToVideo(3, 240) + \
Trim(17226, 29550) + \
Trim(29551, 29634) + \
Trim(29635, 29771).LeftToFilm(4, 378) + \
Trim(29772, 30548) + \
Trim(30549, 30703).InsideToFilm(4, 390, 80, 520, 150) + \
Trim(30704, 30843).FixHoloXevFilm(2) + \
Trim(30844, 30981).LeftToFilm(5, 380) + \
Trim(30982, 31259).LeftToFilm(5, 360) + \
Trim(31260, 31329).RightToFilm(5, 358) + \
Trim(31330, 31438).RightToFilm(2, 350) + \
Trim(31439, 31630).InsideToFilm(3, 380, 64, 550, 304) + \
Trim(31631, 31702).RightToFilm(2, 470) + \
Trim(31703, 31780) + \
Trim(31781, 31842).RightToFilm(3, 470) + \
Trim(31843, 32152) + \
Trim(32153, 32236).InsideToFilm(2, 400, 56, 546, 304) + \
Trim(32237, 32336).RightToFilm(1, 470) + \
Trim(32337, 32582) + \
Trim(32583, 32716).InsideToFilm(2, 280, 260, 400, 360) + \
Trim(32717, 33037) + \
Trim(33038, 33169).InsideToFilm(1, 280, 260, 400, 360) + \
Trim(33170, 34615) + \
Trim(34616, 34681).InsideToFilm(2, 280, 260, 400, 360) + \
Trim(34682, 34993) + \
Trim(34994, 35076).InsideToFilm(1, 280, 260, 400, 360) + \
Trim(35077, 35168) + \
Trim(35169, 35258).InsideToFilm(3, 300, 0, 500, 136) + \
Trim(35259, 35307).InsideToFilm(3, 300, 0, 500, 300) + \
Trim(35308, 35469) + \
Trim(35470, 35661).RightToFilm(1, 400) + \
Trim(35662, 35932) + \
Trim(35933, 35991).RightToFilm(2, 400) + \
Trim(35992, 36041) + \
Trim(36042, 36134).RightToFilm(4, 392) + \
Trim(36135, 36341) + \
Trim(36342, 36433).RightToFilm(2, 392) + \
Trim(36434, 36729).FixHoloXevFilm(2) + \
Trim(36730, 36779).LeftToFilm(5, 388) + \
hx1 + \
Trim(37206, 37314).LeftToFilm(5, 384) + \
Trim(37315, 37449).LeftToFilm(4, 350) + \
Trim(37450, 37555).RightToFilm(5, 400) + \
Trim(37556, 37750).InsideToVideo(1, 120, 80, 340, 300) + \
Trim(37751, 0)

