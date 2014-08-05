-- Lua Document
-- profile.child
--profile.bg
-- profile.width
-- profile.height

local count = 1;
function GHM_ScrollingFrame(profile, parent, settings)
    local frame = CreateFrame("ScrollFrame", "GHM_ScrollingFrame" .. count, parent, "GHM_ScrollFrameTemplate"); -- Create the frame from the xml template
    count = count + 1; -- Increment the counter to give the next frame of this type a unique name

    -- Initialize variables and reference objects
    -- Example:
    local miscAPI = GHI_MiscAPI().GetAPI();
    local loc = GHI_Loc();
	--[[local defaultFrame = {
		{
		},
		OnShow = function()	end,
		height = frame:GetHeight() - 16,
		name = "GHM_ScrollingFrameChild" .. count,
		theme = "BlankTheme",
		width = frame:GetWidth() - 16,
	}]]
	
	local scrollPage = profile.child
	local scrollFrame
	
    -- Help functions and further setup
	
	frame:SetWidth(profile.width or frame:GetParent():GetWidth()-20)
	frame:SetHeight(profile.height or frame:GetParent():GetHeight()-20)
		
	local function CreateScrollChild(scrollData)
		if scrollFrame then
			scrollFrame = nil
		end
		scrollFrame = GHM_NewFrame(CreateFrame("frame"), scrollData);
		scrollFrame:SetParent(frame)
		frame:SetScrollChild(scrollFrame)
		local frameLevel = scrollFrame:GetParent():GetFrameLevel()
		frameLevel = frameLevel +10
		scrollFrame:SetFrameLevel(frameLevel)
		scrollFrame:SetPoint("TOP",frame,"TOP")
		scrollFrame:Show()
	end
	
	if profile.child then
		CreateScrollChild(profile.child)
	end

	-- Public functions
	frame.Force = function(self, data) -- Calls Force1 or Force2 depending on the number of inputs. Either Force(value) or Force(Type,value)
		if type(data) == "table" then
			frame.Clear()
			CreateScrollChild(data)
		end
    end

    frame.Clear = function(self)
		if scrollFrame then
		scrollFrame:Hide()
		scrollFrame = nil
		end
		frame:SetScrollChild(nil)
        -- Clear the value / ui to a default state
    end

    frame.GetValue = function(self) -- Get the current value
            return scrollFrame:GetName(); -- Value should be what is currently the value / in the ui. Use evt help functions
    end


    -- Trigger evt onLoad function
    if type(profile.OnLoad) == "function" then
        profile.OnLoad(frame);
    end

    --frame.Clear();
    frame:Show();
    return frame;
end