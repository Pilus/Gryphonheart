--
--
--				GHP_ObjectSpawner
--  			GHP_ObjectSpawner.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

function GHP_ObjectSpawner(info,offlineTime)
	local class = GHClass("GHP_ObjectSpawner");

	local guid,name,objects;
	local respawnInterval,maxSize,sizeRespawnAmount,resourceRespawnAmount,offlineRespawnModifer;


	class.GetGuid = function()
		return guid;
	end

	class.GotPersonalData = function()
	 	for i,obj in pairs(objects or {}) do
			if obj.GotPersonalData() then
				return true;
			end
		end
		return false;
	end

	class.SetPersonalData = function(data)
		for _,subdata in pairs(data.objects) do
			for _,obj in pairs(objects ) do
	            if obj.GetGuid() == subdata.guid then
					obj.SetPersonalData(subdata);
					break;
				end
			end
		end
	end

	local IncreaseValue = function(value,increment)
		local incrementWhole = math.floor(increment);
		local incrementChance = increment-incrementWhole;
		local extra = 0;
		if math.random(100) <= incrementChance*100 then
			extra = 1;
		end
		return value+incrementWhole+extra;
	end

	local UpdateFunc = function(modifier)
		modifier = modifier or 1;
		for _,obj in pairs(objects or {}) do
			-- update size
			local currentSize = obj.GetAttributeValue("size")
			if currentSize and currentSize < maxSize then
				obj.SetAttributeValue("size",math.min(maxSize,
					IncreaseValue(currentSize,sizeRespawnAmount * modifier)
				));

				obj.SetAttributeValue("resources",IncreaseValue(obj.GetAttributeValue("resources"),resourceRespawnAmount * modifier))
			end
		end
	end

	class.Activate = function()
		for _,obj in pairs(objects ) do
			obj.Activate();
		end
	end

	class.Deactivate = function()
		for _,obj in pairs(objects ) do
			obj.Deactivate();
		end
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype, t)
		t = t or {};
		if not(stype) or stype == "nonpersonal" then
			t.name = name;
			t.respawnInterval = respawnInterval;
			t.maxSize = maxSize;
			t.sizeRespawnAmount = sizeRespawnAmount;
			t.resourceRespawnAmount = resourceRespawnAmount;
			t.offlineRespawnModifer = offlineRespawnModifer;
		end
		t.guid = guid;

		t.objects = {};
		for _,o in pairs(objects) do
			table.insert(t.objects,o.Serialize(stype));
		end

		if OtherSerialize then
			t = OtherSerialize(stype, t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	name = info.name;
	guid = info.guid;
	respawnInterval = info.respawnInterval or 1;
	maxSize = info.maxSize or 0;
	sizeRespawnAmount = info.sizeRespawnAmount or 0;  -- points pr interval
	resourceRespawnAmount = info.resourceRespawnAmount or 0;
	offlineRespawnModifer = info.offlineRespawnModifer or 0;

	objects = {};
	for _,v in pairs(info.objects or {}) do
		table.insert(objects,GHP_ObjectInstance(v));
	end

	GHI_Timer(function()
		GHI_Timer(function() UpdateFunc(respawnInterval) end ,respawnInterval);
		UpdateFunc((offlineTime or 0)*offlineRespawnModifer);
	end,1,true);
	return class;
end

