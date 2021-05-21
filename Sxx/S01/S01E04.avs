Import("../../common.avsi")

# Alliance vs Koch
#
# Koch / Alliance
# 0-75361 = 30-75391 +30
# Alliance 75392 missing from Koch
# 75362-107808 = 75393-107839 +31
# Koch 107809 missing from Alliance
# 107810-158549 = 107840-158579 +30
# Koch 158550 missing from Alliance
# 158551- = 158580- +29

kochpath = "..\..\S01(Koch)\D04\title_t00p1.d2v"
allipath = "..\..\S01(Alliance)\D04\title_t00.d2v"

if(Exist(kochpath))
{
	MPEG2Source(kochpath, cpu=4).Letterbox(0,0,2,2)

	if(Exist(allipath))
	{
		c = ConvertToBFF()

		MPEG2Source(allipath, cpu=4)
		
		Trim(30, 75348) + \
		Trim(c, 75319, 75506) + \
		Trim(75538, 107839) + \
		Trim(c, 107809, 107901) + \
		Trim(107932, 158522) + \
		Trim(c, 158493, 158550) + \
		Trim(158580, 0)
	}
}
else if(Exist(allipath))
{
	MPEG2Source(allipath, cpu=4)
	
	Trim(30, 75391) + \
	Trim(75393, 107839) + \
	Trim(107840, -1) + \
	Trim(107840, 158579) + \
	Trim(158579, -1) + \
	Trim(158580, 0)
}
else
{
	assert(false, "Cannot find S01E04")
}

Trim(0, 167234)

# moth flying over the exploding gigashadow

# by field (they are the same, the first is 10 frame ahead, pattern repeats in every 19 frames)
#
# 132527 pcp
#        cpc
# 132530 ccpcc pccpc cpccp cpcpc cpccp ccpcc pccpc pcpcc pccpc cpccp
#        cpccp cpcpc cpccp ccpcc pccpc pcpcc pccpc cpccp ccpcp cpccp
# 132580 ccpcp cpccp ccpcc pccpc cpcpc pccpc cpccp ccpcc pcpcp ccpcc
#        ccpcc pccpc cpcpc pccpc cpccp ccpcc pcpcp ccpcc pccpc cpccp
# 132630 pccpc cpccp cpcpc cpccp ccpcc pccpc pcpcc pccpc cpccp ccpcp
#        cpcpc cpccp ccpcc pccpc pcpcc pccpc cpccp ccpcp ccpcp ccpcc
# 132680 c
#        p

# bit naughty asking for the last field outside the batch, but step size is just a step size, not a restriction

fix1 = FixSlowMoI(132527, 132680, 38130, fc = 19, f = [ \
	[1,3,5,6,7,9,10,12,13,15,16,19], \
	[0,2,3,5,6,8,10,12,13,15,16,18] \
	])

# Lexx firing at the gigashadow, watching on the oval display

# 138458    pc
#           cp
# 138460 pccpc cpcpc pccpc pcpcc pccpc pcpcc pccpp ccpcc pcpcp ccpcc
#        cpcpc cpccp cpcpc cpccp cpcpc cpcpc pccpc cpcpc pccpc pcpcc
# 138510 pcpcp ccpcp cpccp ccpcp cpccp ccpcp cpcc
#        pccpc pcpcc pccpc pcpcc pcpcp ccpcc pcpc
       
# it's already a morphing gfx, morphing it even harder at 29.97

fix2 = FixSlowMoI(138458, 138543, 51500, pd = 0, f = [ \
	[1,3,4,6,7,9,11,13,14,16,18,20,21,23,24,26,28,30,31,33,34,37,38,40,41,43,45,47,48,50,51,53,55,57,58,60,62,64,65,67,68,70,72,74,75,77,78,80,82,84,85], \
	[0,2,4,6,7,9,10,12,14,16,17,19,20,22,24,26,27,29,31,33,34,36,37,39,41,43,44,46,48,50,51,53,54,56,58,60,61,63,64,66,68,70,71,73,75,77,78,80,81,83,85] \
	])

# transport ships flying in

# 10084     c 
#           c 
# 10090 cpccc cpccp ccccp ccpcc ccPcc pcccc pccpc cccPc cpccc Pcccp
#       cccpc cPccc cpccP ccccp ccPcc ccpcc Pcccc pccpc cccpc cpccc
# 10140 cccPc ccpcc cPccc 
#       cpcCp ccccp Ccpcc 

fix3 = FixSlowMoI(10084, 10149, 39800, pd = 0, deint = 5, f = [ \
	[0,1,3,4,5,6,8,9,11,12,13,14,16,17,19,20,21,22,24,25,27,28,29,30,32,33,35,36,37,38,40,41,43,44,45,47,48,49,51,52,53,55,56,57,59,60,61,63,64,65], \
	[0,1,2,3,5,6,8,9,10,11,13,14,16,17,18,19,21,22,24,25,26,27,29,30,32,33,34,35,37,38,40,41,42,43,45,46,48,49,50,51,53,54,56,57,58,59,61,62,64,65], \
	[1] \
	])

# brain #1

# 16192   cpc ccpcc
#         ccc pccpc
# 16200 pccpc ccpcc pccpc ccpcc pccpc ccpcc pccpc ccpcc pccpc ccpcc
#       cpccp cccpc cpccp cccpc cpccp cccpc cpccp cccpc cpccp cccpc
# 16250 p
#       c

fix4 = FixSlowMoI(16192, 16250, 34000, f = [ \
	[0,2,3,4,6,7,9,10,12,13,14,16,17,19,20,22,23,24,26,27,29,30,32,33,34,36,37,39,40,42,43,44,46,47,49,50,52,53,54,56,57], \
	[0,1,2,4,5,7,8,10,11,13,14,15,17,18,20,21,23,24,25,27,28,30,31,33,34,35,37,38,40,41,43,44,45,47,48,50,51,53,54,55,57,58] \
	])

# brain #2

# 19770 cpccc pccpc cpccc pccpc cpccc pccpc cpccc pccpc cpccc pccpc cpc
#       cccpc cpccp ccpcc cpccp ccpcc cpccp ccpcc cpccp ccpcc cpccp ccp
      
fix5 = FixSlowMoI(19770, 19822, 34200, f = [ \
	[0,2,3,4,6,7,9,10,12,13,14,16,17,19,20,22,23,24,26,27,29,30,32,33,34,36,37,39,40,42,43,44,46,47,49,50,52], \
	[0,1,2,4,5,7,8,10,11,13,14,15,17,18,20,21,23,24,25,27,28,30,31,33,34,35,37,38,40,41,43,44,45,47,48,50,51] \
	])
	
# first conveyor belt scene (side sync, amazingly this also makes mid row go in sync)

#fix6 = FixSlowMoI(1094, 1108, 53000, pd = 0, f = [ \
fix6 = FixSlowMoI(1094, 1108, 41500, f = [ \
	[0,2,3,5,7,8,10,12,13], \
	[0,1,3,5,6,8,10,12,13] \
	])

# gigashadow inside #1

# 133733    cc pccpc
#           cc pcccc
# 133740 cpccc pcccp ccpcc pcccp cccpc cpccp cccpc ccpcc pccpc ccpcc
#        pccpc cpccp ccccp ccpcc pccpc cccpc cpccp ccpcc ccpcc pccpc 
# 133790 cpccp ccpcc cpccc pccpc cpccc pcccp ccpcc pccpc cccpc cpccp
#        cpccc cpccp ccpcc pcccp cccpc cpccp cccpc ccpcc pccpc ccpcc
# 133840 ccpcc ccpcc pccpc cpccc cpccp ccpcc pcccc pccpc c
#        cpccp ccpcc cpccc pccpc cpccc pcccp ccpcc pcccp c

fix7 = FixSlowMoI(133733, 133880, 33500, pd = 2, f = [ \
	[0,1,3,4,6,7,9,10,11,13,14,15,17,18,20,21,23,24,25,27,28,29,31,32,34,35,37,38,39,41,42,43,45,46,48,49,51,52,53,55,56,57,59,60,62,63,65,66,67,69,70,71,73,74,76,77,79,80,81,83,84,85,87,88,90,91,93,94,96,97,98,99,101,102,104,105,107,108,110,111,112,113,115,116,118,119,121,122,124,125,126,127,129,130,132,133,135,136,138,139,140,141,143,144,146,147], \
	[0,1,3,4,5,6,8,9,11,12,14,15,17,18,19,20,22,23,25,26,28,29,31,32,33,34,36,37,39,40,42,43,45,46,47,48,50,51,53,54,56,57,59,60,61,62,64,65,67,68,70,71,73,74,75,77,78,79,81,82,84,85,87,88,89,91,92,93,95,96,98,99,101,102,103,105,106,107,109,110,112,113,115,116,117,119,120,121,123,124,126,127,129,130,131,133,134,135,137,138,140,141,143,144,145,147] \
	])
	
# scared Stanley and the shadow

# 151630 cpccc pcccc ppccc cpccc cpccc cpccp ccccp cccpc ccpcc ccpcc
#        ccpcc ccpcc pccpc cccpc cccpc cccpc cpccc cpccp ccccp ccpcc
# 151680 pcccc pccpc cccpc ccpcc cpccc
#        ccpcc ccpcc pcccc pccpc cccpc

fix9 = FixSlowMoI(151630, 151704, 31700, f = [ \
	[0,2,3,4,6,7,8,9,12,13,14,15,17,18,19,20,22,23,24,25,27,28,30,31,32,33,35,36,37,39,40,41,43,44,45,46,48,49,51,52,53,54,56,57,59,60,61,62,64,65,66,68,69,70,72,73,74], \
	[0,1,3,4,5,6,8,9,11,12,14,15,16,17,19,20,21,22,24,25,26,27,29,30,32,33,34,35,37,38,40,41,42,43,45,46,48,49,50,51,53,54,55,56,58,59,61,62,63,64,66,67,69,70,71,72,74] \
	])

# brain #0

# 9831  ccpc cpccc
#       cccp ccpcc
# 9840 pccpc cpccc pccpc cpccc pccpc cpccc pccpc cpccc pccpc cpccc
#      cpccp ccpcc cpccp ccpcc cpccp ccpcc cpccp ccpcc cpccp ccpcc
# 9890 pccpc cpccc pccpc cpccc pccpc cpccc pccpc cpccc pccpc
#      cpccp ccpcc cpccp ccpcc cpccp ccpcc cpccp ccpcc cpccp
#
# pccpc cpccc / cpccp ccpcc repeating
     
fix10 = FixSlowMoI(9831, 9934, 34200, f = [ \
	[0,1,3,4,6,7,8,10,11,13,14,16,17,18,20,21,23,24,26,27,28,30,31,33,34,36,37,38,40,41,43,44,46,47,48,50,51,53,54,56,57,58,60,61,63,64,66,67,68,70,71,73,74,76,77,78,80,81,83,84,86,87,88,90,91,93,94,96,97,98,100,101,103], \
	[0,1,2,4,5,7,8,9,11,12,14,15,17,18,19,21,22,24,25,27,28,29,31,32,34,35,37,38,39,41,42,44,45,47,48,49,51,52,54,55,57,58,59,61,62,64,65,67,68,69,71,72,74,75,77,78,79,81,82,84,85,87,88,89,91,92,94,95,97,98,99,101,102] \
	])

# gigashadow inside #2

# 131657 pcc
#        ccp
# 131660 pccpc cpccp ccpcc pccpc cpccp cpccp ccpcp ccpcc pccpc cpccp
#        ccpcc pcpcc pccpc pccpc cpccp ccpcc pccpc cpccp ccpcp ccpcp
# 131710 ccpcc pccpc cpcpc cpcpc cpccp ccpcc pccpc cpccp ccpcc pcpcc
#        ccpcc pccpc cpccp ccpcc pccpc cpcpc cpccp cpccp ccpcc pccpc
# 131760 pccpc pccpc cpccp ccpcc pccpc cpccp ccpcp ccpcp ccpcc pccpc
#        cpccp ccpcc pccpc pccpc cpcpc cpccp ccpcc pccpc cpccp ccpcp
# 131810 cpccp ccpcc
#        ccpcc pcpcc

fix11 = FixSlowMoI(131657, 131819, 36900, f = [ \
	[1,2,4,5,7,8,10,11,13,14,16,17,19,20,22,23,25,26,28,30,31,33,34,36,38,39,41,42,44,45,47,48,50,51,53,54,56,57,59,60,62,63,65,67,68,70,72,73,75,76,78,79,81,82,84,85,87,88,90,91,93,94,96,97,99,101,102,104,105,107,109,110,112,113,115,116,118,119,121,122,124,125,127,128,130,131,133,134,136,138,139,141,143,144,146,147,149,150,152,153,155,156,158,159,161,162], \
	[0,1,3,4,6,7,9,11,12,14,15,17,19,20,22,23,25,26,28,29,31,32,34,35,37,38,40,41,43,44,46,48,49,51,53,54,56,57,59,60,62,63,65,66,68,69,71,72,74,75,77,78,80,82,83,85,86,88,90,91,93,94,96,97,99,100,102,103,105,106,108,109,111,112,114,115,117,119,120,122,123,125,127,128,130,131,133,134,136,137,139,140,142,143,145,146,148,149,151,153,154,156,157,159,161,162] \
	])

# Zev in the intro (S01E02)

# 6170 ccccp cccpc cpccc cpccp pcpcc ccpcc pcccc pccpc cpccc cpccp
#      ccccc pcccp cccpc cpccc ppccp cccpc ccpcc pcccc pccpc ccpcc
# 6220 cccc
#      cpcc
     
fix12 = FixSlowMoI(3603, 3656, 32800, fin = 7, f = [ \
	[0,1,2,3,5,6,7,9,10,12,13,14,15,17,18,21,23,24,25,26,28,29,31,32,33,34,36,37,39,40,42,43,44,45,47,48,50,51,52,53], \
	[0,1,2,3,4,6,7,8,10,11,12,14,15,17,18,19,22,23,25,26,27,29,30,31,33,34,36,37,38,39,41,42,44,45,46,48,49,50,52,53] \
	])

# His Shadow going up on the column (S01E02)
	
# 8092 012 34567 88002 24567 89012 34566 8801
#      012 34568 89012 34567 89012 44667 8901

# use missing frame interpolation here, because the text looks bad with nnedi3

fix13 = FixSlowMoI(5525, 5556, 30000, pd = 0, deint = 3, f = [ \
	[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,14,16,15,19,19,20,21,23,23,24,25,27,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,46,48,47,50,50,52,51,55,55,56,57,59,59,60,61,62,63], [], \
	[0,2,4,6,8,10,12,15,16,19,20,23,24,27,28,30,32,34,36,38,40,42,44,47,48,51,52,55,56,59,60,62], \
	[0,2,4,6,8,10,12,14,16,19,20,23,24,27,28,30,32,34,36,38,40,42,44,46,48,50,52,55,56,59,60,62] \
	])

# last man standing

# 21157 023 45689 01245 6
#       123 46789 02345 6
      
fix14 = FixSlowMoI(21157, 21170, 30000, pd = 0, f = [ \
	[0,0,1,1,2,3,4,5,6,7,8,8,10,9,11,11,12,13,14,15,16,17,18,18,20,19,21,21,22,23,24,25,26,27], [], \
	[1,3,4,6,8,11,12,15,16,18,20,23,24,27,28,30,32], \
	[0,3,4,6,8,10,12,15,16,18,20,22,24,27,28,30,32] \
	])
	
# looking back behind the shoulder in slow-mo, every frame is just duplicated
# interpolate new ones while keeping the cccpp pattern

fix15 = FixSlowMoI(13908, 14059, pd = 4, deint = 3, fc = 10, f = [ \
	[0, 1, 2, 3, 4, 5, 8, 7], [], \
	[0, 3] \
	])

#return showfields

Trim(0, 1093) + \
fix6 + \
Trim(1109, 3602) + \
fix12 + \
Trim(3657, 5524) + \
fix13 + \
Trim(5557, 9830) + \
fix10 + \
Trim(9935, 10083) + \
fix3 + \
Trim(10150, 13907) + \
fix15 + \
Trim(14060, 16191) + \
fix4 + \
Trim(16251, 19769) + \
fix5 + \
Trim(19823, 20966) + \
Trim(20967, 21097).LeftToVideo(2, 600) + \
Trim(21098, 21131) + \
Trim(21132, 21156).LeftToVideo(1, 600) + \
fix14 + \
Trim(21174, 131656) + \
fix11 + \
Trim(131820, 132526) + \
fix1 + \
Trim(132681, 133732) + \
fix7 + \
Trim(133881, 138457) + \
fix2 + \
Trim(138544, 151629) + \
fix9 + \
Trim(151705, 0)
