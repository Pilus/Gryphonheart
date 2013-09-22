--===================================================
--
--				GHI_DOC_KeySet
--  			GHI_DOC_KeySet.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local keySets = {
	['US'] = {
	 	name = "United States",
		['`']= {
			shift = '`',
		},
		['1']= {
			shift = '!',
		},
		['2']= {
			shift = '@',
		},
		['3']= {
			shift = '#',
		},
		['4']= {
			shift = '$',
		},
		['5']= {
			shift = '%',
		},
		['6']= {
			shift = '^',
		},
		['7']= {
			shift = '&',
		},
		['8']= {
			shift = '*',
		},
		['9']= {
			shift = '(',
		},
		['0']= {
			shift = ')',
		},
		['-']= {
			shift = '_',
		},
		['=']= {
			shift = '+',
		},
		['[']= {
			shift = '{',
		},
		["]"]= {
			shift = '}',
		},
		[';']= {
			shift = ':',
		},
		["'"]= {
			shift = '"',
		},
		['\\']= {
			shift = '|',
		},
		[',']= {
			shift = '<',
		},
		['.']= {
			shift = '>',
		},
		['/']= {
			shift = '?',
		},
	},
	['DK'] = {
	 	name = "Danish",
		['½']= {
			shift = '§',
		},
		['1']= {
			shift = '!',
		},
		['2']= {
			shift = '"',
			altGr = '@',
		},
		['3']= {
			shift = '#',
			altGr = '£',
		},
		['4']= {
			shift = '¤',
			altGr = '$',
		},
		['5']= {
			shift = '%',
			altGr = '€',
		},
		['6']= {
			shift = '&',
		},
		['7']= {
			shift = '/',
			altGr = '{',
		},
		['8']= {
			shift = '(',
			altGr = '[',
		},
		['9']= {
			shift = ')',
			altGr = ']',
		},
		['0']= {
			shift = '=',
			altGr = '}',
		},
		['+']= {
			shift = '?',
		},
		['´']= {
			shift = '`',
			altGr = '|',
		},
		['¨']= {
			shift = '^',
			altGr = '~',
		},
		["'"]= {
			shift = '*',
		},
		['-']= {
			shift = '_',
		},
		['.']= {
			shift = ':',
		},
		[',']= {
			shift = ';',
		},
		['e']= {
			shift = 'E',
			altGr = '€',
		},
		['m']= {
			shift = 'M',
			altGr = 'µ',
		},
		['<']= {
			shift = '>',
			altGr = '\\',
		},
	},

};

local class;
function GHI_DOC_KeySet()
	if class then
		return class;
	end
	class = GHClass("GHI_DOC_KeySet");

	local currentSet = keySets.DK;

	if false then -- Set this to 'true' to test on a US keyboard
		currentSet = keySets.US;
	end

	class.LoadSet = function(setGuid)
		if keySets[setGuid] then
			currentSet = keySets[setGuid];
		end
	end

	class.GetKey = function(val)
		if currentSet[val] then
			if IsShiftKeyDown() then
				return currentSet[val].shift;
			elseif IsAltKeyDown() then
				return currentSet[val].altGr;
			end
		end
	end

	return class;
end

