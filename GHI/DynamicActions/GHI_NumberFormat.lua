--===================================================
--
--				GHI_NumberFormat
--  			GHI_NumberFormat.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local category = "Number Format";

local NumberToText = {
	--OH lord i just thought about we need to localize all this
	[1] = "One",
	[2] = "Two",
	[3] = "Three",
	[4] = "Four",
	[5] = "Five",
	[6] = "Six",
	[7] = "Seven",
	[8] = "Eight",
	[9] = "Nine",
	[10] = "Ten",
	[11] = "Eleven",
	[12] = "Tweleve",
	[13] = "Thirteen",
	[14] = "Fourteen",
	[15] = "Fifthteen",
	[16] = "Sixteen",
	[17] = "Seventeen",
	[18] = "Eightteen",
	[19] = "Nineteen",
	[20] = "Twenty",
	[22] = "Twenty-One",
	[23] = "Twenty-Two",
	[24] = "Twenty-Three",
	[25] = "Twenty-Five",
	[26] = "Twenty-Six",
	[27] = "Twenty-Seven",
	[28] = "Twenty-Eight",
	[29] = "Twenty-Nine",
	[30] = "Thirty",
	[31] = "Thirty-One",
	[32] = "Thirty-Two",
	[33] = "Thirty-Three",
	[34] = "Thirty-Four",
	[35] = "Thirty-Five",
	[36] = "Thirty-Six",
	[37] = "Thirty-Seven",
	[38] = "Thirty-Eight",
	[39] = "Thirty-Nine",
	[40] = "Fourty",
	[41] = "Fourty-One",
	[42] = "Fourty-Two",
	[43] = "Fourty-Three",
	[44] = "Fourty-Four",
	[45] = "Fourty-Five",
	[46] = "Fourty-Six",
	[47] = "Fourty-Seven",
	[48] = "Fourty-Eight",
	[49] = "Fourty-Nine",
	[50] = "Fithy",
	[51] = "Fithy-One",
	[52] = "Fithy-Two",
	[53] = "Fithy-Three",
	[54] = "Fithy-Four",
	[55] = "Fithy-Five",
	[56] = "Fithy-Six",
	[57] = "Fithy-Seven",
	[58] = "Fithy-Eight",
	[59] = "Fithy-Nine",
	[60] = "Sixty",
	[61] = "Sixty-One",
	[62] = "Sixty-Two",
	[63] = "Sixty-Three",
	[64] = "Sixty-Four",
	[65] = "Sixty-Five",
	[66] = "Sixty-Six",
	[67] = "Sixty-Seven",
	[68] = "Sixty-Eight",
	[69] = "Sixty-Nine",
	[70] = "Seventy",
	[71] = "Seventy-One",
	[72] = "Seventy-Two",
	[73] = "Seventy-Three",
	[74] = "Seventy-Four",
	[75] = "Seventy-Five",
	[76] = "Seventy-Six",
	[77] = "Seventy-Seven",
	[78] = "Seventy-Eight",
	[79] = "Seventy-Nine",
	[80] = "Eighty",
	[81] = "Eighty-One",
	[82] = "Eighty-Two",
	[83] = "Eighty-Three",
	[84] = "Eighty-Four",
	[85] = "Eighty-Five",
	[86] = "Eighty-Six",
	[87] = "Eighty-Seven",
	[88] = "Eighty-Eight",
	[89] = "Eighty-Nine",
	[90] = "Ninety",
	[91] = "Ninety-One",
	[92] = "Ninety-Two",
	[93] = "Ninety-Three",
	[94] = "Ninety-Four",
	[95] = "Ninety-Five",
	[96] = "Ninety-Six",
	[97] = "Ninety-Seven",
	[98] = "Ninety-Eight",
	[99] = "Ninety-Nine",
	[100] = "One-Hundred",
}


table.insert(GHI_ProvidedDynamicActions, {
	name = "Number to Text",
	guid = "num_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Converts a number to text format.",
	icon = "Interface\\Icons\\achievement_guild_level10",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[

        local targetNumber = dyn.GetInput("number")

        if NumberToText[targetNumber] then
         local convertedNum = NumberToText[targetNumber]
         dyn.SetOutput("convertedNum",convertedNum)
         dyn.TriggerOutPort("numberPort")
        end
	]],
	ports = {
		numberPort = {
			name = "number converted",
			order = 1,
			direction = "out",
			description = "when the number is converted",
		},
	},
	inputs = {
		number = {
			name = "number",
			description = "the number to convert",
			type = "number",
			defaultValue = "",
		},
	},
	outputs = {
		convertedNum = {
			name = "Converted Number",
			description = "The number Converted to text",
			type = "string",
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Number to percent",
	guid = "num_02",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Converts a number to percent format.",
	icon = "Interface\\Icons\\achievement_guild_level10",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[

        local targetNumber = dyn.GetInput("number")
        local toPercent = targetNumber/100

         local convertedNum = toPercent
         dyn.SetOutput("convertedNum",convertedNum)
         dyn.TriggerOutPort("numberPort")

	]],
	ports = {
		numberPort = {
			name = "number converted",
			order = 1,
			direction = "out",
			description = "when the number is converted",
		},
	},
	inputs = {
		number = {
			name = "number",
			description = "the number to convert",
			type = "number",
			defaultValue = "",
		},
	},
	outputs = {
		convertedNum = {
			name = "Converted Number",
			description = "The number Converted to percent",
			type = "string",
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Round a Number",
	guid = "num_03",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 1,
	category = category,
	description = "Converts a number to percent format.",
	icon = "Interface\\Icons\\achievement_guild_level10",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[

        local targetNumber = dyn.GetInput("number")
           local rounded = floor(targetNum + .5)

         dyn.SetOutput("roundedNum",rounded)
         dyn.TriggerOutPort("numberPort")

	]],
	ports = {
		numberPort = {
			name = "number converted",
			order = 1,
			direction = "out",
			description = "when the number is converted",
		},
	},
	inputs = {
		number = {
			name = "number",
			description = "the number to convert",
			type = "number",
			defaultValue = "",
		},
	},
	outputs = {
		roundedNum = {
			name = "Rounded Number",
			description = "The number rounded",
			type = "string",
		},
	},
});
