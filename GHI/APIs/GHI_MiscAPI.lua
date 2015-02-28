--===================================================
--
--				GHI_MiscAPI
--				GHI_MiscAPI.lua
--
--	API offering misc functions for the environment
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;

function GHI_MiscAPI()
	if class then
		return class;
	end
	class = GHClass("GHI_MiscAPI");

	local cursor = GHI_CursorHandler();
	local api = {};
	local itemInfo = GHI_ItemInfoList()
	local containerList = GHI_ContainerList();
	local loc = GHI_Loc();

	local links = GHI_LinksUI("GHItem", itemInfo.RetrieveItemUpdate, itemInfo.DisplayItemLink)

	api.GHI_GetTimeString = function(secs)
		GHCheck("GHI_GetTimeString",{"number"},{secs})
		if secs == 1 then
			return secs .. " " .. loc.SEC;
		end
		if secs < 60 then
			return secs .. " " .. loc.SECS;
		end
		local mins = floor(secs / 60);
		if mins == 1 then
			return mins .. " " .. loc.MIN;
		end
		if mins < 60 then
			return mins .. " " .. loc.MINS;
		end
		local hours = floor(mins / 60);
		if hours == 1 then
			return hours .. " " .. loc.HOUR;
		end
		if hours < 24 then
			return hours .. " " .. loc.HOURS;
		end
		local days = floor(hours / 24);
		if days == 1 then
			return days .. " " .. loc.DAY;
		end
		return days .. " " .. loc.DAYS;
	end

	api.GHI_GetPreciseTimeString = function(secs)
		local m = floor(secs / 60)
		local s = mod(secs, 60);
		if s < 10 then
			s = "0" .. s;
		else
			s = "" .. s;
		end
		return string.format("(%i:%s)", m, s);
	end

	api.GHI_GenerateLink = function(guid,containerGuid,slotID)


		if containerGuid and slotID then
			local stack = containerList.GetStack(containerGuid,slotID)
			if stack then
				local item = stack.GetItemInfo();

				local text, _, quality = item.GetItemInfo();
				local guid = item.GetGUID();

				local color = {
					r = ITEM_QUALITY_COLORS[quality].r,
					g = ITEM_QUALITY_COLORS[quality].g,
					b = ITEM_QUALITY_COLORS[quality].b,
				};

				local lines = {};
				stack.DisplayItemTooltip({
					AddLine = function(_,text, r, g, b, _, order)
						if not(order == 60 or order == 70 or order == 80 or order == 75 or order == 85) then
							table.insert(lines,{
								text = text,
								r = r,
								g = g,
								b = b,
								order = order,
							})
						end
					end,
					ClearLines = function() end,
					Show = function() end,
				});

				return links.GenerateLink(text, guid, color, lines);
			end
		end

		local item = itemInfo.GetItemInfo(guid);
		if item then
			local text, _, quality = item.GetItemInfo();
			local guid = item.GetGUID();

			local color = {
				r = ITEM_QUALITY_COLORS[quality].r,
				g = ITEM_QUALITY_COLORS[quality].g,
				b = ITEM_QUALITY_COLORS[quality].b,
			};
			return links.GenerateLink(text, guid, color);
		end

		return "[Unknown]";
	end



	api.GHI_ColorString = function(s, r, g, b)
		if not (s) or s == "" then return ""; end;
		if not (r) or not (g) or not (b) then return ""; end;
		return "|C" .. api.RGBAPercToHex(r,g,b,1) .. s .. "|r";
	end

	api.GHI_SetSelectItemCursor = function(clickFunction, clearFunction, identifier)
		local modClickFunction = function(guid,frame)
			cursor.ClearCursorWithoutFeedback();
			if clickFunction then
				clickFunction(guid,frame);
			end
		end
		cursor.SetCursor("CAST_CURSOR", nil, clearFunction, nil, "SELECT_GHI_ITEM", modClickFunction, identifier);
	end

	api.GHI_GetCurrentCursor = function()
		local info = { cursor.GetCursor() }
		for i, v in pairs(info) do
			if type(v) == "table" and v.GetType and v.IsClass then
				info[i] = "GHI Class: " .. v.GetType();
			end
		end
		return unpack(info);
	end

	api.GHI_SetCursor = function(...)
		cursor.SetCursor(...);
	end

	api.GHI_ClearCursor = function()
		cursor.ClearCursor();
	end

	api.strsubutf8 = function(str, a, b) -- modified from http://wowprogramming.com/snippets/UTF-8_aware_stringsub_7
		assert(type(str) == "string" and type(a) == "number", "incorrect input strsubutf8");
		assert(not (b) or (type(b) == "number" and b <= strlenutf8(str)), "end pos larger than string lenght", b, strlenutf8(str));

		b = (b or strlenutf8(str));

		local start, _end = #str + 1, #str + 1;
		local currentIndex = 1
		local numChars = 0;
		if a <= 1 then
			start = a;
		end
		if b <= 1 then
			_end = b;
		end

		while currentIndex <= #str do
			local char = string.byte(str, currentIndex)
			if char > 240 then
				currentIndex = currentIndex + 4
			elseif char > 225 then
				currentIndex = currentIndex + 3
			elseif char > 192 then
				currentIndex = currentIndex + 2
			else
				currentIndex = currentIndex + 1
			end

			numChars = numChars + 1;

			if numChars == a - 1 then
				start = currentIndex;
			end
			if numChars == b then
				_end = currentIndex - 1;
			end
		end
		return str:sub(start, _end)
	end

	api.strfindutf8 = function(str, ptrn)
		local a, b = strfind(str, ptrn);
		if a then
			local v1 = strlenutf8(strsub(str, 0, a - 1));
			return v1, v1 + strlenutf8(strsub(str, a - 1, b));
		end
		return;
	end

	api.RGBAPercToHex = function(r, g, b, a)
		if not(a) then a = 1 end
		r = r <= 1 and r >= 0 and r or 0
		g = g <= 1 and g >= 0 and g or 0
		b = b <= 1 and b >= 0 and b or 0
		a = a <= 1 and a >= 0 and a or 1
		
		return string.format("%02x%02x%02x%02x",a*255 ,r*255, g*255, b*255)
	end
	
	api.HexToRGBAPerc = function(hex)
		if strlen(hex) == 6 then
			local rhex, ghex, bhex = string.sub(hex, 1,2), string.sub(hex, 3, 4), string.sub(hex, 5, 6)
			return tonumber(rhex, 16)/255, tonumber(ghex, 16)/255, tonumber(bhex, 16)/255, 1
		else
			local ahex, rhex, ghex, bhex = string.sub(hex, 1,2), string.sub(hex, 3, 4), string.sub(hex, 5, 6), string.sub(hex, 7, 8)
			return tonumber(rhex, 16)/255, tonumber(ghex, 16)/255, tonumber(bhex, 16)/255, tonumber(ahex, 16)/255
		end
	end
	
	local colors = {
		red = { r = 1, g = 0.0, b = 0.0 },
		white = { r = 1, g = 1, b = 1 },
		yellow = { r = 1, g = 1, b = 0.0 },
		gold = { r = 0.5, g = 0.5, b = 0.0 },
		green = { r = 0.0, g = 1, b = 0.0 },
		green2 = { r = 0.0, g = 0.5, b = 0.0 },
		blue = { r = 0.0, g = 0.0, b = 1 },
		blue2 = { r = 0.0, g = 0.0, b = 0.5 },
		purple = { r = 0.5, g = 0.0, b = 0.5 },
		teal = { r = 0.0, g = 0.5, b = 0.5 },
		orange = { r = 0.8, g = 0.4, b = 0.0 },
		Lgreen = { r = 0.4, g = 0.8, b = 0.0 },
		Lblue = { r = 0.0, g = 0.4, b = 0.8 },
		Dgreen = { r = 0.0, g = 0.8, b = 0.4 },
		Pink = { r = 0.8, g = 0.0, b = 0.4 },
		Dblue = { r = 0.4, g = 0.0, b = 0.8 },
		brown = { r = 0.5, g = 0.0, b = 0.0 },
		gray = { r = 0.5, g = 0.5, b = 0.5 },
		black = { r = 0, g = 0, b = 0 },
	}
		
	api.GHI_GetColors = function()
		return colors;
	end
	
	api.GHI_GetFonts = function()
		return GHI_FontList
	end
	
	api.GHI_Pronoun = function(tense, upper, tar)
		if tar == nil then
			tar = "player"
		elseif tar == true then
			tar = "target"
		end
		local word
		local gen = UnitSex(tar)

		local l = {
			{nom = loc.PRONOUN_IT, pos = loc.PRONOUN_ITS},
			{nom = loc.PRONOUN_HE, pos = loc.PRONOUN_HIS},
			{nom = loc.PRONOUN_SHE, pos = loc.PRONOUN_HER},
		}
		if upper == true then
			if tense == "nom" then
				word = l[gen].nom
				word = word:gsub("^%l", string.upper)
				return word
			elseif tense == "pos" then
				word = l[gen].pos
				word = word:gsub("^%l", string.upper)
				return word
			end
		else
			if tense == "nom" then
				word = l[gen].nom
				return word
			elseif tense == "pos" then
				word = l[gen].pos
				return word
			end
		end
	end

	local urlMenuList;
	api.GHI_URL = function(url)
		if not(urlMenuList) then
			urlMenuList = GHI_MenuList("GHI_URLUI");
		end
		urlMenuList.New(url);
	end

	-- GetPlayedTime
	local requestTime;
	local startPlayedTime;
	local orig = ChatFrame_DisplayTimePlayed;
	ChatFrame_DisplayTimePlayed = function(self, totalTime, ...)
		if requestTime == true then
			requestTime = false;
			startPlayedTime = GetTime() - totalTime;
			return;
		end
		return orig(self, totalTime, ...)
	end

	requestTime = true;
	GHI_Timer(RequestTimePlayed,2,true);

	api.GHI_GetTotalPlayedTime = function()
		if startPlayedTime then
			return GetTime() - startPlayedTime;
		end
	end

	-- save / load
	api.GHI_Save = function(index, var)
		if not (type(GHI_MiscData.ScriptSave) == "table") then
			GHI_MiscData.ScriptSave = {};
		end
		GHI_MiscData.ScriptSave[index] = var;
	end
	api.GHI_Load = function(index)
		return (GHI_MiscData.ScriptSave or {})[index];
	end

	-- bindings
	local bindings = {};
	local bindingCount = 1;
	local RunBinding = function(key)
		if bindings[key] then
			for i,v in pairs(bindings[key]) do
				v(key);
			end
		end
	end

	api.GHI_SetKeyBinding = function(key,func)
		if (GetBindingAction(key) or ""):len() == 0 then
			if not(bindings[key]) then
				bindings[key] = {};
				local f = CreateFrame("CheckButton", "GHI_Binding_"..bindingCount);
				f:SetScript("OnClick", function(b) RunBinding(key) end);
				SetOverrideBinding(f,false,key,"CLICK GHI_Binding_"..bindingCount..":LeftButton");
				bindingCount = bindingCount + 1;
			end
			table.insert(bindings[key],func)
		else
			print("Could not set key",key,". Already in use.")
		end
	end
	
	
	api.GHI_GetMountsByAlpha = function()
		local mounts = {}
		
		if not (IsAddOnLoaded("Blizzard_PetJournal")) then
			LoadAddOn("Blizzard_PetJournal")
		end
		
		for i=1,C_MountJournal.GetNumMounts() do
		--local _, mountName, mountSpellId, icon, _, mountType = GetCompanionInfo("mount",i)
			local mountName, mountSpellID, icon,_, _,_,_,_,_,_, isCollected = C_MountJournal.GetMountInfo(i)
			local firstLetter = strsub(mountName,1,1)
			local info = {}
			if isCollected == true then
				if not(mounts[firstLetter]) then
					mounts[firstLetter] = {}
					mounts[firstLetter].text = firstLetter
					mounts[firstLetter].notCheckable = true
					mounts[firstLetter].hasArrow = true
					mounts[firstLetter].menuList = {}
				end
			end
			
			info.text = mountName
			info.value = i
			info.index = i
			info.icon = icon
			info.notCheckable = true
			
			tinsert(mounts[firstLetter].menuList, info)
		end
		
		local tempMounts = {}
		local a = {}
		for n,_ in pairs(mounts) do
			table.insert(a, n)
		end

		table.sort(a)
		for i = 1, #a do
			if a[i] == nil then
				return nil
			else
				local k = a[i]
				table.insert(tempMounts, mounts[k])
			end
		end
		
		return tempMounts
	end
	
		
	api.GHI_GetDebuffColor = function(debuffType)
		return api.RGBAPercToHex(DebuffTypeColor[debuffType].r, DebuffTypeColor[debuffType].g, DebuffTypeColor[debuffType].b, 1)
	end
	class.GetAPI = function()
		local a = {};
		for i, f in pairs(api) do
			a[i] = f;
		end
		return a;
	end

	return class;
end

