d2vpath="title_t05.d2v"
MPEG2Source(d2vpath,cpu=4)

c0 = separatefields
c0.selecteven
ScriptClip("Spline64Resize(Width, Height, src_top = f0_offset, src_height = Height)")
ConditionalReader("title_t05-var-f0_offset.txt", "f0_offset")
c1 = last
c0.selectodd
ScriptClip("Spline64Resize(Width, Height, src_top = f1_offset, src_height = Height)")
ConditionalReader("title_t05-var-f1_offset.txt", "f1_offset")
c2 = last

#c3 = overlay(c1, c2, mode = "difference").levels(96,1,160,0,255)
#stackhorizontal(c1, c2)

Interleave(c1, c2).Weave()
