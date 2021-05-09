Import("../../common.avsi")

# Allience release (better bitrate) and the missing section from Koch's, cut to match Koch's audio track

c1 = MPEG2Source("..\..\S01(Alliance)\D04\title_t00.d2v",cpu=4)
c2 = MPEG2Source("..\..\S01(Koch)\D04\title_t00p1.d2v",cpu=4).Letterbox(0,0,2,2)

Trim(c1, 30, 75348) + \
Trim(c2, 75319, 75506) + \
Trim(c1, 75538, 107839) + \
Trim(c2, 107809, 107901) + \
Trim(c1, 107932, 158522) + \
Trim(c2, 158493, 158550) + \
Trim(c1, 158580, 167263)

# moth flying over the exploding gigashadow

# bit naughty asking for the last field outside the batch, 
# but step size is just a step size, not a restriction

fix1 = FixSlowMoI(132527, 132680, 38130, fc = 19, f = [ \
	[1,3,5,6,7,9,10,12,13,15,16,19], \
	[0,2,3,5,6,8,10,12,13,15,16,18] \
	])

# Lexx firing at the gigashadow, watching on the oval display

# it's already a morphing gfx, morphing it even harder at 29.97

fix2 = FixSlowMoI(138458, 138543, 51500, pd = false, f = [ \
	[1,3,4,6,7,9,11,13,14,16,18,20,21,23,24,26,28,30,31,33,34,37,38,40,41,43,45,47,48,50,51,53,55,57,58,60,62,64,65,67,68,70,72,74,75,77,78,80,82,84,85], \
	[0,2,4,6,7,9,10,12,14,16,17,19,20,22,24,26,27,29,31,33,34,36,37,39,41,43,44,46,48,50,51,53,54,56,58,60,61,63,64,66,68,70,71,73,75,77,78,80,81,83,85] \
	])

Trim(0, 132526) + \
fix1 + \
Trim(132681, 138457) + \
fix2 + \
Trim(138544, 0)
