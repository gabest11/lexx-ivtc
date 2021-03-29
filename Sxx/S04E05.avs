c1 = MPEG2Source("..\S04(Acorn)\D03\title_t00.d2v",cpu=4)
c2 = MPEG2Source("..\S04(Acorn)\D04\title_t01.d2v",cpu=4)

Trim(c1, 0, 11209) + \
Trim(c2, 18410, 18531) + \
Trim(c1, 11332, -0)

