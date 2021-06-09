Import("../../common.avsi")

LoadEpisodeWithAlt("S04E01", 81260, \
	["..\..\S04(Koch)\V01\title_t00.d2v"], \
	["..\..\S04(Acorn)\D01\title_t00.d2v"])

# 3 TVs closer

function FixTV1Film(clip c, int s, int e, int i)
{
	Trim(c, s, e)
	c1 = BlendFields.LeftToFilm(i, 512)
	Overlay(c1.Crop(200, 144, 512 - 200, 360 - 144), 200, 144)
	Overlay(c1.Crop(0, 0, 80 - 0, 120 - 0), 0, 0)
}
	
function FixTV1Video(clip c, int s, int e, int i)
{
	Trim(c, s, e)
	c1 = BlendFields
	c2 = InsideToVideo(i, 632, 0, 720, 120)
	Overlay(c1.Crop(200, 144, 512 - 200, 360 - 144), 200, 144)
	Overlay(c1.Crop(0, 0, 80 - 0, 120 - 0), 0, 0)
	Overlay(c2.Crop(632, 0, 720 - 632, 120 - 0), 632, 0)
}

# 3 TVs further

function FixTV2Film(clip c, int s, int e, int i1, int i2)
{
	Trim(c, s, e)
	c1 = BlendFields.LeftToFilm(i1, 480)
	Overlay(c1.Crop(312, 192, 462 - 312, 296 - 192), 312, 192)
	Overlay(c1.Crop(160, 112, 264 - 160, 188 - 112), 160, 112)
}

function FixTV2Video(clip c, int s, int e, int i1, int i2)
{
	Trim(c, s, e)
	c1 = BlendFields
	c2 = InsideToVideo(i1, 516, 112, 620, 184)
	c3 = OutsideToVideo(i2, 632, 0, 720, 120)
	last = c3
	Overlay(c1.Crop(312, 192, 462 - 312, 296 - 192), 312, 192)
	Overlay(c1.Crop(160, 112, 264 - 160, 188 - 112), 160, 112)
	Overlay(c2.Crop(516, 112, 620 - 516, 184 - 112), 516, 112)
}

# 1 big TV
	
function FixTV3Film(clip c, int s, int e, int i)
{
	Trim(c, s, e)
	c1 = BlendFields.InsideToFilm(i, 104, 88, 600, 432)
	Overlay(c1.Crop(104, 88, 600 - 104, 432 - 88), 104, 88)
}
	
function FixTV3Video(clip c, int s, int e, int i)
{
	Trim(c, s, e)
	c1 = BlendFields
	Overlay(c1.Crop(104, 88, 600 - 104, 432 - 88), 104, 88)
}

#

function FixTV4(clip c)
{
	# fg & right tv ccppc, mid tv pcccp, left tv 59.94i?
	
	Trim(c, 48177, 48186)
	
	c1 = BlendFields.LeftToFilm(3, 480)
	c2 = FilmToFilm(5, 3)
	Overlay(c1.Crop(160, 112, 264 - 160, 188 - 112), 160, 112)
	Overlay(c2.Crop(312, 192, 462 - 312, 296 - 192), 312, 192)
}

function FixTV5(clip c)
{
	# fg ccppc, mid & right tv tv pcccp, left tv 59.94i?
	
	Trim(c, 48187, 48230)
	
	c1 = BlendFields.LeftToFilm(3, 480)
	c2 = FilmToFilm(5, 3) # FIXME: FilmToFilm skips the first half frame in pcccp
	Overlay(c1.Crop(160, 112, 264 - 160, 188 - 112), 160, 112)
	Overlay(c2.Crop(312, 192, 462 - 312, 296 - 192), 312, 192)
	Overlay(c2.Crop(516, 112, 620 - 516, 184 - 112), 516, 112)
}

function FixTV6(clip c)
{
	# fg cccpp, tvs ppccc
	
	Trim(c, 48231, 48387)
	
	c2 = FilmToFilm(1, 4)
	Overlay(c2.Crop(160, 112, 264 - 160, 188 - 112), 160, 112)
	Overlay(c2.Crop(312, 192, 462 - 312, 296 - 192), 312, 192)
	Overlay(c2.Crop(516, 112, 620 - 516, 184 - 112), 516, 112)
}


# spinning star

fix1 = Trim(48435, 48525)
fix1 = fix1.Overlay(fix1.BlendFields.LeftToFilm(5, 720).Crop(440, 342, 480 - 440, 376 - 342), 440, 342)
fix1 = fix1.Overlay(fix1.BlendFields.LeftToFilm(5, 720).Crop(112, 342, 210 - 112, 430 - 342), 112, 342)

Trim(0, 43205) + \
FixTV1Video(43206, 43346, 5) + \
Trim(43347, 43572) + \
FixTV1Video(43573, 43794, 4) + \
Trim(43795, 43950) + \
FixTV3Video(43951, 44071, 3) + \
Trim(44072, 44474) + \
FixTV3Video(44475, 44577, 3) + \
Trim(44578, 44700) + \
FixTV1Video(44701, 44795, 4) + \
Trim(44796, 45043) + \
FixTV3Video(45044, 45207, 3) + \
Trim(45208, 46529) + \
FixTV2Film(46530, 46580, 4, 3) + \
Trim(46581, 46841) + \
FixTV3Video(46842, 46955, 3) + \
Trim(46956, 47007) + \
FixTV3Video(47008, 47042, 3) + \
Trim(47043, 47289) + \
FixTV3Video(47290, 47576, 3) + \
Trim(47577, 47681) + \
FixTV3Video(47682, 47769, 3) + \
Trim(47770, 48071) + \
Trim(48072, 48176) + \
FixTV4 + \
FixTV5 + \
FixTV6 + \
Trim(48388, 48434) + \
fix1 + \
Trim(48526, 48589) + \
Trim(48590, 48831) + \
FixTV3Video(48832, 48833, 3) + \
Trim(48834, 0)