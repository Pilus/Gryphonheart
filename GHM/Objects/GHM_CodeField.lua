--===================================================
--
--				GHM_CodeField
--  			GHM_CodeField.lua
--
--	   Text field object for large amounts of text
--
-- 	  	(c)2013 The Gryphonheart Team
--			  All rights reserved
--===================================================

local DEFAULT_WIDTH = 170;
local DEFAULT_HEIGHT = 80;

local count = 1;
function GHM_CodeField(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_CodeField" .. count, parent, "GHM_CodeField_Template");
	count = count + 1;
	
	local label = _G[frame:GetName().."TextLabel"];
	local area = _G[frame:GetName().."Area"];
	local scrollFrame = _G[area:GetName().."Scroll"];
	local fieldFrame = _G[scrollFrame:GetName().."Text"];
	local syntaxHighlight = GHM_CodeField_SyntaxHighlight()
	
	label:SetText(profile.text or "");
	
	frame.field = fieldFrame;
	
	GHM_FramePositioning(frame,profile,parent);
	
	if profile.height then
		frame:SetHeight(profile.height);
	end
	
	if profile.width then
		frame:SetWidth(profile.width);
	end
	
	frame:SetScript("OnMouseDown", function()
		fieldFrame:SetFocus();
	end)
	frame:SetScript("OnMouseUp", function()
		fieldFrame:SetFocus();
	end)

	fieldFrame:SetWidth(frame:GetWidth()-33);
	
	fieldFrame:SetScript("OnCursorChanged",function(self,arg1,arg2,arg3)
		local scrollBar = _G[self:GetParent():GetName().."ScrollBar"]
		local h = scrollBar:GetHeight();
		if (-arg2)-h-scrollBar:GetValue() > 22 then
			scrollBar:SetValue(-arg2+ (-3.0*arg3) -h);
		end
		if -3 > -arg2-scrollBar:GetValue() then
			scrollBar:SetValue(-arg2- 1.5*arg3);
		end
	end)
	
	syntaxHighlight.GHM_LoadSyntaxColorList()
	
	fieldFrame:SetScript("OnShow", function(self)
		local syntaxDisabled = GHI_MiscData.syntaxDisabled
		if syntaxDisabled == true then
			return
		else
			local syntaxColors = syntaxHighlight.GHM_GetSyntaxColorList()
			IndentationLib.Enable(self,4,syntaxColors)
		end
	end)
	
	fieldFrame:SetScript("OnHide", function(self)
		IndentationLib.Disable()
	end)
	
	fieldFrame:SetScript("OnEscapePressed", function(self)
		self:ClearFocus();
	end)
	
	fieldFrame:SetScript("OnTextChanged", function(self,userInput)

	end);

	-- toolbar buttons
	local toolbar = GHM_Toolbar(area,fieldFrame);
	toolbar:SetPoint("TOPLEFT",3,-3);
	
	if profile.toolbarButtons then
		for _,toolbarButton in pairs(profile.toolbarButtons) do
			toolbar.AddButton(toolbarButton.texture,toolbarButton.func,toolbarButton.tooltip);
		end
	end

	-- functions
	local varAttFrame;

	local Force1 = function(data)
		fieldFrame:SetText(data);
	end

	local Force2 = function(inputType, inputValue)
		if (inputType == "attribute" or inputType == "variable") and varAttFrame then
			varAttFrame:SetValue(inputType, inputValue);
		else -- static
			varAttFrame:Clear();
			Force1(inputValue);
		end
	end

	frame.Force = function(self, ...)
		if self ~= frame then return frame.Force(frame, self, ...); end
		local numInput = #({ ... });

		if numInput == 1 then
			Force1(...);
		elseif numInput == 2 then
			Force2(...);
		end
	end

	frame.Clear = function(self)
		fieldFrame:SetText("");
	end

	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
		if not (varAttFrame) then
			varAttFrame = GHM_VarAttInput(frame, area, frame:GetWidth());
			frame:SetHeight(frame:GetHeight());
		end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
	end

	frame.GetValue = function(self)
		if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
			return varAttFrame:GetValue();
		else
			return fieldFrame:GetText();
		end
	end

	frame.Insert = function(t)
		fieldFrame:Insert(t)
	end

	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end

	frame.Clear();
	frame:Show();

	return frame;
end