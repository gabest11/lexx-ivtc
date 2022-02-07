Import("../../common.avsi")

title = ReplaceStr(ScriptFile(), ".avs", "")

LoadEpisodeWithAlt("S03E08", 86060, \
	["..\..\S03(Alliance)\V03\title_t00.d2v", -15], \
	["..\..\S03(Acorn)\V03\title_t00.d2v"], \
	["..\..\S03(Acorn)\D04\title_t00.d2v"])

#return detect240p
	
# denoise single field sections

Fix240p(title)

# Better quality of this scene from S03E11

c = last

fix1 = Trim(21130, 21378)

try
{
	tmp = fix1.Trim(0, -20)

	fix1 = Import("S03E11.avs").Trim(58397, 58625)

	# it's mirrored
	
	fix1 = fix1.FlipHorizontal

	# ... and has a different brighness level, this is as close I can get it
	
	fix1 = fix1.ConvertBits(16).Levels(4208, 1, 57020, 0, 65536).ConvertBits(8, dither=1)

	# ... and starts later
	
	fix1 = tmp + fix1

	# ... and has more noise, just denoise both
	
#	fix1 = fix1.Degrain
}
catch(msg)
{
	last # clip undefined if the script ends here
}

last = c

#

Trim(0, 3628) + \
Trim(3629, 3658).BlendFields + \
Trim(3659, 3746).BlendFieldsWithText(248, 348, 472, 432) + \
Trim(3747, 3794).BlendFields + \
Trim(3795, 3882).BlendFieldsWithText(238, 374, 492, 430) + \
Trim(3883, 3940).BlendFields + \
Trim(3941, 4027).BlendFieldsWithText(156, 372, 562, 432) + \
Trim(4028, 4042).BlendFields + \
Trim(4043, 4132).BlendFieldsWithText(148, 368, 566, 430) + \
Trim(4133, 4235) + \
Trim(4236, 4324).BlendFieldsWithText(154, 370, 562, 430) + \
Trim(4325, 4345).BlendFields + \
Trim(4346, 4433).BlendFieldsWithText(206, 370, 512, 430) + \
Trim(4434, 4474).BlendFields + \
Trim(4475, 4579) + \
Trim(4580, 4593).BlendFields + \
Trim(4594, 4681).BlendFieldsWithText(210, 368, 502, 428) + \
Trim(4682, 4695).BlendFields + \
Trim(4696, 4782).BlendFieldsWithText(200, 366, 522, 430) + \
Trim(4783, 5056) + \
Trim(5057, 5087).BlendFields + \
Trim(5088, 5175).BlendFieldsWithText(230, 364, 490, 428) + \
Trim(5176, 6106).BlendFields + \
Trim(6107, 21129) + \
fix1 + \
Trim(21379, 0)
