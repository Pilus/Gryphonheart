--
--
--				GHM_Texture
--  			GHM_Texture.lua
--
--	          (displays an image as a GHM object)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--
local count = 1;
function GHM_Texture(profile, parent, settings)

	local miscAPI = GHI_MiscAPI().GetAPI();
    local loc = GHI_Loc();	
    local frame = CreateFrame("Frame", "GHM_Texture" .. count, parent);
	count = count + 1;
	
    -- Help functions and further setup
	
	frame:SetWidth(profile.width or 64)
	frame:SetHeight(profile.height or 64)
	
	frame.texture = frame:CreateTexture(frame:GetName().."Texture")
	frame.texture:SetSize(frame:GetWidth(), frame:GetHeight())
	frame.texture:SetPoint("CENTER")
	
	if type(profile.texCoord) == "table" then
		frame.texture:SetTexCoord(unpack(profile.texCoord))		
	end
    
	if profile.color then
		frame.texture:SetColorTexture(1,1,1,1)
		frame.texture:SetVertexColor(profile.color[1] or profile.r, profile.color[2] or profile.g, profile.color[3] or profile.b)
	else
		frame.texture:SetColorTexture(1,1,1,1)
		frame.texture:SetVertexColor(1,1,1)
	end
	
	if profile.path then
		frame.texture:SetTexture(profile.path)
	end

	if profile.alpha then
		frame.texture:SetAlpha(profile.alpha)
	end
	
	if profile.blend then
		frame.texture:SetBlendMode(profile.blend)
	end

	-- Public functions
	local varAttFrame;
	
	local Force1 = function(path, width, height, alpha)
		if type(path) == "string" then
			frame.texture:SetTexture(path)
		elseif type(path) == "table" then
			frame.texture:SetColorTexture(path[1] or path.r, path[2] or path.g, path[3] or path.b, path[4] or path.a or 1)
		end
		
		if width then
			frame.texture:SetWidth(width)
		end
		if height then
			frame.texture:SetHeight(height)
		end
		if alpha then
			frame.texture:SetAlpha(alpha)
		end		
		frame.texture:SetAllPoints(frame)
	end
	
	local Force2 = function(inputType, inputValue)
        if (inputType == "attribute" or inputType == "variable") and varAttFrame then -- Handles input to var/Att frame
            varAttFrame:SetValue(inputType, inputValue);

        else -- static
            varAttFrame:Clear();
            Force1(inputValue);
        end
    end

    frame.Force = function(self, ...)
		--[[if self ~= frame then return frame.Force(frame, self, ...); end
        local numInput = #({ ... });

        if numInput == 1 then
            Force1(...);
        elseif numInput == 2 then
            Force2(...);
        end]]
		Force1(self, ...)
    end
	
	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
        if not (varAttFrame) then
            varAttFrame = GHM_VarAttInput(frame, area, frame:GetWidth());
            frame:SetHeight(frame:GetHeight());
        end
        varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
    end

    frame.Clear = function(self)
       frame:SetHeight(64)
	   frame:SetWidth(64)
	   frame.texture:SetColorTexture(1, 1, 1, 1)
	   frame.texture:SetSize(frame:GetWidth(), frame:GetHeight())
	   frame.texture:SetAlpha(1)
	   frame.texture:SetBlendMode("BLEND")
	   frame.texture:SetTexCoord(0,1,0,1)
    end

    frame.GetValue = function(self) -- Get the current value
		
		local tex = frame.texture:GetTexture()
		if tex == "SolidTexture" then
			local r,g,b,a = frame.texture:GetVertexColor()
			tex = {r,g,b,a}
		end
		
		local width = frame:GetWidth()
		local height = frame:GetHeight()
		local alpha = frame.texture:GetAlpha()
		
		return tex, width, height, alpha

    end


    -- Trigger evt onLoad function
    if type(profile.OnLoad) == "function" then
        profile.OnLoad(frame);
    end

    frame:Show();
    return frame;
end