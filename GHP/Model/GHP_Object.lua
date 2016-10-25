--
--
--				GHP_Object
--  			GHP_Object.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

function GHP_Object(info)
	local class = GHP_AuthorInfo(info,"GHP_Object");
	class = GHI_ItemInfo_AdvTooltip(info,class);

	local guid,name,icon,version,rightClickText;
	local abilities,attributes;

	class.GetGuid = function()
		return guid;
	end

	class.GetInfo = function()
		return name,icon;
	end

	class.GetAttributeInfo = function(attName)
		local att = attributes[attName or ""];
		if type(att) == "table" then
			return att.type,att.defaultValue;
		end
	end

	class.GetTooltipLines = function()
		local lines = {}

		table.insert(lines, {
			order = 10,
			text = name,
			r = 1,
			g = 1,
			b = 1,
		});
		table.insert(lines, {
			order = 100,
			text = "Use: "..rightClickText,
			r = ITEM_QUALITY_COLORS[2].r,
			g = ITEM_QUALITY_COLORS[2].g,
			b = ITEM_QUALITY_COLORS[2].b,
		})



		return lines;
	end

	class.GetAbilityInstances = function()
		return abilities;
	end

	class.Execute = function(systemGuid,profGuid,abilityGuid,objInsGuid)
   		for i,abilityIns in pairs(abilities) do
			if abilityIns.GetAbilityGuid() == abilityGuid then
				abilityIns.Execute(systemGuid,profGuid,guid,objInsGuid)
			end
		end
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype, t)
		t = t or {};
		if not (stype) then
			t.guid = guid;
			t.name = name;
			t.icon = icon;
			t.version = version;
			t.rightClickText = rightClickText;
			t.abilities = {};
			for i,ab in pairs(abilities) do
				t.abilities[i] = ab.Serialize();
			end
			t.attributes = attributes;
		end
		if OtherSerialize then
			t = OtherSerialize(stype, t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	guid = info.guid;
	name = info.name;
	icon = info.icon;
	rightClickText = info.rightClickText or "";
	version = info.version or 1;
	attributes = info.attributes or {};

	abilities = {};
	for i,v in pairs(info.abilities or {}) do
		abilities[i] = GHP_AbilityInstance(v);
	end

	return class;
end

