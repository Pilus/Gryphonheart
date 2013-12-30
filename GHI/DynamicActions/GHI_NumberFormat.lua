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

local to_19 = { "zero",  "one",   "two",  "three", "four",   "five",   "six",
        "seven", "eight", "nine", "ten",   "eleven", "twelve", "thirteen",
        "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen" };
local  tens  = { "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"};
local  denom = { "",
	"thousand",     "million",         "billion",       "trillion",       "quadrillion",
	"quintillion",  "sextillion",      "septillion",    "octillion",      "nonillion",
	"decillion",    "undecillion",     "duodecillion",  "tredecillion",   "quattuordecillion",
	"sexdecillion", "septendecillion", "octodecillion", "novemdecillion", "vigintillion" };

local convert_nn = function(val)
	if (val < 20) then
		return to_19[val+1];
	end
	for v = 0,#(tens)-1 do
		local dcap = tens[v+1];
		local dval = 20 + 10 * v;
		if (dval + 10 > val) then
			if not(mod(val,10) == 0) then
				return dcap .. "-" .. to_19[mod(val,10)+1];
			else
				return dcap;
			end
		end
	end
end

local convert_nnn = function(val)
	local word = "";
	local rem = math.floor(val / 100);
	local modVal = math.floor(mod(val, 100));
	if (rem > 0) then
		word = to_19[math.floor(rem)+1] .. " hundred";
		if (modVal > 0) then
			word = word .. " and ";
		end
	end
	if (modVal > 0) then
		word = word .. convert_nn(modVal);
	end
	return word;
end

NumbersToWords = function(val)
	val = math.floor(val);
	if (val < 100) then
		return convert_nn(val);
	end
	if (val < 1000) then
		return convert_nnn(val);
	end
	for v = 0, #(denom)-1 do
		local didx = v - 1;
		local dval = math.pow(1000, v);
		if (dval > val) then
			local mod = math.pow(1000, didx);
			local l = math.floor(val / mod);
			local r = val - (l * mod);
			local ret = convert_nnn(l) .. " " .. denom[didx+1];
			if (r > 0) then
				ret = ret .. ", " .. NumbersToWords(r);
			end
			return ret;
		end
	end
end

table.insert(GHI_ProvidedDynamicActions, {
	name = "Number to Words",
	guid = "num_01",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 2,
	category = category,
	description = "Converts a number to text format.",
	icon = "Interface\\Icons\\achievement_guild_level10",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
		local targetNumber = dyn.GetInput("number")
		local convertedNum = NumbersToWords(targetNumber)
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
	version = 2,
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
			type = "number",
		},
	},
});

table.insert(GHI_ProvidedDynamicActions, {
	name = "Round a Number",
	guid = "num_03",
	authorName = "The Gryphonheart Team",
	authorGuid = "00x1",
	version = 2,
	category = category,
	description = "Converts a number to percent format.",
	icon = "Interface\\Icons\\achievement_guild_level10",
	gotOnSetupPort = false,
	setupOnlyOnce = false,
	script =
	[[
		local targetNumber = dyn.GetInput("number")
		local rounded = floor(targetNumber + .5)

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
			type = "number",
		},
	},
});
