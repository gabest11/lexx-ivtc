Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

c1 = MPEG2Source("..\..\S03(Alliance)\V01\title_t00.d2v",cpu=4)
c2 = MPEG2Source("..\..\S03(Acorn)\V01\title_t00.d2v",cpu=4)

c1 = Trim(c1, 0, 14) + c1 # Acorn has 15 empty frames at the beginning, padding just to match the audio

# correct Alliance levels

c1 = c1.ColorCorrectAllianceS03()
c2 = c2.ConvertToBFF()

# denoise single field sections

c1 = Fix240p(c1, title)
c2 = Fix240p(c2, title)

# replace the clipped brighter pixels with Acorn's

Overlay(c1, c2, mode="lighten")
