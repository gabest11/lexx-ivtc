Import("../../common.avsi")

LoadEpisodeWithAlt("S04E03", 80785, \
	["..\..\S04(Koch)\V01\title_t02.d2v"], \
	["..\..\S04(Acorn)\D02\title_t00.d2v"])

#return showfields(false)

# 790 on the computer and Longbore

# 20175 pcpcc pcccc pcpcc pcccc pcpcc pcccc pcpcc pcccc pcpcc pcccc
#       cpccp cpccc cpccp cpccc cpccp cpccc cpccp cpccc cpccp cpccc
# 20225 pcpcc pcccc pcpcc pcccc pcpcc pcccc pcpcc pcccc pcpcc pcccc
#       cpccp cpccc cpccp cpccc cpccp cpccc cpccp cpccc cpccp cpccc
# 20275 pcpcc pcccc pcpcc pcccc pcpcc
#       cpccp cpccc cpccp cpccc cpccp

# there is also something else wrong here, the fields are shaking, can be seen on the glass or keyboard

#fix1 = FixSlowMoI(20175, 20299, 34600, pd = 3, f = [ \
fix1 = FixSlowMoI(20175, 20299, 43500, pd = 0, f = [ \
	[1,3,4,6,7,8,9,11,13,14,16,17,18,19,21,23,24,26,27,28,29,31,33,34,36,37,38,39,41,43,44,46,47,48,49,51,53,54,56,57,58,59,61,63,64,66,67,68,69,71,73,74,76,77,78,79,81,83,84,86,87,88,89,91,93,94,96,97,98,99,101,103,104,106,107,108,109,111,113,114,116,117,118,119,121,123,124], \
	[0,2,3,5,7,8,9,10,12,13,15,17,18,19,20,22,23,25,27,28,29,30,32,33,35,37,38,39,40,42,43,45,47,48,49,50,52,53,55,57,58,59,60,62,63,65,67,68,69,70,72,73,75,77,78,79,80,82,83,85,87,88,89,90,92,93,95,97,98,99,100,102,103,105,107,108,109,110,112,113,115,117,118,119,120,122,123] \
	])

fix1 = Trim(20175, 20299).Overlay(fix1.Crop(492, 0, 720 - 492, 480 - 0), 492, 0)

# Xev on the web page, pp bad

function FixP4XdotCOM(clip c, int s, int e, int i)
{
	Trim(c, s, e)
	Overlay(FixPPVideo(c, s, e, i).Crop(200, 106, 536 - 200, 368 - 106), 200, 106)
}

Trim(0, 20174) + \
fix1 + \
Trim(20300, 48249) + \
FixPP(48250, 48373, 3) + \
Trim(48374, 49542) + \
FixP4XdotCOM(49543, 49692, 3) + \
Trim(49693, 49924) + \
FixP4XdotCOM(49925, 49982, 4) + \
Trim(49983, 50420) + \
FixP4XdotCOM(50421, 50754, 5) + \
Trim(50755, 50968) + \
FixPP(50969, 51101, 1) + \
Trim(51102, 51453) + \
FixP4XdotCOM(51454, 51741, 3) + \
Trim(51742, 0)


#FixPP(49543, 49692, 3) + \
