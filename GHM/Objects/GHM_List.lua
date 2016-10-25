--
--
--				GHM_List
--  			GHM_List.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local count = 1;
function GHM_List(profile, parent, settings)
	local f = CreateFrame("Frame", "GHM_List" .. count, parent, "GHM_List_Template");
	count = count + 1;

	f.data = {};
	
	local fontStringNote
	if profile.note then
		if not(fontStringNote) then
			fontStringNote = f:CreateFontString(nil,"BACKGROUND")
			fontStringNote:SetPoint("BOTTOM",f,"BOTTOM",0,10)
			fontStringNote:SetSize(fontStringNote:GetStringWidth(),fontStringNote:GetStringHeight())
			fontStringNote:SetFont("Fonts\\FRIZQT__.TTF",14)
			fontStringNote:SetJustifyH("CENTER")
			fontStringNote:SetJustifyV("MIDDLE")
			fontStringNote:SetTextColor(0.5,0.5,0.5,1)
			fontStringNote:SetText(profile.note)
			fontStringNote:SetWordWrap(true)
			fontStringNote:Show()
		else
			fontStringNote:SetText(profile.note)
			fontStringNote:Show()
		end
	end
	
	f.HideNote = function()
		fontStringNote:Hide()
	end
	
	f.ShowNote = function()
		fontStringNote:Show()
	end
	
	f.SetUpList = function(lines, column)
		if not (lines) or not (column) then
			return 0;
		end
		f.offset = 0;
		f.lines = lines;
		local lineHeight = 21;
		f.lineHeight = lineHeight;
		local fname = f:GetName();
		local firstHeader = nil;
		local lastHeader = nil;
		local totalWidth = 0;
		local xoff = 0;
		local numColumns = #(column);
		f.numColumns = numColumns;
		for i = 1, numColumns do
			local w = column[i].width;
			if not (w) then
				w = 30;
				column[i].width = w;
			end
			totalWidth = totalWidth + w;
		end

		for i = 1, numColumns do
			local w = column[i].width;
			local Type = column[i].type;

			local header = CreateFrame("Button", fname .. "_H" .. i, f, "GHM_Header_Template");
			header:SetWidth(w);
			_G[header:GetName() .. "Middle"]:SetWidth(w - 7);
			header:SetText(column[i].catagory);
			header.label = column[i].label;

			if lastHeader then
				header:SetPoint("TOPLEFT", lastHeader, "TOPRIGHT", 0, 0);
			else
				header:SetPoint("TOPLEFT", f, "TOPLEFT", 5, -5);
			end

			header:SetScript("OnClick", function()
				PlaySound("igMainMenuOptionCheckBoxOn");
				local f = header:GetParent();
				if f.sortFilter == header.label then
					f.sortDir = mod(f.sortDir + 1, 2);
				else
					f.sortDir = 0;
				end
				f.sortFilter = header.label;
				f.UpdateAll();
			end);

			header:Show();
			if i == 1 then
				firstHeader = header;
			end
			lastHeader = header;
			local lastObject = nil;
			for j = 1, lines do
				if i == 1 then
					local line = CreateFrame("Button", fname .. "_L" .. j, f);
					line:SetHeight(lineHeight);
					line:SetWidth(totalWidth);
					line.num = j;
					line:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
					line:SetPoint("TOPLEFT", header, "TOPLEFT", 0, lineHeight * (-(j - 1)) - 24);
					line:Show();
					line:SetScript("OnClick", function()
						local f = line:GetParent();
						f.SetMarked(line.num + f.offset);
						if f.OnMarked then
							f.OnMarked(line.num + f.offset);
						end
					end);
					line.Type = Type;
					if profile.onDoubleClick then
						line:SetScript("OnDoubleClick", function()
						local f = line:GetParent();
						f.SetMarked(line.num + f.offset);
						if f.OnMarked then
							f.OnMarked(line.num + f.offset);
						end
						profile.onDoubleClick()
						end)
					end
				end
				if Type == "Text" then
					local obj = CreateFrame("Frame", fname .. "_L" .. j .. "_H" .. i, _G[fname .. "_L" .. j], "GHM_Text_Template");
					obj:SetWidth(w)
					obj:SetHeight(lineHeight);
					obj:SetPoint("LEFT", obj:GetParent(), "LEFT", xoff+5, 0);
					local label = _G[obj:GetName() .. "Label"];
					label:SetFontObject(GHM_GameFontSmall);
					label:SetJustifyH("LEFT")
					label:SetTextColor(1, 1, 1);
					local p = label:GetFont();
					--label:SetFont(p,11);

					obj.Force = function(t)
						label:SetText(t);
					end
					label:SetPoint("BOTTOMRIGHT")
					obj.Type = Type;
				elseif Type == "Icon" then
					local obj = CreateFrame("Frame", fname .. "_L" .. j .. "_H" .. i, _G[fname .. "_L" .. j]);
					obj:SetHeight(lineHeight);
					obj:SetWidth(lineHeight);
					obj:SetPoint("LEFT", obj:GetParent(), "LEFT", xoff, 0);
					obj.texture = obj:CreateTexture()
					obj.texture:SetAllPoints(obj)
					obj.texture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
					obj.Force = function(data)
						if type(data) == "string" then
							obj.texture:SetTexture(data);
						else
							obj.texture:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
						end
					end
					obj:Show();
					obj.Type = Type;
				elseif Type == "IconRow" then
					local obj = CreateFrame("Frame", fname .. "_L" .. j .. "_H" .. i, _G[fname .. "_L" .. j]);
					local size = column[i].size or lineHeight;
					obj:SetHeight(size);
					obj:SetWidth(w);
					local max = math.floor(w/size);
					obj:SetPoint("LEFT", obj:GetParent(), "LEFT", xoff, 0);
					obj.textures = {};

					for i=1,max do
						local b = CreateFrame("Button",nil,obj);
						b:SetHeight(size);
						b:SetWidth(size);

						if i==1 then
							b:SetPoint("LEFT",obj,"LEFT");
						else
							b:SetPoint("LEFT",obj.textures[i-1],"RIGHT");
						end

						local t = b:CreateTexture()
						b.t = t;
						t:SetAllPoints(b);
						t:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark");
						b:Hide();

						b:SetScript("OnEnter", function()
							if b.tooltip then
								GameTooltip:SetOwner(b, "ANCHOR_RIGHT");
								GameTooltip:ClearLines()
								GameTooltip:AddLine(b.tooltip, 1, 0.8196079, 0);
								GameTooltip:Show()
							end
						end);
						obj:SetScript("OnLeave", function(self)
							GameTooltip:Hide();
						end);

						obj.textures[i] = b;
					end

					obj.Force = function(data)
						if type(data) == "table" then
							for i=1,max do
								local b = obj.textures[i];
								if data[i] then
									b.t:SetTexture(data[i].texture);
									b.tooltip = data[i].tooltip;
									b:Show();
								else
									b:Hide();
								end
							end
						end
					end
					obj:Show();
					obj.Type = Type;
				elseif Type == "CycleButton" then
					local obj = CreateFrame("Button", fname .. "_L" .. j .. "_H" .. i, _G[fname .. "_L" .. j], "GameMenuButtonTemplate");
					obj:SetHeight(lineHeight);
					obj:SetWidth(w);
					obj:SetPoint("LEFT", obj:GetParent(), "LEFT", xoff, 0);
					obj:SetText("");
					--obj:SetTextColor(1,1,1);
					obj.cycles = column[i].cycles;
					--obj:SetFont("Fonts\\FRIZQT__.TTF",10);
					obj.label = column[i].label;
					obj.Force = function(data)
						if type(data) == "number" then
							obj:SetText(obj.cycles[data]);
							obj:Show();
						else
							obj:Hide();
						end
					end;
					obj:SetScript("OnClick", function()
						local id = obj.id;
						local f = obj:GetParent():GetParent();
						if type(obj.cycles) == "table" and type(id) == "number" then
							local tuble = f.GetTuble(id);
							local num = tuble[obj.label];
							if type(num) == "number" then
								num = num + 1;
								if num > #(obj.cycles) then
									num = 1;
								end
								tuble[obj.label] = num;
								f.SetTuble(id, tuble);
							end
						end
					end);
					obj:Show();
					obj.Type = Type;
				elseif Type == "CheckButton" then
					local obj = CreateFrame("CheckButton", fname .. "_L" .. j .. "_H" .. i, _G[fname .. "_L" .. j], "OptionsCheckButtonTemplate");
					obj:SetHeight(min(w, lineHeight));
					obj:SetWidth(min(w, lineHeight));
					obj:SetPoint("LEFT", obj:GetParent(), "LEFT", xoff, 0);
					obj:SetChecked(nil);

					obj:SetHitRectInsets(0, 0, 0, 0)

					obj.label = column[i].label;
					obj.Force = function(data)
						obj:SetChecked(data);
					end;

					obj:SetScript("OnClick", function()
						local id = obj.id;
						local f = obj:GetParent():GetParent();
						if type(id) == "number" then
							local tuble = f.GetTuble(id);

							tuble[obj.label] = obj:GetChecked() and true;
							f.SetTuble(id, tuble);
						end
					end);
					obj.Type = Type;
				elseif Type == "CustomButton" then
					local obj = CreateFrame("Button", fname .. "_L" .. j .. "_H" .. i, _G[fname .. "_L" .. j],"GHM_Button_Template");
					obj:SetHeight(min(w, lineHeight));
					obj:SetWidth(column[i].width);
					obj:SetPoint("LEFT", obj:GetParent(), "LEFT", xoff, 0);

					if column[i].normalTexture then
						local t1 = obj:CreateTexture();
						t1:SetTexture(column[i].normalTexture);
						t1:SetAllPoints(obj);
						t1:SetTexCoord(unpack(column[i].normalTexCoords));
						obj:SetNormalTexture(t1); --]]
						obj:SetBackdrop(nil);
						obj.UpdateTheme = function() end
					end

					if column[i].pushedTexture then
						obj:SetPushedTexture("");
						local t2 = obj:CreateTexture();
						t2:SetTexture(column[i].pushedTexture);
						t2:SetAllPoints(obj);
						t2:SetTexCoord(unpack(column[i].pushedTexCoords));
						obj:SetPushedTexture(t2);   --]]
						obj.UpdateTheme = function() end
					end

					local gotDisabled = false;
					if column[i].disabledTexture then
						gotDisabled = true;
						obj:SetDisabledTexture("");
						local t2 = obj:CreateTexture();
						t2:SetTexture(column[i].disabledTexture);
						t2:SetAllPoints(obj);
						t2:SetTexCoord(unpack(column[i].disabledTexCoords));
						obj:SetDisabledTexture(t2);   --]]
						obj.UpdateTheme = function() end
					end

					obj.label = column[i].label;
					local label = _G[obj:GetName() .. "Text"];

					obj:SetScript("OnClick", function()
						local f = column[i].onClick;
						if f then
							local id = obj.id;
							local list = obj:GetParent():GetParent();
							local tuble = list.GetTuble(id);
							f(tuble);
						end
					end);
					obj.Force = function(v)
						if column[i].hideOnNil then
							if not (v) then
								obj:Hide();
							else
								obj:Show();
							end
						elseif column[i].disableOnNil then
							if not(v) then
								obj:Disable();
							else
								obj:Enable();
							end
						else
							obj:SetText(v);
						end
					end
					obj:SetScript("OnEnter", function()
						if column[i].tooltip then
							GameTooltip:SetOwner(obj, "ANCHOR_RIGHT");
							GameTooltip:ClearLines()
							GameTooltip:AddLine(column[i].tooltip, 1, 0.8196079, 0);
							GameTooltip:Show()
						end
					end);
					obj:SetScript("OnLeave", function(self)
						GameTooltip:Hide();
					end);
					obj.Type = Type;
				end

			end
			xoff = xoff + w;
		end

		f:SetHeight(lineHeight * lines + lastHeader:GetHeight() + 9);
		f:SetWidth(totalWidth + 27);
		if lastHeader then -- header above scroll bar
			local scroll = CreateFrame("ScrollFrame", fname .. "_Scroll", f, "GHM_ListScrollBar_Template");
			f.scroll = scroll;
			scroll:SetHeight(lineHeight * lines);
			scroll:SetWidth(totalWidth);
			local header = CreateFrame("Button", fname .. "_H" .. numColumns + 1, f, "GHM_Header_Template");
			local w = 16;
			header:SetWidth(w);
			_G[header:GetName() .. "Middle"]:SetWidth(w - 7);
			header:SetPoint("TOPLEFT", lastHeader, "TOPRIGHT", 0, 0);

			scroll:SetPoint("TOPRIGHT", header, "BOTTOMLEFT", -4, 0);
			scroll:Show();
			header:Show();

			scroll:SetScript("OnShow", function()
			--GHI_Message("f.lines is "..f.lines);
				local f = scroll:GetParent();
				--FauxScrollFrame_Update(scroll,f.lastSize,f.lines,f.lineHeight); --f.lines
				f.offset = math.min(FauxScrollFrame_GetOffset(scroll), f.lastSize - lines);
				f.UpdateAll();
			end);
		end


		return f:GetHeight();
	end;

	f.UpdateAll = function()
	--	O(n^2)
		if f.locked == true then return end;
		local Sort = f.sortFilter; -- name of the catagories or nil (i f nil th en sort by x)
		local dir = f.sortDir;
		local sortedData = f.data;
		--  syntax =  data[x][label]
		if Sort and type(sortedData) == "table" then
			for j = 2, #(sortedData) do
				local key = sortedData[j];
				local i = j - 1;


				if type(key[Sort]) == "boolean" or key[Sort] == nil then
					break;
					--[[
					if dir == 1 then

						while i > 0 and key[Sort] == sortedData[i][Sort] do
							sortedData[i+1] = sortedData[i];
							i = i - 1;
						end
					else
						while i > 0 and (key[Sort] == sortedData[i][Sort]) do
							sortedData[i+1] = sortedData[i];
							i = i - 1;
						end
					end--]]
					-- todo: gives problems with markings because it is not concequent
				else
					local strbyte = function(...) return strbyte(...) or 0; end
					if dir == 1 then
						while i > 0 and key[Sort] and not(type(key[Sort])=="table") and (not (sortedData[i][Sort]) or strbyte(strlower(sortedData[i][Sort])) < strbyte(strlower(key[Sort])) or (strbyte(strlower(sortedData[i][Sort])) == strbyte(strlower(key[Sort])) and strbyte(strlower(sortedData[i][Sort]), 2) < strbyte(strlower(key[Sort]), 2))) do
							sortedData[i + 1] = sortedData[i];
							i = i - 1;
						end
					else
						while i > 0 and key[Sort] and not(type(key[Sort])=="table") and (not (sortedData[i][Sort]) or strbyte(strlower(sortedData[i][Sort])) > strbyte(strlower(key[Sort])) or (strbyte(strlower(sortedData[i][Sort])) == strbyte(strlower(key[Sort])) and strbyte(strlower(sortedData[i][Sort]), 2) > strbyte(strlower(key[Sort]), 2))) do
							sortedData[i + 1] = sortedData[i];
							i = i - 1;
						end
					end
				end


				sortedData[i + 1] = key;
			end
		end

		f.data = sortedData;

		local offset = f.offset;
		if not (offset) then
			offset = 0;
		end
		local lines = f.lines;
		--- Show data.

		for i = 1, f.numColumns do
			local f1 = _G[f:GetName() .. "_H" .. i];

			for j = 1, lines do
				local k = j + offset;
				local f2 = _G[f:GetName() .. "_L" .. j .. "_H" .. i];
				if type(sortedData) == "table" and type(sortedData[k]) == "table" then
					local d = sortedData[k][f1.label];

					if f2 then
						f2.Force(d);
						f2.id = k;
					end
					local line = _G[f:GetName() .. "_L" .. j]
					line:Show();
					if sortedData[k].marked == true then
						line:LockHighlight()
					else
						line:UnlockHighlight()
					end
				else
					_G[f:GetName() .. "_L" .. j]:Hide();
				end
			end
		end

		if type(sortedData) == "table" and not (f.lastSize == #(sortedData)) then
			FauxScrollFrame_Update(f.scroll, #(sortedData), f.lines, f.lineHeight - 5);
			f.lastSize = #(sortedData);
		end
	end

	f.Force = function(t)
		if type(t) == "table" then
			f.data = t;

			f.UpdateAll()
		end
	end

	f.Clear = function()

		f.data = {};

		f.UpdateAll()
	end


	f.GetTuble = function(number)
		if type(f.data[number]) == "table" then
			return f.data[number];
		else
			return;
		end
	end

	local value;
	f.GetValue = function()
		return value;
	end

	f.SetTuble = function(number, tuble)
		if type(number) == "number" and type(tuble) == "table" then

			f.data[number] = tuble;
			f.UpdateAll()
			value = f.data;
		end
	end

	f.GetTubleCount = function()
		return #(f.data);
	end

	f.DeleteTuble = function(number)
		if f.locked == true then return end;
		table.remove(f.data, number);
		f.UpdateAll()
		f.main.SetLabel(f.label, f.data);
	end

	f.InsertTuble = function(tuble)
		table.insert(f.data, tuble);
		f.UpdateAll()
		main.SetLabel(f.label, f.data);
	end

	f.GetMarked = function()
		for i = 1, #(f.data) do
			if type(f.data[i]) == "table" then
				if f.data[i].marked == true then
					return i;
				end
			end
		end
	end

	f.SetMarked = function(num)
		for i = 1, #(f.data) do
			if type(f.data[i]) == "table" then
				if i == num then
					f.data[i].marked = true;
				else
					f.data[i].marked = false;
				end
			end
		end
		f.UpdateAll()
		if type(f.onclick) == "function" then
			f.onclick(f, num)
		end
	end
	
	-- positioning
	local extraX = profile.xOff or 0;
	local extraY = profile.yOff or 0;

	if profile.align == "c" then
		f:SetPoint("CENTER", parent, "CENTER", extraX, extraY);
	elseif profile.align == "r" then
		f:SetPoint("RIGHT", parent.lastRight or parent, "RIGHT", extraX, extraY);
		parent.lastRight = f;
	else
		f:SetPoint("LEFT", parent.lastLeft or parent, "LEFT", extraX, extraY);
		parent.lastLeft = f;
	end

	height = f.SetUpList(profile.lines, profile.column)
	f.onclick = profile.onclick;
	f.OnMarked = profile.OnMarked;
	f.UpdateAll();

	f:Show();
	return f;
end

