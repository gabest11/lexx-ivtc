function Fix240p1(clip c)
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

function Fix240p2(clip c)
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

function Fix240p2E(clip c)
{
	Fix240p2(c)
	SeparateFields.SelectEven
	Interleave(last, c.SeparateFields.SelectOdd)
	Weave
	#SeparateRows(2).SelectEven
	#PointResize(c.Width, c.Height)
}

function Fix240p2O(clip c)
{
	Fix240p2(c)
	SeparateFields.SelectOdd
	Interleave(c.SeparateFields.SelectEven, last)
	Weave
	#SeparateRows(2).SelectOdd
	#PointResize(c.Width, c.Height)
}

function Fix240p(clip c, string title)
{
	last = c
	ConditionalFilter(Fix240p1, last, "_fix", "==", "1")
	# not sure about these yet
	#ConditionalFilter(Fix240p2E, last, "_fix", "==", "2")
	#ConditionalFilter(Fix240p2O, last, "_fix", "==", "3")
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

function FieldChecker(clip c)
{
	c.SeparateFields
	StackHorizontal(c, StackVertical(SelectEven, SelectOdd))
}

function FixSlowMoI(clip c, int start, int end, int "fps_num", int "fc", int "ivtc", bool "pd", int "fin", int "fout", int "mv_search", val_array "f")
{
	last = c
	
	fps_num = Default(fps_num, 30000)
	fc = Default(fc, FrameCount)
	ivtc = Default(ivtc, 0)
	pd = Default(pd, true)
	fin = Default(fin, 0)
	fout = Default(fout, 0)
	mv_search = Default(mv_search, 3)
	
	Trim(start, end)
	SeparateFields
	e = SelectEven.SelectEvery(fc, f[0])
	o = SelectOdd.SelectEvery(fc, f[1])
	if(ivtc == 1) {SelectEvery(10, 2,1, 4,5, 6,7, 8,9)} # ppccc
	if(ivtc == 2) {SelectEvery(10, 0,1, 4,3, 6,7, 8,9)} # cppcc
	if(ivtc == 3) {SelectEvery(10, 0,1, 2,3, 6,5, 8,9)} # ccppc
	if(ivtc == 4) {SelectEvery(10, 0,1, 2,3, 4,5, 8,7)} # cccpp
	if(ivtc == 5) {SelectEvery(10, 0,1, 2,3, 4,5, 8,7)} # pcccp
	Interleave(e, o)
	Weave
	AssumeFPS(c)
	
	# fin, fout are frame counts before pulldown, kinda have to guess it
	
	if(fin > 0) 
	{
		if(fin < FrameCount) {Trim(0, fin - 1).nnedi3 + Trim(fin, 0)}
		else {nnedi3}
	}
	
	if(fout > 0)
	{
		if(fout < FrameCount) {Trim(0, FrameCount - fout - 1) + Trim(FrameCount - fout, 0).nnedi3}
		else {nnedi3}
	}
	
	if(fps_num != 30000)
	{
		super = MSuper(pel=4) #, hpad=0, vpad=0
		backward_vec = MAnalyse(super, blksize=32, overlap=8, isb=true, search=mv_search)
		forward_vec = MAnalyse(super, blksize=32, overlap=8, isb=false, search=mv_search)
		MFlowFps(super, backward_vec, forward_vec, num=fps_num, den=FrameRateDenominator)#, ml=100000)
		AssumeFPS(c)
	}
	
	if(pd)
	{
		SeparateFields
		SelectEvery(8, 0,1, 2,3, 2,5, 4,7, 6,7) # ccppc
		Weave
		AssumeFPS(c)
	}
	
	#c = last
	#assert(FrameCount == end - start + 1, Format("{} {}", FrameCount, end - start + 1))
	#return c
}
