Import("../../common.avsi")

path1 = "..\..\S02(Acorn)\V01\title_t04.d2v"
path2 = "..\..\S02(Acorn)\D02\title_t00.d2v"

if(Exist(path1))
{
	MPEG2Source(path1, cpu=4)
}
else if(Exist(path2))
{
	MPEG2Source(path2, cpu=4)
}
else
{
	assert(false, "Cannot find S02E03")
}

Trim(0, 86099)
