local DEFAULT_BUTTON_COLOR = { r = 0.5, g = 0.1, b = 0.1 };
local DEFAULT_BUTTON_TEXT_COLOR = { r = 1.0, g = 0.82, b = 0.0 };
local DEFAULT_TITLE_BAR_COLOR = { r = 0.5, g = 0.1, b = 0.1 };
local DEFAULT_TITLE_BAR_TEXT_COLOR = { r = 1, g = 1, b = 1 };
local DEFAULT_HEAD_TEXT_COLOR = { r = 1.0, g = 0.82, b = 0.0 };
local DEFAULT_DETAILS_TEXT_COLOR = { r = 1.0, g = 1.0, b = 1.0 };
local DEFAULT_BACKGROUND = "INTERFACE\\GLUES\\MODELS\\UI_BLOODELF\\bloodelf_mountains";
local DEFUALT_BACKGROUND_COLOR = { r = 0.3, g = 0.3, b = 0.3 }

local values = {};
local updateList = {};


function GHM_SetButtonColor(r, g, b)
	values.button = { r = r, g = g, b = b };
end

function GHM_GetButtonColor()
	local c = DEFAULT_BUTTON_COLOR;
	if (values.button) then
		c = values.button;
	end
	return c.r, c.g, c.b;
end

function GHM_SetButtonTextColor(r, g, b)
	values.buttonText = { r = r, g = g, b = b };
end

function GHM_GetButtonTextColor()
	local c = DEFAULT_BUTTON_TEXT_COLOR;
	if (values.buttonText) then
		c = values.buttonText;
	end
	return c.r, c.g, c.b;
end

function GHM_SetTitleBarColor(r, g, b)
	values.titleBar = { r = r, g = g, b = b };
end

function GHM_GetTitleBarColor()
	local c = DEFAULT_TITLE_BAR_COLOR;
	if (values.titleBar) then
		c = values.titleBar;
	end
	return c.r, c.g, c.b;
end

function GHM_SetTitleBarTextColor(r, g, b)
	values.titleBarText = { r = r, g = g, b = b };
end

function GHM_GetTitleBarTextColor()
	local c = DEFAULT_TITLE_BAR_TEXT_COLOR;
	if (values.titleBarText) then
		c = values.titleBarText;
	end
	return c.r, c.g, c.b;
end

function GHM_SetHeadTextColor(r, g, b)
	values.headText = { r = r, g = g, b = b };
end

function GHM_GetHeadTextColor()
	local c = DEFAULT_HEAD_TEXT_COLOR;
	if (values.headText) then
		c = values.headText;
	end
	return c.r, c.g, c.b;
end

function GHM_SetDetailsTextColor(r, g, b)
	values.details = { r = r, g = g, b = b };
end

function GHM_GetDetailsTextColor()
	local c = DEFAULT_DETAILS_TEXT_COLOR;
	if (values.detailsText) then
		c = values.detailsText;
	end
	return c.r, c.g, c.b;
end

function GHM_SetBackground(path)
	values.path = path;
end

function GHM_GetBackground()
	local path = DEFAULT_BACKGROUND;
	if (values.path) then
		path = values.path;
	end
	return path;
end

function GHM_SetBackgroundColor(r, g, b, a)
	values.backgroundColor = { r = r, g = g, b = b, a = a };
end

function GHM_GetBackgroundColor()
	local c = DEFAULT_BACKGROUND_COLOR;
	if (values.backgroundColor) then
		c = values.backgroundColor;
	end
	return c.r, c.g, c.b, c.a;
end

local useAnim = true;
function GHM_SetUseAnimation(use)
	if use == false then
		useAnim = false;
	else
		useAnim = true;
	end
end

function GHM_UseAnimation()
	return useAnim;
end

function GHM_AddThemedObject(obj)
    tinsert(updateList,obj);
	GHI_Timer(function() obj:UpdateTheme(); end,0,true);
end

function GHM_UpdateThemedObject()
	GHM_GameFontNormal:SetTextColor(GHM_GetHeadTextColor());
	GHM_GameFontSmall:SetTextColor(GHM_GetHeadTextColor());
	for i=1,#(updateList) do
		updateList[i]:UpdateTheme()
	end
end

function GHM_ColorToHex(r,g,b)
	return string.format("%.2x", r * 255) .. string.format("%.2x", g * 255) .. string.format("%.2x", b * 255);
end