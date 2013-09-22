--===================================================
--
--				GHM_Texture
--  			GHM_Texture.lua
--
--	          (displays an image as a GHM object)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================
local count = 1;
function GHM_Texture(parent, main, profile)

	local miscAPI = GHI_MiscAPI().GetAPI();
    local loc = GHI_Loc();
	
    local frame = CreateFrame("Frame", "GHM_Texture" .. count, parent);
	
	local texture = frame:CreateTexture(frame:GetName().."Texture")
	
	texture:SetAllPoints(frame)
		
	count = count + 1; -- Increment the counter to give the next frame of this type a unique name

    -- Initialize variables and reference objects
    -- Example:
    

    -- Help functions and further setup
	
	frame:SetWidth(profile.width or 64)
	frame:SetHeight(profile.height or 64)
	
	if type(profile.texCoord) == "table" then
		texture:SetTexCoord(unpack(profile.texCoord))		
	end
    
	if profile.color then
		texture:SetTexture(1,1,1,1)
		texture:SetVertexColor(profile.color[1] or profile.r, profile.color[2] or profile.g, profile.color[3] or profile.b)
	else
		texture:SetTexture(1,1,1,1)
		texture:SetVertexColor(1,1,1)
	end
	
	if profile.path then
		texture:SetTexture(profile.path)
	end

	if profile.alpha then
		texture:SetAlpha(profile.alpha)
	end
	
	if profile.blend then
		texture:SetBlendMode(profile.blend)
	end
			
    -- Position the frame
    GHM_FramePositioning(frame,profile,parent);

    -- Public functions
    local varAttFrame;

    frame.Force = function(path,width,height,alpha) -- Calls Force1 or Force2 depending on the number of inputs. Either Force(value) or Force(Type,value)
		
		if type(path) == "string" then
			texture:SetTexture(path)
		elseif type(path) == "table" then
			texture:SetTexture(path[1] or path.r, path[2] or path.g, path[3] or path.b, 1)
		end
		if width then
			frame:SetWidth(width)
		end
		if height then
			frame:SetHeight(height)
		end
		if alpha then
			texture:SetAlpha(alpha)
		end
		
		texture:SetAllPoints(frame)
		
    end

    frame.Clear = function(self)
       frame:SetHeight(64)
	   frame:SetWidth(64)
	   texture:SetTexture(1, 1, 1, 1)
	   texture:SetAlpha(1)
	   texture:SetBlendMode("BLEND")
	   texture:SetTexCoord(0,1,0,1)
    end

    frame.GetValue = function(self) -- Get the current value
		
		local tex = texture:GetTexture()
		if tex == "SolidTexture" then
			local r,g,b,a = texture:GetVertexColor()
			tex = {r,g,b,a}
		end
		
		local width = frame:GetWidth()
		local height = frame:GetHeight()
		local alpha = texture:GetAlpha()
		
		return tex, width, height, alpha

    end


    -- Trigger evt onLoad function
    if type(profile.OnLoad) == "function" then
        profile.OnLoad(frame);
    end

    frame:Show();
    return frame;
end