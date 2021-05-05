Import("..\..\S03(Acorn)/common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

c1 = MPEG2Source("..\..\S03(Alliance)\V01\title_t00.d2v",cpu=4)
c2 = MPEG2Source("..\..\S03(Acorn)\V01\title_t00.d2v",cpu=4)

c1 = Trim(c1, 0, 14) + c1 # Acorn has 15 empty frames at the beginning, padding just to match the audio

# need full resolution to move the fields by 1 pixel

c1 = c1.ConvertToYV24()
c2 = c2.ConvertToYV24()

# correct Alliance levels

c1 = ConvertAllianceS03(c1)

# denoise single field sections

c1 = Fix(c1, title)
c2 = Fix(c2, title)

# replace the clipped brighter pixels with Acorn's

Overlay(c1, c2, mode="lighten")

# cancel noise from the two maybe? (are they different, or one encoded from the other?)

#c = last
#return StackHorizontal(Merge(c, c2), Overlay(c, c2, mode="difference"))
#return StackVertical(Merge(c, c2).Crop(0,360,720,-0),c.Crop(0,360,720,-0))
#Merge(c, c2) # Acorn is missing the sides, have to re-add (Overaly) those back if we do this
