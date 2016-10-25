--
--
--				GHI_ExportItem
--  			GHI_ExportItem.lua
--
--			Export and import of items
--
-- 		(c)2013 The Gryphonheart Team
--			All rights reserved
--

local class;
function GHI_ExportItem()
	if class then
		return class;
	end

	class = GHClass("GHI_ExportItem");
	local loc = GHI_Loc()
	local importExportEnvironment = GHI_ScriptEnviroment();
	importExportEnvironment.SetValue("GHI_MiscData", { Import = GHI_MiscData.Import });
	local itemInfoList = GHI_ItemInfoList();
	local containerList = GHI_ContainerList();
	local crypt = GHI_Crypt(42);
	local packer = GHI_Packer();
	local misc;
	local actionAPI = GHI_ActionAPI().GetAPI();

	class.GenerateExportCode = function(itemGuid, amount, scriptBefore, req, scriptAfter, containerGuid, containerSlot)
		amount = tonumber(amount) or 1;
		local item = itemInfoList.GetItemInfo(itemGuid);
		if not (type(item) == "table" and item.Inherits("GHI_ItemInfo_Basic")) then
			return format(loc.CAN_NOT_FIND_ITEM, itemGuid or "nil");
		end

		if not (item.IsCreatedByPlayer() or item.IsCopyable()) then
			return loc.CAN_NOT_EXPORT;
		end
		local exportGuid = GHI_GUID();
		local t = {
			["!first"] = "exported",
			["amount"] = amount,
			["ID"] = itemGuid,
			["item"] = item.Serialize(),
			["exportID"] = exportGuid,
			["scriptBefore"] = scriptBefore,
			["scriptAfter"] = scriptAfter,
			["realm"] = GetRealmName(),
		};

		-- Depending items
		local stack;
		if containerGuid and containerSlot then
			stack = containerList.GetStack(containerGuid,containerSlot);
		end

		local dependingGuids = item.GetDependingItems(stack);
		t.dependingItems = {};
		if dependingGuids ~= nil then
			for _,guid in pairs(dependingGuids) do
				local dItem = itemInfoList.GetItemInfo(guid)
				table.insert(t.dependingItems,dItem.Serialize());
			end
		end

		local s = packer.TableToString(t);
		local e = crypt.Encrypt(s);

		local c = 0;
		while string.find(e, "%]%]") or string.find(e, "%[%[") do
			t["!first"..c] = "Exporting";
			s = packer.TableToString(t);
			e = crypt.Encrypt(s);
			c = c + 1;
			if c > 20 then
				break;
			end
		end
		
		local r = crypt.Decrypt(e);
		if s == "" or not (s) then
			return "Export error. Packing failed";
		elseif e == "" or not (e) then
			return "Export error. Encryption failed";
		elseif r == "" or not (r) then
			return "Export error. Validation decryption failed";
		end
		if not (s == r) then
			return "Export error. Encryption and decryption did not match.";
		end
		local q = packer.StringToTable(r);
		if #(q) == 1 then
			return q[1];
		end

		return e;
	end

	class.ImportItemFromExportCode = function(code)
		if not (misc) then
			misc = GHI_MiscAPI().GetAPI()
		end
		local s = crypt.Decrypt(code);
		local t = packer.StringToTable(s);
		if not (type(t) == "table") then
			GHI_Message(loc.CAN_NOT_IMPORT);
			return;
		elseif (#(t) == 1) then
			GHI_Message(loc.CAN_NOT_IMPORT);
			GHI_Message(t[1]);
			return;
		end

		-- before
		importExportEnvironment.SetValue("IMPORT_REQ", false);
		importExportEnvironment.SetValue("G_Import", t);
		importExportEnvironment.ExecuteScript(t["scriptBefore"]);
		t = importExportEnvironment.GetValue("G_Import");

		-- req
		if not (importExportEnvironment.GetValue("IMPORT_REQ") == true) then
			GHI_Message(loc.CAN_NOT_IMPORT);
			return;
		end


		local realm = t["realm"];

		local itemData = t["item"];

		-- realm check
		if not (realm == GetRealmName()) then
			itemData.creater = itemData.creater .. " - " .. realm;
		end
		t.item = itemData;

		-- after
		importExportEnvironment.SetValue("G_Import", t);
		importExportEnvironment.ExecuteScript(t["scriptAfter"]);
		t = importExportEnvironment.GetValue("G_Import");

		local itemGuid = t["ID"];
		local amount = t["amount"];
		t.item.guid = itemGuid;
		local item = GHI_ItemInfo(t["item"]);
		realm = t["realm"];

		-- version check
		itemInfoList.UpdateItem(item);

		-- depending items
		for _,dItemData in pairs(t.dependingItems or {}) do
			local dItem = GHI_ItemInfo(dItemData);
			itemInfoList.UpdateItem(dItem);
		end

		-- insert item
		containerList.InsertItemInMainBag(item.GetGUID(), amount);
		GHI_Message(format(loc.IMPORT_REPORT, amount, misc.GHI_GenerateLink(itemGuid)));

		-- update import save data
		local misc = importExportEnvironment.GetValue("GHI_MiscData");
		GHI_MiscData.Import = misc.Import;
	end

	return class;
end

