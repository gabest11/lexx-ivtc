Import("../../common.avsi")

MPEG2Source("title_t02.d2v",cpu=4)

Trim(0, 12759) + \
Trim(12760, 13011).TopToFilm(3, 144) + \
Trim(13012, 27578) + \
Trim(27579, 27859).LeftToFilm(3, 360) + \
Trim(27860, 0)

#Trim(27579, 27859).RightToVideo(3, 360) + \
#return showfields