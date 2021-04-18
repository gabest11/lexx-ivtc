d2vpath="title_t03.d2v"
MPEG2Source(d2vpath,cpu=4)

function BlurDoubleVision(c)
{
	c.Bob
	Merge(SelectEven, SelectOdd)
}

Trim(0,829) + \
Trim(830,1201).BlurDoubleVision() + \
Trim(1202,-0)

