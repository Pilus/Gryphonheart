--===================================================
--
--				GHI_ClassAPI
--  			GHI_ClassAPI.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHI_ClassAPI()
	if class then
		return class;
	end
	class = GHClass("GHI_ClassAPI");

	local api = {};

	api.GHI_Timer = GHI_Timer;
	--syntax GHI_Timer(func, interval, onceOnly) function must be a declared, not existing. interval is number, onceOnly is boolean if nil, repeats.
	api.GHI_Comm = function()
		local obj = {};
		local comm = GHI_Comm();
		obj.AddRecieveFunc = comm.AddRecieveFunc;
		obj.Send = comm.Send;
		obj.GetQueueSize = comm.GetQueueSize;
		return obj;
	end
	
	api.GHI_GroupComm = function(channel)
		local obj = {};
		local Gcomm = GHI_GroupComm(channel);
		obj.AddRecFunc = Gcomm.AddRecFunc;
		obj.Send = Gcomm.Send;
		obj.GetQueueSize = Gcomm.GetQueueSize;
		return obj;
	end
	
	api.GHI_Position = function()
		local obj = {};
		local pos = GHI_Position();

		obj.GetCoor = pos.GetCoor;
		-- Syntax: obj.GetCoor(unit, deciPlace) returns string of coordinates.
		obj.GetPlayerPos = pos.GetPlayerPos;
		--  Syntax obj.GetPlayerPos(deciPlace) returns table {x = number, y = number, world = number(1 = Azeroth, 2 = Outland) all 0 for dungeons}
		obj.IsPosWithinRange = pos.IsPosWithinRange;
		-- Syntax obj.IsPosWithinRange(positon,range), position = table {x,y,world} range = number returns boolean

		obj.OnNextMoveCallback = pos.OnNextMoveCallback;

		return obj;
	end
	api.GHI_SlashCmd = GHI_SlashCmd;
	--syntax obj = GHI_SlashCmd(mainSlashPrefix)
	-- returns obj.SetDefaultFunc(func) func = Function, obj.RegisterSubPrefix(subPrefix, func) subPrefix = String, func = Function, 
	api.GHI_ChannelComm = function()
		local obj = {};
		local comm = GHI_ChannelComm();
		obj.AddRecieveFunc = comm.AddRecieveFunc;
		obj.Send = comm.Send;
		return obj;
	end

	api.GHI_Event = function(event,func)
		GHI_Event(event,func);
	end

	api.GHI_GUID = function()
	
		local GUID = GHI_GUID()
		local obj = {};
		obj.MakeGUID = GUID.MakeGUID;
	     return obj;
	end

	api.GHI_CastBarUI = function()
		local castBar = GHI_CastBarUI();
		local obj = {};

		obj.Cast = function(...)
			castBar.Cast("player",...)
		end
		obj.Interrupt = function(...)
			castBar.Interrupt("player",...)
		end

		return obj;
	end
	
	api.GHI_StatusBarUI = function()
		local statusBar = GHI_StatusBarUI()
		obj = {}
		
		statusBar.Clear()
		
		obj.IsMeter = statusBar.IsMeter	
		obj.IsFill = statusBar.IsFill
		obj.Clear = statusBar.Clear
		obj.GetValue = statusBar.GetValue
		obj.Toggle = function(...)
			statusBar.Toggle(...)
		end
		
		obj.SetOrientation = function(...)
			statusBar.SetOrientation(...)
		end
		obj.SetMinMax = function(...)
			statusBar.SetMinMax(...)
		end
		obj.SetTheme = function(...)
			statusBar.SetTheme(...)			
		end
		obj.SetTextures = function(...)
			statusBar.SetTextures(...)
		end
		obj.SetFillColor = function(...)
			statusBar.SetFillColor(...)
		end
		obj.ChangeValue = function(...)
			statusBar.ChangeValue(...)
		end
		obj.SetText = function(...)
			statusBar.SetText(...)
		end
		return obj
	end
	
	api.GHI_ExtraButtonUI = function()
		local extraButton = GHI_ExtraButtonUI()
		
		obj = {}
		extraButton.Clear()
		
		obj.SetTheme = function(...)
			extraButton.SetTheme(...)
		end
		obj.SetIcon = function(...)
			extraButton.SetIcon(...)
		end		
		obj.SetCooldownTime = function(...)
			extraButton.SetCooldownTime(...)
		end		
		obj.SetMaxCharges = function(...)
			extraButton.SetMaxCharges(...)
		end		
		obj.ChangeCharges = function(...)
			extraButton.ChangeCharges(...)			
		end		
		obj.GetCharges = extraButton.GetCharges()
		obj.SetOnClick = function(...)
			extraButton.SetOnClick(...)
		end
		obj.SetTooltip = function(...)
			extraButton.SetTooltip(...)
		end
		obj.Toggle = function(...)
			extraButton.Toggle(...)
		end
		obj.Clear = extraButton.Clear
		
		return obj
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

