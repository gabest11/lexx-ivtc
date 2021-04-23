c1 = MPEG2Source("..\S03(Alliance)\V01\title_t00.d2v",cpu=4)
c2 = MPEG2Source("..\S03(Acorn)\V01\title_t00.d2v",cpu=4)

c1 = Trim(c1, 0, 14) + c1 # Acorn has 15 empty frames at the beginning, padding just to match the audio

# need full resolution to move the fields by 1 pixel

c1 = c1.ConvertToYV24()
c2 = c2.ConvertToYV24()

# correct Alliance levels

c1 = c1.ConvertBits(16).Levels(396, 1, 65280, 0, 60416, coring=false).ConvertBits(8, dither=1)

# swap Acorn's fields to match Alliance

c2 = c2.SeparateFields()
c2t = c2.SelectEven().Crop(0,1,-0,-0).AddBorders(0,0,0,1)
c2b = c2.SelectOdd()
c2 = Interleave(c2t, c2b).AssumeBFF().Weave()

# replace the clipped brighter pixels with Acorn's

Overlay(c1, c2, mode="lighten")

# cancel noise from the two maybe? (are they different, or one encoded from the other?)

c = last
#StackHorizontal(Merge(c, c2), Overlay(c, c2, mode="difference"))
#return StackVertical(Merge(c, c2).Crop(0,360,720,-0),c.Crop(0,360,720,-0))
Merge(c, c2)

# back to 4:2:0

ConvertToYV12()
