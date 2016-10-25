--
--
--				GHM_Sound
--  			GHM_Sound.lua
--
--	   Sound widget for selection of sounds in dynamic actions
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local count = 1;
function GHM_Sound(profile, parent, settings)
	local loc = GHI_Loc();
	local miscAPI = GHI_MiscAPI().GetAPI();
	local frame = CreateFrame("Frame", "GHM_Sound" .. count, parent, "GHM_Sound_Template");
	count = count + 1;
	local area = _G[frame:GetName().."Area"];

	local label = _G[frame:GetName().."Label"];
	label:SetText(profile.text or "");

	local selectButton = _G[area:GetName().."SelectButton"];
	local playButton = _G[area:GetName().."PlayButton"];
	local pathLabel = _G[area:GetName().."Path"];
	local durationLabel = _G[area:GetName().."Duration"];

	selectButton:SetText(loc.SELECT_SOUND)

	local currentSelected = {
		path = "",
		duration = 0,
	};
	local UpdateSelection = function()
		if type(currentSelected) == "table" and strlen(currentSelected.path) > 0 then
			pathLabel:SetText(currentSelected.path);

			local duration = currentSelected.duration or 0;
			local timeString = miscAPI.GHI_GetPreciseTimeString(duration);
			if duration == 0.05 or duration == 0 then
				timeString = "(Unknown)"
			end
			local coloredTimeString = miscAPI.GHI_ColorString(timeString, 0.0, 0.7, 0.5);

			durationLabel:SetText(coloredTimeString);
		else
			pathLabel:SetText(loc.NO_SOUND_SELECTED);
			durationLabel:SetText("");
		end
	end

	local selectionMenu;
	selectButton:SetScript("OnClick",function()
		if not(selectionMenu) then
			selectionMenu = GHM_SoundSelectionMenu();
		elseif (selectionMenu.IsInUse()) then
			GHM_LayerHandle(selectionMenu);
			return;
		end

		selectionMenu.Show(function(sound)
			currentSelected = sound;
			UpdateSelection();
		end,currentSelected);
	end);

	playButton:SetScript("OnClick",function()
		if currentSelected then
			PlaySoundFile(currentSelected.path);
		end
	end)

	-- functions
	local varAttFrame;

	local Force1 = function(data)
		if type(data) == "table" then
			currentSelected = data;
		else
			currentSelected = nil;
		end
	   	UpdateSelection();
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
		currentSelected = nil;
		UpdateSelection();
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
		   	return currentSelected;
	   	end
     end

    -- frame.UpdateTheme = function()
     -- Update the theme using the theme functions
     -- Example:
     -- local color = GHM_GetDetailsTextColor();
     --  someLabel:SetTextColor(color.r,color.g,color.b);
         -- local background = GHM_GetBackground();
	    -- local titleBarColor = GHM_GetTitleBarColor();
	    -- local titleBarTextColor = GHM_GetTitleBarTextColor();
		--local backgroundColor = GHM_SetBackgroundColor();
		--local buttonColor = GHM_GetButtonColor();
		--local mainTextColor = GHM_GetHeadTextColor();
		--local detailsTextColor = GHM_GetDetailsTextColor();

          --button:SetVertexColor(buttonColor.r,buttonColor.g,buttonColor.b)
          --frame:SetTexture(background);
          --local label = _G[frame:GetName() .. "TextLabel"];
          --label:SetTextColor(mainTextColor.r,mainTextColor.g,mainTextColor.b)

    -- end

     --GHM_AddThemedObject(frame)



	if type(profile.OnLoad) == "function" then
	   	profile.OnLoad(frame);
	end

	frame.Clear();
	frame:Show();

	return frame;
end



local menus = {};
local miscAPI;
local ICON = "Interface\\Icons\\INV_Misc_Drum_02";
local NAME = "GHM_SoundSelectionMenu";

function GHM_SoundSelectionMenu(_OnOkCallback,sound)
	if not (miscAPI) then miscAPI = GHI_MiscAPI().GetAPI(); end

	for i, menu in pairs(menus) do
		if not (menu.IsInUse()) then
			menu.Show(_OnOkCallback,sound)
			return menu
		end
	end
	local class = GHClass(NAME);
	table.insert(menus, class);

	local menuFrame, OnOkCallback;
	local inUse = false;
	local menuIndex = 1;
	while _G[NAME .. menuIndex] do menuIndex = menuIndex + 1; end
	local loc = GHI_Loc();

	local currentSound;

	class.Show = function(_OnOkCallback, sound)
		OnOkCallback = _OnOkCallback;
		inUse = true;
		currentSound = sound;
		if (currentSound) then
			menuFrame.ForceLabel("currentSound", currentSound.path);
			local timeString = miscAPI.GHI_GetPreciseTimeString(currentSound.duration);
			if currentSound.duration == 0.05 or currentSound.duration == 0 then
				timeString = "(Unknown)"
			end
			local coloredTimeString = miscAPI.GHI_ColorString(timeString, 0.0, 0.7, 0.5);
			menuFrame.ForceLabel("duration",coloredTimeString);
		else
			menuFrame.ForceLabel("currentSound", loc.NO_SOUND_SELECTED);
			menuFrame.ForceLabel("duration","");
		end
		menuFrame:AnimatedShow();
	end
	class.New = class.Show;

	class.IsInUse = function() return inUse; end

	local OnOk = function()
		local action;

		if OnOkCallback then
			OnOkCallback(currentSound);
		end
		inUse = false;
		menuFrame:Hide();
	end

	menuFrame = GHM_NewFrame(class, {
		onOk = function(self) end,
		{
			{
				{
					type = "Dummy",
					height = 20,
					width = 10,
					align = "l",
				},
				{
					type = "Text",
					fontSize = 11,
					width = 390,
					text = loc.SELECT_SOUND_INSTRUCTION,
					color = "white",
					align = "l",
				},
			},
			{
				{
					align = "c",
					type = "SoundSelection",
					label = "soundTree",
					width = 390,
					height = 300,
					texture = "Tooltip",
					OnSelect = function(path,duration)
						if not(menuFrame) then return end
						menuFrame.ForceLabel("currentSound", path);


						local timeString = miscAPI.GHI_GetPreciseTimeString(duration);
						if duration == 0.05 or duration == 0 then
							timeString = "(Unknown)"
						end
						local coloredTimeString = miscAPI.GHI_ColorString(timeString, 0.0, 0.7, 0.5);

						menuFrame.ForceLabel("duration", coloredTimeString);

						currentSound = {
							path = path,
							duration = duration,
						};
					end,
				},
			},
			{
				{
					type = "Dummy",
					height = 5,
					width = 10,
					align = "l",
				},
				{
					type = "Text",
					fontSize = 11,
					width = 150,
					text = loc.CURRENTLY_SELECTED,
					color = "yellow",
					yOff = 15,
					align = "l",
					singleLine = true,
				},
				{
					type = "Text",
					fontSize = 11,
					width = 300,
					height = 50,
					xOff = 0,
					text = loc.NO_SOUND_SELECTED,
					color = "white",
					yOff = 0,
					align = "l",
					label = "currentSound",
					singleLine = true,
				},
				{
					type = "Dummy",
					height = 10,
					width = 10,
					xOff = -10,
					align = "r",
					label = "playSoundAnchor",
				},
				{
					type = "Text",
					fontSize = 11,
					width = 250,
					xOff = -20,
					text = "",
					color = "white",
					yOff = 0,
					align = "r",
					label = "duration",
					singleLine = true,
				},
			},
			{
				{
					type = "Dummy",
					height = 10,
					width = 100,
					align = "l",
				},
				{
					type = "Button",
					text = OKAY,
					align = "l",
					label = "ok",
					compact = false,
					OnClick = OnOk,
				},
				{
					type = "Dummy",
					height = 10,
					width = 100,
					align = "r",
				},
				{
					type = "Button",
					text = CANCEL,
					align = "r",
					label = "cancel",
					compact = false,
					OnClick = function(obj)
						menuFrame:Hide();
					end,
				},
			},
		},
		title = loc.SELECT_SOUND,
		name = NAME .. menuIndex,
		theme = "BlankTheme",
		width = 400,
		useWindow = true,
		background = "INTERFACE\\GLUES\\MODELS\\UI_BLOODELF\\bloodelf_mountains",
		OnShow = function(self)
			if not (menuFrame.playButton) then
				local parent = menuFrame.GetLabelFrame("playSoundAnchor");
				local playBtn = CreateFrame("Button", nil, parent);
				playBtn:SetWidth(24);
				playBtn:SetHeight(24);
				playBtn:SetPoint("CENTER", 0, 0);
				playBtn:SetNormalTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up");
				playBtn:SetPushedTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Down");
				playBtn:SetScript("OnClick", function(self)
					local path = menuFrame.GetLabel("currentSound");
					PlaySoundFile(path);
				end);
				playBtn:RegisterForClicks("AnyUp");
				menuFrame.playButton = playBtn;
			end
		end,
		icon = ICON,
		lineSpacing = 20,
		OnHide = function()
			if not (menuFrame.window:IsShown()) then
				inUse = false;
			end
		end,
	});

	class.Show(_OnOkCallback, sound)

	return class;
end

