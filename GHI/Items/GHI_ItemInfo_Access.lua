--===================================================
--
--				GHI_ItemInfo_Access
--  			GHI_ItemInfo_Access.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHI_ItemInfo_Access(info)
	local class = GHClass("GHI_ItemInfo_Access");

	-- Declaration and default values
	local authorGuid = "";
	local authorName = "";
	local copyableByOthers = false;
	local editableByOthers = false;

	-- Public functions
	class.CanCopy = function()
		return class.IsCreatedByPlayer() or class.IsCopyable();
	end

	class.GetAuthorInfo = function()
		return authorGuid, authorName;
	end

	class.IsCopyable = function()
		return copyableByOthers;
	end

	class.IsCreatedByPlayer = function()
		return (authorGuid == UnitGUID("player")) or (authorGuid == UnitName("player"));
	end

	class.IsCreatedByUser = function(otherGuid)
		return authorGuid == otherGuid;
	end

	class.IsEditable = function()
		return editableByOthers;
	end

	class.SetCopyable = function(copy)
		copyableByOthers = copy;
	end

	class.SetEditable = function(edit)
		editableByOthers = edit;
	end

	-- Serialization
	local OtherSerialize = class.Serialize;
	class.Serialize = function(stype,t)
		t = t or {};
		if not(stype) or stype == "link" or stype == "toAdvanced" then
			t.authorName = authorName;
			t.creater = authorName; -- For downgrade compatibility
			t.authorGuid = authorGuid;

			t.copyable = copyableByOthers;
			t.editable = editableByOthers;
		end
		if OtherSerialize then
			t = OtherSerialize(stype,t)
		end
		return t;
	end

	-- Initialize
	info = info or {};
	authorName = info.authorName or info.creater or authorName;
	authorGuid =  (strlen(info.authorGuid or '') > 0 and info.authorGuid) or info.creater or authorGuid;
	if info.copyable == true or info.copyable == 1 then
		copyableByOthers = true;
	else
		copyableByOthers = false;
	end
	if info.editable == true or info.editable == 1 then
		editableByOthers = true;
	else
		editableByOthers = false;
	end

	return class;
end

