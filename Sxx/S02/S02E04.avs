Import("../../common.avsi")

LoadEpisodeWithAlt("S02E04", 86130, \
	["..\..\S02(Acorn)\V01\title_t05.d2v"], \
	["..\..\S02(Acorn)\D02\title_t00.d2v", 86100])

c0 = SeparateFields
c0.SelectEven
ScriptClip("Spline64Resize(Width, Height, src_top = f0_offset, src_height = Height)")
ConditionalReader("S02E04-var-f0_offset.txt", "f0_offset")
c1 = last
c0.SelectOdd
ScriptClip("Spline64Resize(Width, Height, src_top = f1_offset, src_height = Height)")
ConditionalReader("S02E04-var-f1_offset.txt", "f1_offset")
c2 = last

#c3 = overlay(c1, c2, mode = "difference").levels(96,1,160,0,255)
#stackhorizontal(c1, c2)

Interleave(c1, c2).Weave()

