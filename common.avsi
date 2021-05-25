
function LoadEpisodeWithAlt(string title, int frames, val_array files)
{
	# files = [[string path, int start, bool tff], ...]
	
	for(i = 0, files.ArraySize() - 1, 1)
	{
		if(Exist(files[i][0]))
		{
			MPEG2Source(files[i][0], cpu=4)

			if(files[i].ArraySize() > 1)
			{
				start = (int)(files[i][1])
				
				if(start > 0)
				{
					Trim(start, 0)
				}
				else if(start < 0)
				{
					BlankClip(last, -start) + last
				}
			}
			
			if(files[i].ArraySize() > 2)
			{
				if(GetParity() != files[i][2])
				{
					if(files[i][2]) {ConvertToTFF}
					else {ConvertToBFF}
				}
			}

			if(frames > 0)
			{
				Trim(0, frames - 1)
			}
			
			return last
		}
	}

	assert(false, Format("Cannot find {}", title))
}

# denoise upsampled 480p without interpolation
# every other line should be the same, if not, take the average
# original chroma and field order restored by the last Overlay call

function Fix240p1E(clip c)
{
	c.AssumeTFF

	SeparateFields
	Merge(SelectEven, SelectOdd)
	Interleave(last, last)
	Weave
	
	Overlay(c, last, mode="luma")
}

function Fix240p1O(clip c)
{
	# have to shift down the odd fields by 1 pixel, merge, then back
	# also, fix first/last line

	c.AssumeBFF
	
	cc = ConvertToYV24(interlaced = true)
	
	cc.SeparateFields
	Merge(SelectEven, SelectOdd.Crop(0, 1, -0, -0).AddBorders(0, 0, 0, 1))
	Interleave(last, last)
	Weave

	Crop(0, 0, -0, -1).AddBorders(0, 1, 0, 0)
	Overlay(cc.Crop(0, 0, -0, 1), x = 0, y = 0, mode = "luma")
	Overlay(cc.Crop(0, cc.Height - 1, -0, 1), x = 0, y = cc.Height - 1, mode = "luma")
	
	ConvertToYV12(interlaced = true)
	
	Overlay(c, last, mode="luma")
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
	ConditionalFilter(GetParity() ? Fix240p1E : Fix240p1O, last, "_fix", "==", "1")
	ConditionalFilter(GetParity() ? Fix240p1O : Fix240p1E, last, "_fix", "==", "2")
	# not sure about these yet, needs parity check and make sure even selects first row by assume*
	#ConditionalFilter(Fix240p2E, last, "_fix", "==", "3")
	#ConditionalFilter(Fix240p2O, last, "_fix", "==", "4")
	ConditionalReader(title + "-var-fix.txt", "_fix")
}

# NOTE: ConvertToTFF/BFF will blur the color planes, use it wisely

function ConvertToTFF(clip c, bool "yv12")
{
	yv12 = default(yv12, true)
	assert(c.IsYV12)
	last = c
	ConvertToYV24(interlaced=true)
	Crop(0,0,-0,-1).AddBorders(0,1,0,0)
	AssumeTFF
	if(yv12) {ConvertToYV12(interlaced=true)}
}

function ConvertToBFF(clip c, bool "yv12")
{
	yv12 = default(yv12, true)
	assert(c.IsYV12)
	last = c
	ConvertToYV24(interlaced=true)
	Crop(0,1,-0,-0).AddBorders(0,0,0,1)
	AssumeBFF
	if(yv12) {ConvertToYV12(interlaced=true)}
}

function ColorCorrectAllianceS03(clip c)
{
	last = c
	
	# still just a bit brighter, close enough, within 2 y values
	
	# this way Overlay("lighten") will only overwrite values that are really higher, 
	# not just because of the compression noise
	
	ConvertBits(16)
	Levels(396, 1, 65280, 0, 60416, coring=false)
	ConvertBits(8, dither=1)
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

function ShowFields(clip c)
{
	#c = c.Crop(0,0,360,0)
	c1 = c
	c.SeparateFields
	c2 = Interleave(SelectEven.Trim(1, 0), SelectOdd).Weave
	c3 = Interleave(SelectEven.Trim(2, 0), SelectOdd).Weave
	#c4 = StackVertical(c2.Crop(0, c.Height / 2, c.Width / 2, 0), c3.Crop(0, c.Height / 2, c.Width / 2, 0))
	c4 = StackVertical(c2.Crop(c.Width / 4, c.Height / 4, c.Width / 2, c.Height / 2), c3.Crop(c.Width / 4, c.Height / 4, c.Width / 2, c.Height / 2))
	#StackHorizontal(StackHorizontal(c4, c1), StackVertical(SelectEven, SelectOdd))
	StackHorizontal(c, StackVertical(SelectEven, SelectOdd))
}

function BlendFields(clip c)
{
	c.Bob(0, 1)
	Merge(SelectEven, SelectOdd)
}

function BlendFields2(clip c, float offset)
{
	offset = Default(offset, 0)
		
	c.SeparateFields
	e = SelectEven.Spline64Resize(Width, c.Height, src_top = -0.25 + offset, src_height = Height)
	o = SelectOdd.Spline64Resize(Width, c.Height, src_top = +0.25 + offset, src_height = Height)
	Merge(e, o)
	AssumeFrameBased
}

function FixSlowMoI(clip c, int start, int end, int "fps_num", int "fc", int "ivtc", int "pd", int "deint", bool "deintdisp", int "fin", int "fout", int "mv_blksize", int "mv_overlap", int "mv_search", int "mv_searchparam", val_array "f")
{
	# depending on the last array argument, it operates on frames if f[1] is empty, 
	# else f[0] selects the even, f[1] the odd fields
	#
	# f[2] tells which resulting frames to deinterlace, odd numbers select deinterlaced frames
	# ie. [0,2,4,7,8,10] will deinterlace the 4th frame only
	#
	# f[3] selects the top/bottom field to deinterlace, if empty, top field by default
	
	last = c
	
	fps_num = Default(fps_num, 30000)
	fc = Default(fc, FrameCount)
	ivtc = Default(ivtc, 0)
	pd = Default(pd, 3)
	deint = Default(deint, 1)
	deintdisp = Default(deintdisp, false)
	fin = Default(fin, 0)
	fout = Default(fout, 0)
	mv_search = Default(mv_search, 3)
	mv_blksize = Default(mv_blksize, 32)
	mv_overlap = Default(mv_overlap, 8)
	mv_searchparam = Default(mv_searchparam, 2)
	
	Trim(start, end)

	if(f.IsArray() && f.ArraySize() > 1)
	{
		SeparateFields
	
		if(f[0].ArraySize() > 0 && f[1].ArraySize() == 0)
		{
			SelectEvery(fc, f[0])
		
			# field order would change if the second field was selected twice for a frame
		
			if(c.GetParity()) {AssumeTFF}
			else {AssumeBFF}
		}
		else if(f[0].ArraySize() > 0 && f[1].ArraySize() > 0)
		{
			e = SelectEven.SelectEvery(fc, f[0])
			o = SelectOdd.SelectEvery(fc, f[1])
			Interleave(e, o)
		}

		Weave
		
		if(f.ArraySize() > 2 && f[2].ArraySize() > 0 && deint > 0)
		{
			# NOTE: field = ttf, 0: bottom, 1: top
		
			top_field = GetParity() ? 1 : 0
			bottom_field = GetParity() ? 0 : 1
		
			if(deint == 1)
			{
				cd0 = nnedi3(field = top_field)
				cd1 = nnedi3(field = bottom_field)
			}
			else if(deint == 2)
			{
				# this makes no sense but works with the column elevator
			
				super = MSuper(pel=4)
				backward_vectors = MAnalyse(super, isb = true, blksize=32, overlap=8, search=3, delta=1)
				forward_vectors = MAnalyse(super, isb = false, blksize=32, overlap=8, search=3, delta=1)
				cdf = MFlowInter(super, backward_vectors, forward_vectors, time=50, ml=70)
				cd0 = nnedi3() # top? bottom?
				cd0 = cdf.Trim(0, FrameCount - 2) + cd0.Trim(FrameCount - 1, 0)
				cd1 = cd0
			}
			else if(deint == 3)
			{
				super = MSuper(pel=4)
				backward_vectors = MAnalyse(super, isb = true, blksize=32, overlap=8, search=3, delta=2)
				forward_vectors = MAnalyse(super, isb = false, blksize=32, overlap=8, search=3, delta=2)
				cdf = MFlowInter(super, backward_vectors, forward_vectors, time=50, ml=70)
				cd0 = nnedi3() # top? bottom?
				cd0 = cd0.Trim(0, -1) + cdf.Trim(0, FrameCount - 2)
				cd1 = cd0
			}
			else if(deint == 4)
			{
				cd0 = yadifmod2(field = top_field)
				cd1 = yadifmod2(field = bottom_field)
			}
			else if(deint == 5)
			{
				cd0 = BlendFields
				cd1 = cd0
			}

			if(f.ArraySize() > 3 && f[3].ArraySize() > 0)
			{
				cd0 = Interleave(cd0, cd1).SelectEvery(f[3].ArraySize() * 2, f[3])
			}
		
			if(deintdisp)
			{
				cd0 = cd0.Subtitle("interlaced", x = 5, y = 5)
			}

			Interleave(last, cd0).SelectEvery(f[2].ArraySize() * 2, f[2])
		}
	}

	if(ivtc > 0)
	{
		SeparateFields
		
		if(ivtc == 1) {SelectEvery(10, 2,1, 4,5, 6,7, 8,9)} # ppccc
		if(ivtc == 2) {SelectEvery(10, 0,1, 4,3, 6,7, 8,9)} # cppcc
		if(ivtc == 3) {SelectEvery(10, 0,1, 2,3, 6,5, 8,9)} # ccppc
		if(ivtc == 4) {SelectEvery(10, 0,1, 2,3, 4,5, 8,7)} # cccpp
		if(ivtc == 5) {assert(false)} #{SelectEvery(10, 0,-1, 2,3, 4,5, 6,7)} # pcccp
		
		Weave
	}
	
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
		backward_vec = MAnalyse(super, blksize=mv_blksize, overlap=mv_overlap, isb=true, search=mv_search)
		forward_vec = MAnalyse(super, blksize=mv_blksize, overlap=mv_overlap, isb=false, search=mv_search)
		MFlowFps(super, backward_vec, forward_vec, num=fps_num, den=FrameRateDenominator)#, ml=100000)
		AssumeFPS(c)
	}
	
	if(pd > 0)
	{
		SeparateFields
		if(pd == 1) {Trim(0, -6).SelectEvery(6, 0,1, 0,3, 4,5).AssumeFPS(24000,1001) + Trim(6, 0).SelectEvery(8, 0,1, 2,3, 2,5, 4,7, 6,7).AssumeFPS(24000,1001)} #{SelectEvery(8, -2,1, 0,3, 2,3, 4,5, 6,7)} # ppccc
		if(pd == 2) {SelectEvery(8, 0,1, 0,3, 2,5, 4,5, 6,7)} # cppcc
		if(pd == 3) {SelectEvery(8, 0,1, 2,3, 2,5, 4,7, 6,7)} # ccppc
		if(pd == 4) {SelectEvery(8, 0,1, 2,3, 4,5, 4,7, 6,9)} # cccpp
		if(pd == 5) {SelectEvery(8, 0,3, 2,3, 4,5, 6,7, 6,9)} # pcccp
		Weave
		AssumeFPS(c)
	}
	
	#c = last
	#assert(FrameCount == end - start + 1, Format("{} {}", FrameCount, end - start + 1))
	#return c
}

function BobMerge(clip c, bool parity)
{
	last = c
	
	offset = 0
	
	if(!parity) {offset = 0.5}

	SeparateFields

	e = SelectEven.Spline64Resize(Width, Height*2, src_top = +0.25 - offset)
	o = SelectOdd.Spline64Resize(Width, Height*2, src_top = -0.25 + offset)

	Merge(e, o)	

	#subtitle(format("{} {}", c.GetParity(), parity), align=2)
}

function FixFieldOffset(clip c, bool parity, float "offset", float "toffset", float "boffset")
{
	last = c
	
	offset = Default(offset, 0)
	toffset = Default(toffset, 0)
	boffset = Default(boffset, 0)

	SeparateFields
	
	if(c.GetParity() != parity)
	{
		ComplementParity
		
		if(parity)
		{
			e = SelectEven.Spline64Resize(Width, Height, src_top = 0.5 + offset + toffset, src_height = Height)
			o = SelectOdd.Spline64Resize(Width, Height, src_top = -0.5 + offset + toffset, src_height = Height)
		}
		else
		{
			e = SelectEven.Spline64Resize(Width, Height, src_top = -0.5 + offset + boffset, src_height = Height)
			o = SelectOdd.Spline64Resize(Width, Height, src_top = 0.5 + offset + boffset, src_height = Height)
		}
	}
	else
	{
		e = SelectEven.Spline64Resize(Width, Height, src_top = 0 + offset + toffset, src_height = Height)
		o = SelectOdd.Spline64Resize(Width, Height, src_top = 0 + offset + toffset, src_height = Height)
	}
	
	Interleave(e, o)
	Weave

	#subtitle(format("{} {}", c.GetParity(), parity), align=2)
}

function FixSplitFieldsVideo(clip c, int s, int e)
{
	c.Trim(s, e)
	AssumeFieldBased
	Weave
	AssumeFPS(c)
	Spline64Resize(Width, Height / 2)
	FixSlowMoI(0, FrameCount - 1, 60000, pd = 0)
}

function FixSplitFields(clip c, int s, int e, int pd)
{
	pd = Default(pd, 3)
	
	# only for this kind of pattern:
		
	# 1 222 33 444 55 666 77 888
	# l hlh lh lhl hl hlh lh lhl
	
	# fields are split into frames and a pulldown on top of it
	
	# there quite a few clips like this, not sure how similar they are
	
	Trim(c, s - 1, e)
	SelectEvery(10, 0,1, 2,3, 6,5, 8,9)
	Trim(0, length=2).SelectEvery(2, 1,1).nnedi3 + Trim(2, 0) # first frame half field
	AssumeFieldBased
	Weave
	AssumeFPS(c)

	# double the frame count to match the original
	
	FixSlowMoI(0, FrameCount, 60000, pd = 0, fc = 2, f = [[0, 1], []])
	
	# restore size

	Spline64Resize(Width, Height / 2)
	
	# pulldown again

	if(pd > 0)
	{
		SeparateFields
		if(pd == 1) {assert(false)} #{SelectEvery(8, -2,1, 0,3, 2,3, 4,5, 6,7)} # ppccc
		if(pd == 2) {SelectEvery(8, 0,1, 0,3, 2,5, 4,5, 6,7)} # cppcc
		if(pd == 3) {SelectEvery(8, 0,1, 2,3, 2,5, 4,7, 6,7)} # ccppc
		if(pd == 4) {assert(false)} #{SelectEvery(8, 0,1, 2,3, 4,5, 4,7, 6,9)} # cccpp
		if(pd == 5) {assert(false)} #{SelectEvery(8, 0,3, 2,3, 4,5, 6,7, 6,9)} # pcccp
		Weave
		AssumeFPS(c)
	}
}

function LeftToVideo(clip c, int i, int w)
{
	last = c
	
	Overlay(FixSlowMoI(0, FrameCount - 1, 37500, pd = 0, ivtc = i).Crop(0, 0, w, -0))
}

function RightToVideo(clip c, int i, int w)
{
	last = c
	
	Overlay(FixSlowMoI(0, FrameCount - 1, 37500, pd = 0, ivtc = i).Crop(w, 0, -0, -0), x = w)
}

function TopToVideo(clip c, int i, int h)
{
	last = c
	
	Overlay(FixSlowMoI(0, FrameCount - 1, 37500, pd = 0, ivtc = i).Crop(0, 0, -0, h))
}

function BottomToVideo(clip c, int i, int h)
{
	last = c
	
	Overlay(FixSlowMoI(0, FrameCount - 1, 37500, pd = 0, ivtc = i).Crop(0, h, -0, -0), y = h)
}

function LeftToFilm(clip c, int i, int w)
{
	last = c
	
	Overlay(FixSlowMoI(0, FrameCount - 1, 37500, pd = i).Crop(0, 0, w, -0))
}

function RightToFilm(clip c, int i, int w)
{
	last = c
	
	Overlay(FixSlowMoI(0, FrameCount - 1, 37500, pd = i).Crop(w, 0, -0, -0), x = w)
}

function TopToFilm(clip c, int i, int h)
{
	last = c
	
	Overlay(FixSlowMoI(0, FrameCount - 1, 24000, pd = i).Crop(0, 0, -0, h))
}

function BottomToFilm(clip c, int i, int h)
{
	last = c
	
	Overlay(FixSlowMoI(0, FrameCount - 1, 24000, pd = i).Crop(0, h, -0, -0), y = h)
}

# TODO: rect to *