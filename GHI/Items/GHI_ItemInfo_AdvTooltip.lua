--===================================================
--
--				GHI_ItemInfo_AdvTooltip
--  			GHI_ItemInfo_AdvTooltip.lua
--
--	Holds dynamic tooltip information for advanced itemss
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_ItemInfo_AdvTooltip(info,inheritObject)
	local class = inheritObject or GHClass("GHI_ItemInfo_AdvTooltip");

	-- Declaration and default values
	local tooltipLines = {};
	local misc = GHI_MiscAPI().GetAPI();
    local loc = GHI_Loc();


	-- Public functions
	class.AddTooltip = function(name, sequence, align, order)
		table.insert(tooltipLines, {
			sequence = sequence,
			name = name,
			align = align,
			alignLoc = ((align == "left") and loc.LEFT) or loc.RIGHT,
			order = order or 30,
			down = true,
			up = true,
			edit = true,
			delete = true,
		});

		if not (order) then
			class.LowerTooltip(sequence);
		end
	end

	class.GetTooltipListInfo = function()
		local t = {
			{ order = 10, name = loc.ATTRI_NAME, align = "left", detail = "Default", alignLoc = loc.LEFT, },
			{ order = 20, name = loc.WHITE_TEXT_1, align = "left", detail = "Default", alignLoc = loc.LEFT, },
			{ order = 30, name = loc.WHITE_TEXT_2, align = "left", detail = "Default", alignLoc = loc.LEFT, },
			{ order = 40, name = loc.YELLOW_QUOTE, align = "left", detail = "Default", alignLoc = loc.LEFT, },
			{ order = 50, name = loc.USE, align = "left", detail = "Default", alignLoc = loc.LEFT, },
			{ order = 60, name = loc.ITEM_CD, align = "left", detail = "Default", alignLoc = loc.LEFT, },
			{ order = 70, name = loc.MADE_BY, align = "left", detail = "Default", alignLoc = loc.LEFT, },
			{ order = 80, name = loc.TYPE_U, align = "left", detail = "Default", alignLoc = loc.LEFT, },
		};
		local GRAY = 0.5;
		for i, line in pairs(t) do
			line.name = misc.GHI_ColorString(line.name, GRAY, GRAY, GRAY);
			line.detail = misc.GHI_ColorString(line.detail, GRAY, GRAY, GRAY);
			line.alignLoc = misc.GHI_ColorString(line.alignLoc, GRAY, GRAY, GRAY);
		end
		for i, line in pairs(tooltipLines) do
			local inserted = false;
			for j, line2 in pairs(t) do
				if line.order < line2.order then
					line.detail = "";
					table.insert(t, j, line);
					inserted = true;
					break;
				elseif line.order == line2.order then
					if line.align == line2.align then
						line.detail = string.format(loc.TT_OVERWRITE, line2.name);
					else
						line.detail = string.format(loc.TT_NEXT_TO, line2.name);
					end
					table.insert(t, j, line);
					inserted = true;
					break;
				end
			end
			if inserted == false then
				table.insert(t, line);
			end
		end
		return t;
	end

	class.RemoveTooltip = function(sequence)
		for i, seq in pairs(tooltipLines) do
			if seq.sequence == sequence then
				table.remove(tooltipLines, i);
			end
		end
	end

	class.RaiseTooltip = function(sequence)
		local lines = class.GetTooltipListInfo();
		for i, line in pairs(lines) do
			if line.sequence == sequence then
				local aboveLine = lines[i - 1];
				local belowLine = lines[i + 1];
				if aboveLine then
					if (belowLine and belowLine.order == line.order) or (aboveLine.order == line.order or aboveLine.order == 70 or aboveLine.order == 80 or (aboveLine.order >= 120 and aboveLine.order <= 130)) then
						-- move between belowLine and aboveLine
						local j = 1;
						while (aboveLine and (aboveLine.order == line.order or aboveLine.order == 70 or aboveLine.order == 80 or (aboveLine.order >= 120 and aboveLine.order <= 130))) do
							j = j + 1;
							aboveLine = lines[i - (j)];
						end
						if aboveLine then
							local diff = (lines[i - (j) + 1].order - aboveLine.order);
							if diff >= 2 then
								line.order = aboveLine.order + math.floor(diff / 2);
							else
								line.order = aboveLine.order + (diff / 2);
							end
						else
							local firstOrder = lines[i - (j) + 1].order;
							if firstOrder >= 2 then
								line.order = math.floor(firstOrder / 2);
							else
								line.order = (firstOrder / 2);
							end
							line.up = nil;
						end
					else
						-- move to aboveLine
						line.order = aboveLine.order;
					end
				elseif belowLine.order == line.order then
					if line.order >= 2 then
						line.order = math.floor(line.order / 2);
					else
						line.order = (line.order / 2);
					end
					line.up = nil;
				end

				line.down = true;
				break;
			end
		end
	end

	class.LowerTooltip = function(sequence)
		local lines = class.GetTooltipListInfo();
		for i, line in pairs(lines) do
			if line.sequence == sequence then
				local aboveLine = lines[i - 1];
				local belowLine = lines[i + 1];
				if belowLine then
					if (aboveLine and aboveLine.order == line.order) or (belowLine.order == line.order or belowLine.order == 70 or belowLine.order == 80 or (belowLine.order >= 120 and belowLine.order <= 130)) then
						-- move between belowLine and aboveLine
						local j = 1;
						while (belowLine and (belowLine.order == line.order or belowLine.order == 70 or belowLine.order == 80 or (belowLine.order >= 120 and belowLine.order <= 130))) do
							j = j + 1;
							belowLine = lines[i + (j)];
						end
						if belowLine then
							local diff = (lines[i + (j) - 1].order - belowLine.order);
							if diff >= 2 then
								line.order = belowLine.order + math.floor(diff / 2);
							else
								line.order = belowLine.order + (diff / 2);
							end
						else
							local lastOrder = lines[i + (j) - 1].order;
							if lastOrder >= 110 and lastOrder <= 130 then
								line.order = 135;
							else
								line.order = lastOrder + 10;
							end
							line.down = nil;
						end
					else
						-- move to belowLine
						line.order = belowLine.order;
					end
				elseif aboveLine.order == line.order then
					if line.order >= 2 then
						line.order = math.floor(line.order / 2);
					else
						line.order = (line.order / 2);
					end
					line.down = nil;
				end

				line.up = true;
				break;
			end
		end
	end

	class.GetAllCustomTooltips = function()
		return tooltipLines;
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype,t)
		t = t or {};
		if not(stype) or stype == "link" then

		end
		if not(stype) or stype == "action" or stype == "oldAction" then
			t.attributeTooltipLines = {};
			for i, line in pairs(tooltipLines) do
				if line.sequence then
					t.attributeTooltipLines[i] = {
						name = line.name,
						order = line.order,
						align = line.align,
						sequence = line.sequence.Serialize(),
					};
				end
			end
		end

		if OtherSerialize then
			t = OtherSerialize(stype,t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	if info.attributeTooltipLines then
		for i, line in pairs(info.attributeTooltipLines) do
			tooltipLines[i] = {
				name = line.name,
				align = line.align,
				order = line.order,
				alignLoc = ((line.align == "left") and loc.LEFT) or loc.RIGHT,
				down = true,
				up = true,
				edit = true,
				delete = true,
			};
			local sequence = GHI_DynamicActionInstanceSet(class, "OnTooltipUpdate")
			sequence.SetIsUpdateSequence(true);
			sequence.Deserialize(line.sequence);
			tooltipLines[i].sequence = sequence;
		end

		local lines = class.GetTooltipListInfo();

		if tooltipLines[1] and lines[1].sequence == tooltipLines[1].sequence then
			tooltipLines[1].up = false;
		end
		if tooltipLines[#(tooltipLines)] and lines[#(lines)].sequence == tooltipLines[#(tooltipLines)].sequence then
			tooltipLines[#(tooltipLines)].down = false;
		end
	end

	return class;
end

