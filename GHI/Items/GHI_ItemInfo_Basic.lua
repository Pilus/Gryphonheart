--===================================================
--
--				GHI_ItemInfo_Basic
--  			GHI_ItemInfo_Basic.lua
--
--	Holds the basic information for all item typess
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local loc = GHI_Loc();

GHI_ITEM_TYPE_NAME = { loc.ITEMTYPE_CUSTOM_MADE, loc.ITEMTYPE_CONTRIBUTE, loc.ITEMTYPE_OLD, loc.ITEMTYPE_OFFICAL };
GHI_ITEM_TYPE_COLOR = { { r = 0.0, g = 0.7, b = 0.5 }, { r = .5, g = 0.0, b = 0.5 }, { r = 0.0, g = 0.7, b = 0.5 }, { r = 0.7, g = 0, b = 0 } };

function GHI_ItemInfo_Basic(info)
	local class = GHClass("GHI_ItemInfo_Basic");
	GHInheritNext("GHI_ItemInfo_Version",class);
	GHI_ItemInfo_Version(info);
	GHInheritNext("GHI_ItemInfo_Access",class);
	GHI_ItemInfo_Access(info);
	GHInheritNext("GHI_ItemInfo_Cooldown",class);
	GHI_ItemInfo_Cooldown(info);

	-- Declaration and default values
	local comment = "";
	local guid = "";
	local itemType = 1;
	local name = "";
	local quality = 1;
	local stackSize = 1;
	local useText = "";
	local white1 = "";
	local white2 = "";
	local icon = "Interface\\Icons\\INV_Misc_QuestionMark";
	local consumed = false;

	local misc = GHI_MiscAPI().GetAPI();

	-- Public functions
	class.DisplayItemTooltip = function(tooltipFrame)
		local lines = class.GetTooltipLines();
		tooltipFrame:ClearLines();
		for _, line in pairs(lines) do
			tooltipFrame:AddLine(line.text, line.r, line.g, line.b, true);
		end

		tooltipFrame:Show();
	end

	class.GenerateStack = function(amount,position)
		local stackInfo = {};
		stackInfo.attributeValues = {};
		stackInfo.guid = guid;
		stackInfo.amount = amount or stackSize;
		stackInfo.position = position;

		return GHI_Stack(nil, stackInfo, nil, class);
	end

	class.GetColoredItemTypeText = function()
		return misc.GHI_ColorString(GHI_ITEM_TYPE_NAME[itemType], GHI_ITEM_TYPE_COLOR[itemType].r, GHI_ITEM_TYPE_COLOR[itemType].g, GHI_ITEM_TYPE_COLOR[itemType].b);
	end

	class.GetFlavorText = function()
		return white1, white2, comment, useText;
	end

	class.GetGUID = function()
		return guid;
	end

	class.GetItemInfo = function()
		return name, icon, quality, stackSize, itemType;
	end

	class.GetTooltipLines = function(stack)
		local lines = {};

		table.insert(lines, {
			order = 10,
			text = name,
			r = ITEM_QUALITY_COLORS[quality].r,
			g = ITEM_QUALITY_COLORS[quality].g,
			b = ITEM_QUALITY_COLORS[quality].b,
		});

		if (white1:len() > 0) then
			table.insert(lines, {
				order = 20,
				text = white1,
				r = 1,
				g = 1,
				b = 1,
			});
		end

		if (white2:len() > 0) then
			table.insert(lines, {
				order = 30,
				text = white2,
				r = 1,
				g = 1,
				b = 1,
			});
		end

		if (comment:len() > 0) then
			table.insert(lines, {
				order = 40,
				text = "\"" .. comment .. "\"",
				r = 1,
				g = 0.8196079,
				b = 0,
			});
		end

		if (string.len(useText) > 0) then
			table.insert(lines, {
				order = 50,
				text = loc.USE .. " " .. useText,
				r = ITEM_QUALITY_COLORS[2].r,
				g = ITEM_QUALITY_COLORS[2].g,
				b = ITEM_QUALITY_COLORS[2].b,
			});
		end


		local cd,elapsed = (stack or class).GetCooldown();
		if (elapsed and elapsed < cd) then
			table.insert(lines, {
				order = 60,
				text = string.format("%s %s", loc.CD_LEFT, misc.GHI_GetTimeString(cd - elapsed));
				r = 1,
				g = 1,
				b = 1,
			});
		end

		local _,authorName = class.GetAuthorInfo();
		table.insert(lines, {
			order = 70,
			text = string.format("<%s %s>", loc.MADE_BY, authorName);
			r = ITEM_QUALITY_COLORS[2].r,
			g = ITEM_QUALITY_COLORS[2].g,
			b = ITEM_QUALITY_COLORS[2].b,
		});

		if class.GetItemComplexity() == "advanced" and not(GHI_MiscData["hide_mod_att_tooltip"]) and #(class.GetAllAttributes()) > 0 then
			local _,authorName = class.GetAuthorInfo();
			table.insert(lines, {
				order = 75,
				text = loc.VIEW_ATTRIBUTE_SHORTCUT;
				r = 0.0,
				g = 0.6,
				b = 0.9,
			});
		end

		table.insert(lines, {
			order = 80,
			text = GHI_ITEM_TYPE_NAME[itemType],
			r = GHI_ITEM_TYPE_COLOR[itemType].r,
			g = GHI_ITEM_TYPE_COLOR[itemType].g,
			b = GHI_ITEM_TYPE_COLOR[itemType].b,
		});

		local transferTime = class.GetItemDataArrivalTime();
		if not(transferTime) then
			local depending = class.GetDependingItems();
			local itemList = GHI_ItemInfoList();
			for _,guid in pairs(depending) do
				local item = itemList.GetItemInfo(guid);
				if item then
					local t = item.GetItemDataArrivalTime();
					if t then
						if not(transferTime) then
							transferTime = t;
						else
							transferTime = math.max(transferTime,t);
						end
					end
				end
			end
		end

		if transferTime then
			local str = "Transfering data: %s left";
			if transferTime < 60 then
				str = string.format(str,"Less than 1 min");
			else
				str = string.format(str,SecondsToTime(transferTime,true));
			end
			table.insert(lines, {
				order = 85,
				text = str,
				r = 1.0,
				g = 0.1,
				b = 0.1,
			});
		end

		return lines;
	end

	class.IsConsumed = function()
		return consumed;
	end

	class.SetComment = function(_comment)
		comment = _comment;
	end

	class.SetConsumed = function(_consume)
		consumed = _consume;
	end

	class.SetIcon = function(_icon)
		icon = _icon;
	end

	class.SetName = function(_name)
		name = _name;
	end

	class.SetQuality = function(_quality)
		quality = _quality;
	end

	class.SetUseText = function(_use)
		useText = _use;
	end

	class.SetStackSize = function(_stackSize)
		stackSize = _stackSize;
	end

	class.GetStackSize = function()
		return stackSize;
	end

	class.SetWhite1 = function(_white1)
		white1 = _white1;
	end

	class.SetWhite2 = function(_white2)
		white2 = _white2;
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype,t)
		t = t or {};
		if not(stype) or stype == "link" or stype == "toAdvanced"  then
			t.guid = guid;
			t.name = name;
			t.itemType = itemType;
			t.quality = quality;
			t.white1 = white1;
			t.white2 = white2;
			t.comment = comment;
			t.icon = icon;
			t.rightClicktext = useText;
			t.stackSize = stackSize;
			t.consumed = consumed;
		end

		if OtherSerialize then
			t = OtherSerialize(stype,t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	guid = info.guid or GHI_GUID().MakeGUID();
	name = info.name or name;
	itemType = info.itemType or itemType;
	quality = info.quality or quality;
	white1 = info.white1 or white1;
	white2 = info.white2 or white2;
	comment = info.comment or comment;
	icon = info.icon or icon;
	useText = info.rightClicktext or useText;
	stackSize = info.stackSize or stackSize;
	consumed = info.consumed or consumed;

	return class;
end

