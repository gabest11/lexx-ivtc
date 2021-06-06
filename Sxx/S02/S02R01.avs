Import("../../common.avsi")

LoadEpisodeWithAlt("S02R01", 11450, \
	["..\..\S02(Acorn)\V01\title_t03.d2v"], \
	["..\..\S02(Acorn)\D01\title_t01.d2v"])

function FixTransportShips(clip c, bool blend)
{
	Trim(c, 2758, 3222)

	ConvertToYV24(interlaced = true)

	Separatefields

	DeleteFrame(18,34,47,63,79,93,109,125,141,154, \
		170,186,202,216,232,248,264,280,293,309, \
		325,339,355,371,387,400,416,432,448,464, \
		478,494,510,526,539,555,571,587,601,617, \
		633,649,665,678,694,710,726,740,756,772, \
		788,804,817,833,849,863,879,895,911,924)

	SelectEvery(10, 0,1, 4,3, 6,7, 8,9).Weave.AssumeFPS(c)

	if(blend)
	{
		ScriptClip("BobMerge(GetParity(current_frame))")
	}
	else
	{
		ScriptClip("FixFieldOffset(GetParity(current_frame), offset = 0.25)")
	}
	
	if(c.GetParity) {AssumeTFF}
	else {AssumeBFF}
	
	ConvertToYV12(interlaced = true)
	
	Trim(1, 0)

	FixSlowMoI(0, FrameCount - 1, 40200, pd = 0)
	#FixSlowMoI(0, FrameCount - 1, 32100)
}

fix1 = FixTransportShips(true)

Trim(0, 2758) + \
fix1 + \
Trim(3223, 0)