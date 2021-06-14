Import("../../common.avsi")

LoadEpisodeWithAlt("S04E04", 80780, \
	["..\..\S04(Koch)\V01\title_t03.d2v"], \
	["..\..\S04(Acorn)\D02\title_t01.d2v"])
	
# small TV
	
function FixTV1Video(clip c, int s, int e, int i)
{
	Trim(c, s, e)
	c1 = BlendFields
	Overlay(c1.Crop(242, 200, 556 - 242, 408 - 200), 242, 200)
}

# big TV
	
function FixTV2Video(clip c, int s, int e, int i)
{
	Trim(c, s, e)
	c1 = BlendFields
	Overlay(c1.Crop(146, 40, 606 - 146, 368 - 40), 146, 40)
}

# anoter small TV
	
function FixTV3Video(clip c, int s, int e, int i)
{
	Trim(c, s, e)
	c1 = BlendFields
	Overlay(c1.Crop(226, 168, 574 - 226, 394 - 168), 226, 168)
}

# anoter big TV
	
function FixTV4Video(clip c, int s, int e, int i)
{
	Trim(c, s, e)
	c1 = BlendFields
	Overlay(c1.Crop(146, 76, 594 - 146, 386 - 76), 146, 76)
}


Trim(0, 17156) + \
FixTV1Video(17157, 17275, 3) + \
Trim(17276, 17435) + \
FixTV2Video(17436, 17653, 3) + \
Trim(17654, 17754) + \
FixTV2Video(17755, 19189, 3) + \
Trim(19190, 19326) + \
FixTV3Video(19327, 19414, 3) + \
Trim(19415, 37073) + \
FixTV4Video(37074, 37157, 3) + \
Trim(37158, 37401) + \
FixTV4Video(37402, 37450, 3) + \
Trim(37451, 58364) + \
FixTV2Video(58365, 58513, 3) + \
Trim(58514, 58682) + \
FixTV2Video(58683, 58808, 3) + \
Trim(58809, 59097) + \
FixTV2Video(59098, 59168, 3) + \
Trim(59169, 62954) + \
FixPP(62955, 63024, 1) + \
Trim(63025, 0)
