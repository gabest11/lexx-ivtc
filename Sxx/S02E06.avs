c1 = MPEG2Source("..\S02(Acorn)\V02\title_t01.d2v",cpu=4)

# choose any version, Allince encode is a bit higher bitrate

#c2 = MPEG2Source("..\S01(Koch)\D04\title_t00p1.d2v",cpu=4)
c2 = MPEG2Source("..\S01(Alliance)\D04\title_t00.d2v",cpu=4).Trim(30,-0)

# c1 S02E06 38160,38216 (57) cppcc 38217,38402 c (186)
# c2 S01E04 38240,38296 (57) cppcc 38297,38396 pcccp (100)

function FixMegashadowOnDisplay(c, start, end)
{
	# turn c2's 38240,38396 (157) into c1's 38160,38402 (243)

	Trim(c, start, end) # 157 frames
	SeparateFields()
	SelectEvery(10, 0,1, 4,3, 6,7, 8,9) # cppcc
	Weave().AssumeFPS(30000, 1001) # 126 frames
	c1 = Trim(0, 8) # 9 at normal speed
	c2 = Trim(9, -0) # 117 at half speed (it was 1/3 speed with many skips, much better already)
	return c1 + Interleave(c2, c2).AssumeFPS(30000, 1001)
}

Trim(c1, 0, 38159) + \
FixMegashadowOnDisplay(c2, 38240, 38396) + \
Trim(c1, 38403, -0)