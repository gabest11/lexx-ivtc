# Allience release (better bitrate) and the missing section from Koch's, cut to match Koch's audio track

c1 = MPEG2Source("..\S01(Alliance)\D03\title_t00.d2v",cpu=4)
#c2 = MPEG2Source("..\S01(Koch)\D03\title_t00p1.d2v",cpu=4).Letterbox(0,0,2,2)

# nothing to replace so far... only a placeholder

Trim(c1, 35, 169633) #+ Trim(c2, , ) + Trim(c1, , -0) 
