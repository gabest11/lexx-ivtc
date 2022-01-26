Import("../../common.avsi")

LoadEpisodeWithAlt("S04E09", 83200, \
	["..\..\S04(Koch)\V03\title_t00.d2v"], \
	["..\..\S04(Acorn)\D05\title_t00.d2v"])
	
Trim(0, 5233) + \
Trim(5234, 5286).BlendFields + \
Trim(5287, 5374).BlendFieldsWithText(210, 372, 508, 432) + \
Trim(5375, 5436).BlendFields + \
Trim(5437, 5524).BlendFieldsWithText(184, 372, 534, 432) + \
Trim(5525, 5593).BlendFields + \
Trim(5594, 5681).BlendFieldsWithText(236, 372, 486, 432) + \
Trim(5682, 5740).BlendFields + \
Trim(5741, 5828).BlendFieldsWithText(142, 372, 574, 432) + \
Trim(5829, 5954).BlendFields + \
Trim(5955, 6042).BlendFieldsWithText(186, 376, 534, 432) + \
Trim(6043, 6092).BlendFields + \
Trim(6093, 6180).BlendFieldsWithText(148, 370, 570, 432) + \
Trim(6181, 6248).BlendFields + \
Trim(6249, 6336).BlendFieldsWithText(148, 368, 566, 432) + \
Trim(6337, 6451).BlendFields + \
Trim(6452, 0)
