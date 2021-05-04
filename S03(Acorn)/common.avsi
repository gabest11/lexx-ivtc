function Fix1(clip c)
{
	# denoise upsampled 480p without interpolation
	# every other line should be the same
	# if not, take the average
	
	c.SeparateFields
	Merge(SelectEven, SelectOdd)
	Interleave(last, last)
	Weave
	#PointResize(c.Width, c.Height)
}

function Fix2(clip c)
{
	# denoise interpolated 480p
	# extract original value from interpolated lines 
	# and average them with the real rows

	a = Expr(c, "x[0,-1] 2.0 * x[0,-2] -")
	b = Expr(c, "x[0,+1] 2.0 * x[0,+2] -")
	#c = Expr(a, b, c, "x y z + + 3.0 /")
	c = Expr(a, b, c, "x y + 0.5 * z + 0.5 *")
	
	return c
}

function Fix2E(clip c)
{
	Fix2(c)
	SeparateFields.SelectEven
	Interleave(last, last)
	Weave
	#SeparateRows(2).SelectEven
	#PointResize(c.Width, c.Height)
}

function Fix2O(clip c)
{
	Fix2(c)
	SeparateFields.SelectOdd
	Interleave(last, last)
	Weave
	#SeparateRows(2).SelectOdd
	#PointResize(c.Width, c.Height)
}

function Fix(clip c, string title)
{
	last = c
	ConditionalFilter(Fix1, last, "_fix", "==", "1")
	# not sure about these yet
	#ConditionalFilter(Fix2E, last, "_fix", "==", "2")
	#ConditionalFilter(Fix2O, last, "_fix", "==", "3")
	ConditionalReader(title + "-var-fix.txt", "_fix")
}

function ConvertAllianceS03(clip c)
{
	last = c
	# still just a bit brighter, close enough, within 2 y values
	ConvertBits(16).Levels(396, 1, 65280, 0, 60416, coring=false).ConvertBits(8, dither=1)
	SeparateFields
	t = SelectEven.Crop(0,0,-0,-1).AddBorders(0,1,0,0)
	b = SelectOdd
	Interleave(t, b).AssumeTFF.Weave
}
