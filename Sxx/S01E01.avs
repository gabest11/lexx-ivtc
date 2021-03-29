# Allience release (better bitrate) and the missing section from Koch's, cut to match Koch's audio track

c1 = MPEG2Source("..\S01(Alliance)\D01\title_t00.d2v",cpu=4)
c2 = MPEG2Source("..\S01(Koch)\D01\title_t00p1.d2v",cpu=4).Letterbox(0,0,2,2)

Trim(c1, 5, 107818) + \
Trim(c2, 107814, 108064) + \
Trim(c1, 108044, 167305)
