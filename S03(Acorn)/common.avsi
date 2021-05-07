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
	Interleave(last, c.SeparateFields.SelectOdd)
	Weave
	#SeparateRows(2).SelectEven
	#PointResize(c.Width, c.Height)
}

function Fix2O(clip c)
{
	Fix2(c)
	SeparateFields.SelectOdd
	Interleave(c.SeparateFields.SelectEven, last)
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

function Detect240p(clip c)
{
	# if there is no or very little difference visible:
	#
	# tl even fields are interpolated (2=(1+3)/2,4=(3+5)/2,...)
	# tr odd fields are interpolated (1=(0+2)/2,3=(2+4)/2,...)
	# bl even and odd fields are the same (0=1,2=3,...)
	# br odd and even fields are the same (1=2,3=4,...)
	
	c1 = c.SeparateRows(2)
	c2 = c.PointResize(c.Width, c.Height, src_top = 1, src_height = c.Height)
	c2 = c2.SeparateRows(2)
	Expr(c, "x[0,-1] x[0,+1] + 0.5 *")
	SeparateRows(2)
	e1 = Overlay(SelectEven, c1.SelectEven, mode = "difference")
	o1 = Overlay(SelectOdd, c1.SelectOdd, mode = "difference")
	e2 = Overlay(c1.SelectEven, c1.SelectOdd, mode = "difference")
	o2 = Overlay(c2.SelectEven, c2.SelectOdd, mode = "difference")
	StackVertical(StackHorizontal(e1, o1),StackHorizontal(e2, o2))
}
