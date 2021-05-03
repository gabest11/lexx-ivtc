# Web and Net are very similar episodes, one can be used to fix the other

c1 = MPEG2Source("..\S02(Acorn)\V04\title_t05.d2v",cpu=4)
c2 = MPEG2Source("..\S02(Koch)\V05\title_t00.d2v",cpu=4)

Trim(c1, 0, 33442) + \
Trim(c2, 23159, 23225) + \
Trim(c1, 33510, 33838) + \
Trim(c2, 23555, 23712) + \
Trim(c1, 33997, 34116) + \
Trim(c2, 23833, 23866) + \
Trim(c1, 34151, -0)
