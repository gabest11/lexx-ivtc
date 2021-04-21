d2vpath="title_t00.d2v"
MPEG2Source(d2vpath,cpu=4)

function FixResize(c, s, e)
{
	Trim(c, s, e)
	SeparateFields().SelectOdd().Spline64Resize(c.Width, c.Height)
	#Bob().SelectOdd()
	Trim(c, 0, s - 1) + last + Trim(c, e + 1, -0)
}

function FixEEDI3(c, s, e)
{
	Trim(c, s, e)
	eedi3(field=0, mdis=3)
	Trim(c, 0, s - 1) + last + Trim(c, e + 1, -0)
}

FixEEDI3(1245,1272)
FixEEDI3(1329,1526)
FixEEDI3(1559,1725)
FixEEDI3(2057,8309)
FixEEDI3(8615,39020)
FixEEDI3(39246,43654)
FixEEDI3(43784,54034)
FixEEDI3(54253,83494)

#FixResize()
