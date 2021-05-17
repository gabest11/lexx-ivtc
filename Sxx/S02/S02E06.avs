Import("../../common.avsi")

path1 = "..\..\S02(Acorn)\V02\title_t01.d2v"
path2 = "..\..\S02(Acorn)\D03\title_t00.d2v"

if(Exist(path1))
{
	MPEG2Source(path1, cpu=4)
}
else if(Exist(path2))
{
	MPEG2Source(path2, cpu=4).Trim(86160, 0)
}
else
{
	assert(false, "Cannot find S02E06")
}

Trim(0, 86074)

# Mega Shadow on Stanley's display (Alliance has a bit higher bitrate, but swapped field order)

path3 = "..\..\S01(Alliance)\D04\title_t00.d2v"
path4 = "..\..\S01(Koch)\D04\title_t00p1.d2v"

if(Exist(path3)) 
{
	S01E04 = MPEG2Source(path3, cpu=4).Trim(30, 0).ConvertToTFF
}
else if(Exist(path4)) 
{
	S01E04 = MPEG2Source(path4, cpu=4)
}

if(IsClip(S01E04))
{
	# S02E06 38160,38216 (57) cppcc 38217,38402 c (186)
	# S01E04 38240,38296 (57) cppcc 38297,38396 pcccp (100)
	# turn S01E04's 38240,38396 (157) into 38160,38402 (243)

	#fix1 = FixSlowMoI(S01E04, 38240, 38396, 46500, pd = 2, ivtc = 2)
	#fix1 = FixSlowMoI(S01E04, 38240, 38396, 58100, pd = 0, ivtc = 2)	
	fix1 = Trim(S01E04, 38240, 38249) + FixSlowMoI(S01E04, 38250, 38396, 47500, pd = 2, ivtc = 2)
}
else
{
	fix1 = Trim(38160, 38402)
}

Trim(0, 38159) + \
fix1 + \
Trim(38403, 0)
