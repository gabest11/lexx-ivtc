d2vpath="title_t03.d2v"
MPEG2Source(d2vpath,cpu=4)

function Fix(c)
{
	c.SeparateFields().SelectEven().Spline64Resize(c.Width, c.Height)
}

Trim(0, 31530) + \
Trim(31531, 38924).Fix() + \
Trim(38925, 40812) + \
Trim(40813, 44627).Fix() + \
Trim(44628, 46135) + \
Trim(46136, 47999).Fix() + \
Trim(48000, 49896) + \
Trim(49897, 51739).Fix() + \
Trim(51740, 57652) + \
Trim(57653, 61933).Fix() + \
Trim(61934, 63874) + \
Trim(63875, 65099).Fix() + \
Trim(65100, 66501) + \
Trim(66502, 70718).Fix() + \
Trim(70719, 70846) + \
Trim(70847, 75239).Fix() + \
Trim(75240, -0)

#StackHorizontal(c.Crop(180,0,360,480), Crop(180,0,360,480))