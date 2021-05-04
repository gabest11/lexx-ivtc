Import("../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

MPEG2Source(title + ".d2v",cpu=4)

ConvertToYV24 # ?

#Fix(title)
