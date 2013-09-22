--===================================================
--
--				GHP_PerformActionUI
--  			GHP_PerformActionUI.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

function GHP_PerformActionUI()
	local class = GHClass("GHP_PerformActionUI");
	local loc = GHP_Loc();
	local expression = GHI_ExpressionHandler();

	local i = 1;
	while _G["GHP_PerformActionUI_"..i.."Main"] do
		i = i + 1;
	end

	local mainFrame = CreateFrame("EditBox","GHP_PerformActionUI_"..i.."Main",UIParent,"GHP_PerformAction_MainTemplate")

	class.New = function(performText,tooltipFunc,enterFunc)
		mainFrame:SetPoint("CENTER",0,0);
		mainFrame:SetPerformText(string.format(loc.PERFORM_TEXT,performText));
		mainFrame:SetPerformTooltipFunc(function(tooltipFrame)
			local tooltipShellFuncs = {"AddLine","AddDoubleLine","AddTexture","ClearLines", }
			local tooltipShellFrame = {};
			for _,v in pairs(tooltipShellFuncs) do
				tooltipShellFrame[v] = function(_,...)
					tooltipFrame[v](tooltipFrame,...);
				end
			end

			tooltipFunc(tooltipShellFrame);
		end);
		mainFrame.OnEnter = function()
			local e = mainFrame:GetExpression();
			local lastDelay,lastLen = 0,0;
			for i,v in pairs(e) do
				local delay;
				if v.delay == "auto" then
					delay = lastDelay + lastLen/15;
				elseif type(v.delay)=="number" then
					delay = lastDelay + v.delay;
				end

				expression.SendChatMessage(v.text,v.chatType,nil,nil,delay,nil,true);
				lastDelay = delay or lastDelay;
				lastLen = string.len(v.text);
			end
			mainFrame:Hide();

			if type(enterFunc) == "function" then
				enterFunc();
			end
		end;
		mainFrame:Show();
	end

	class.IsInUse = function()
		return mainFrame:IsShown();
	end

	return class;
end

