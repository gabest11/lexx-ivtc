# Allience release (better bitrate) and the missing section from Koch's, cut to match Koch's audio track

c1 = MPEG2Source("..\S01(Alliance)\D04\title_t00.d2v",cpu=4)
c2 = MPEG2Source("..\S01(Koch)\D04\title_t00p1.d2v",cpu=4).Letterbox(0,0,2,2)

Trim(c1, 30, 75348) + \
Trim(c2, 75319, 75506) + \
Trim(c1, 75538, 107839) + \
Trim(c2, 107809, 107901) + \
Trim(c1, 107932, 158522) + \
Trim(c2, 158493, 158550) + \
Trim(c1, 158580, 167263)
