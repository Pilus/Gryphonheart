if not (GHM_OptionsData) then GHM_OptionsData = {}; end;

local framesToLocalize = {};
function GH_Localize(frame)
	if GHI_Loc then
		GHI_Loc().LocalizeFrame(frame);
	else
		table.insert(framesToLocalize,frame);
	end
end
local frame = CreateFrame("Frame");
frame:RegisterEvent("VARIABLES_LOADED")
frame:SetScript("OnEvent",function()
      local loaded = IsAddOnLoaded("GHI")
     if not(loaded) then error("Gryphonheart Items (GHI) Must be loaded with GHM") return end
	local loc = GHI_Loc();
	for _,f in pairs(framesToLocalize) do
		loc.LocalizeFrame(frame);
	end
end)


function GHM_FramePositioning(frame,profile,parent)
	-- Frame positioning
	local extraX = profile.xOff or 0;
	local extraY = profile.yOff or 0;

	if profile.align == "c" then
		frame:SetPoint("CENTER", parent, "CENTER", extraX, extraY);
	elseif profile.align == "r" then
		if parent.lastRight then
			frame:SetPoint("RIGHT",  parent.lastRight, "LEFT", extraX, extraY);
		else
			frame:SetPoint("RIGHT", parent, "RIGHT", extraX, extraY);
		end

		parent.lastRight = frame;
	else
		if parent.lastLeft then
			frame:SetPoint("LEFT", parent.lastLeft, "RIGHT", extraX, extraY);
		else
			frame:SetPoint("LEFT", parent, "LEFT", extraX, extraY);
		end
		parent.lastLeft = frame;
	end
end

local GiveWarnings = false;
local ShowLines = false;

function GHM_TempBG(f)
	f:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Gold-Background",
		tile = false,
		tileSize = 0,
		edgeSize = 32,
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	});
	local color = { r = 0.4, g = 0.5, b = 0.8 }
	if GHI_EffectColors then
		color = GHI_EffectColors[GHI_ColorList[random(1, 6)]];
	end
	f:SetBackdropColor(color.r, color.g, color.b, 1);
end

local function Warning(msg)
	if GiveWarnings == true then
		local info = ChatTypeInfo["COMBAT_XP_GAIN"];
		DEFAULT_CHAT_FRAME:AddMessage(msg, info.r, info.g, info.b, info.id);
	end
end

--- intern data 
local LabelValues = {};
local lastestEditbox = nil;

local function GetFrameType(name)
	if name == "Editbox" then
		return "Editbox";
	elseif name == "StackSlider" or name == "TimeSlider" or name == "SlotSlider" or name == "CustomSlider" then
		return "Slider";
	elseif name == "CheckBox" then
		return "CheckButton";
	elseif name == "Button" or name == "Icon" then
		return "Button";
	elseif name == "PlayButton" then
		return "Button";
	end

	return "Frame";
end

function GHM_CreateObject(num, profile, parent,givenMain)
	if not (profile.type) then
		return 0;
	end

	local main = givenMain or parent:GetParent():GetParent();

	--print("Create obj",profile.type)

	-- new object format
	if type(_G["GHM_" .. profile.type]) == "function" then
		local obj = _G["GHM_" .. profile.type](parent, main, profile)
		main.RegisterLabel(profile.label, obj);
		if not(obj.GetLabel) then
			obj.GetLabel = function() return profile.label end
		end
		--GHM_TempBG(obj);
		return obj:GetHeight();
	end


	local offsetX = 0;
	local offsetY = 0;
	local extraX = 0;
	local extraY = 0;


	--	Create object
	local obj = CreateFrame(GetFrameType(profile.type), parent:GetName() .. "_O" .. num, parent, "GHM_" .. profile.type .. "_Template");

	obj.main = main;
	Warning("Inserted object " .. num .. ", type: " .. profile.type .. " = " .. obj:GetObjectType() .. ", name: " .. obj:GetName());

	local l = main.GetLabel(profile.label);
	if not (l == nil) then
		Warning("Label " .. profile.label .. " already registered.");
		obj.label = nil;
	else
		obj.label = profile.label;
		main.RegisterLabel(obj.label, obj);
	end

	local height = obj:GetHeight();

	obj.type = profile.type;
	if profile.type == "Text" then
		local label = _G[obj:GetName() .. "Label"];
		label:SetText(profile.text);
		if profile.color == "white" then
			label:SetTextColor(1, 1, 1);
			--GHI_Message("Making "..obj:GetName().." white");
		end

		if profile.align == "c" then
			label:SetJustifyH("CENTER");
		elseif profile.align == "r" then
			label:SetJustifyH("RIGHT");
		else
			label:SetJustifyH("LEFT");
		end

		if profile.fontSize then
			label:SetFont("Fonts\\FRIZQT__.TTF", profile.fontSize);
		end
		if profile.width then
			obj:SetWidth(profile.width);
		end
		if profile.singleLine == true then
			obj:SetHeight(label:GetHeight());
		end

		height = label:GetHeight();
	elseif profile.type == "Editbox" then


	elseif profile.type == "StackSlider" then
		local label = _G[obj:GetName() .. "TextLabel"];
		height = height + label:GetHeight();
		offsetY = -5;
		obj:SetValue(2);
		obj:SetValue(1);
		if profile.text then label:SetText(profile.text); end
		if type(profile.width) == "number" then
			obj:SetWidth(profile.width);
		end
		obj.OnValueChanged = profile.OnValueChanged;
		obj.IgnoreGetValueFunc = true;
	elseif profile.type == "SlotSlider" then
		local label = _G[obj:GetName() .. "Label1"];
		height = height + label:GetHeight();
		offsetY = -5;
		obj:SetValue(2);
		obj:SetValue(1);
		if profile.text then label:SetText(profile.text); end
		if type(profile.width) == "number" then
			obj:SetWidth(profile.width);
		end
		obj.OnValueChanged = profile.OnValueChanged;
		obj.IgnoreGetValueFunc = true;
	elseif profile.type == "TimeSlider" then
		local label = _G[obj:GetName() .. "TextLabel"];
		if type(profile.text) == "string" then
			label:SetText(profile.text);
		end
		height = height + label:GetHeight();
		offsetY = -5;
		obj:SetValue(2);
		obj:SetValue(1);
		if type(profile.values) == "table" then
			obj.SliderValues = profile.values;
			obj:SetMinMaxValues(1, #(profile.values));
			obj:SetValue(2);
			obj:SetValue(1);
		end
		if type(profile.width) == "number" then
			obj:SetWidth(profile.width);
		end
		obj.OnValueChanged = profile.OnValueChanged;
		obj.IgnoreGetValueFunc = true;
	elseif profile.type == "CustomSlider" then
		local label = _G[obj:GetName() .. "Label1"];
		if type(profile.text) == "string" then
			label:SetText(profile.text);
		end
		height = height + label:GetHeight();
		offsetY = -5;
		obj:SetValue(2);
		obj:SetValue(1);
		if type(profile.values) == "table" then
			obj.SliderValues = profile.values;
			obj:SetMinMaxValues(1, #(profile.values));
			obj:SetValue(2);
			obj:SetValue(1);
		end
		if type(profile.width) == "number" then
			obj:SetWidth(profile.width);
		end
		obj.OnValueChanged = profile.OnValueChanged;
		obj.IgnoreGetValueFunc = true;
	elseif profile.type == "CheckBox" then
		local label = _G[obj:GetName() .. "TextLabel"];
		if type(profile.text) == "string" then
			label:SetText(profile.text);
		end

		if profile.checked == true then
			--obj:SetChecked(1);	
			main.ForceLabel(obj.label, true);
		else
			main.ForceLabel(obj.label, false);
		end
		if profile.align == "r" then
			offsetX = label:GetStringWidth();
		end
		if type(profile.OnClick) == "function" then
			obj:SetScript("OnClick", profile.OnClick);
		end
	elseif profile.type == "QualityDD" then
		local label = _G[obj:GetName() .. "Text2Label"];
		if type(profile.text) == "string" then
			label:SetText(profile.text);
		else
			label:SetText("Quality:");
		end
		local label2 = _G[obj:GetName() .. "TextLabel"];
		if type(profile.initPos) == "number" then
			local color = ITEM_QUALITY_COLORS[profile.initPos];
			label2:SetText("|CFF" .. string.format("%.2x", color.r * 255) .. string.format("%.2x", color.g * 255) .. string.format("%.2x", color.b * 255) .. " " .. _G["ITEM_QUALITY" .. profile.initPos .. "_DESC"] .. "|r");
			main.SetLabel(obj.label, profile.initPos);
		else
			local color = ITEM_QUALITY_COLORS[1];
			label2:SetText("|CFF" .. string.format("%.2x", color.r * 255) .. string.format("%.2x", color.g * 255) .. string.format("%.2x", color.b * 255) .. " " .. _G["ITEM_QUALITY1_DESC"] .. "|r");
			main.SetLabel(obj.label, 1);
		end
		obj:SetWidth(155);
		obj.owner = main;
		height = height + label:GetHeight();
		offsetY = -5;
		extraX = 0;
		obj.OnValueChanged = profile.OnValueChanged;
		-- (obj:GetWidth()/2)
		--if profile.align == "r" then
		--	extraX = extraX - 87;
		--elseif profile.align == "c" then
		--	extraX = extraX; -- 40;
		--end
		obj:Hide();
		obj:Show();
	elseif profile.type == "CustomDD" then
		local label = _G[obj:GetName() .. "Label"];
		if type(profile.text) == "string" then
			label:SetText(profile.text);
		end
		if profile.width then
			obj:SetWidth(profile.width);
			_G[obj:GetName() .. "Middle"]:SetWidth(profile.width - 40);
		else
			obj:SetWidth(155);
		end
		offsetX = -8;

		obj.GetData = function()
			if type(profile.dataFunc) == "function" then
				return profile.dataFunc() or {};
			elseif type(profile.data) == "table" then
				return profile.data;
			end
			return {};
		end

		local label2 = _G[obj:GetName() .. "TextLabel"];
		local pos = profile.initPos;
		local t = profile.data;
		if type(t) == "table" then
			if type(pos) == "number" then
				label2:SetText(t[pos]);
				if profile.returnIndex == true then
					main.SetLabel(obj.label, pos);
					obj.value = pos;
				else
					main.SetLabel(obj.label, t[pos]);
					obj.value = t[pos];
				end
			else
				label2:SetText(t[1]);
				if profile.returnIndex == true then
					main.SetLabel(obj.label, 1);
					obj.value = 1;
				else
					main.SetLabel(obj.label, t[1]);
					obj.value = t[1];
				end
			end
		else
			label2:SetText("");
		end
		obj.OnSelect = profile.OnSelect;

		obj.GetValue = function()
			return obj.value;
		end

		height = height + label:GetHeight();
		offsetY = -5;
		--[[
		extraX = - (obj:GetWidth()/2)
		if profile.align == "r" then
			extraX = extraX - 87;
		elseif profile.align == "c" then
			extraX = extraX - 40;
		end 
		]]
		obj.returnIndex = profile.returnIndex;
	elseif profile.type == "Button" then
		local label = _G[obj:GetName() .. "Text"];
		if label then
			if type(profile.text) == "string" then
				label:SetText(profile.text);
			end
			if profile.fontSize then
				--label:SetFont("Fonts\\FRIZQT__.TTF",profile.fontSize);
			end

			if profile.compact == true then
				obj:SetHeight(label:GetHeight() + 8);
				obj:SetWidth(label:GetWidth() + 8);
			else
				local origWidth = obj:GetWidth();
				obj:SetWidth(200);
				if label:GetWidth() > (origWidth - 10) then
					obj:SetWidth(label:GetWidth() + 10);
				else
					obj:SetWidth(origWidth);
				end
			end
			if profile.width then
				obj:SetWidth(profile.width);
			end
		end
		if profile.tooltip then
			obj.tooltip = profile.tooltip;
		end

		obj.ignoreTheme = profile.ignoreTheme;

		if type(profile.onclick) == "function" then
			obj:SetScript("OnClick", profile.onclick);
		end
		if type(profile.OnClick) == "function" then
			obj:SetScript("OnClick", profile.OnClick);
		end
	elseif profile.type == "PlayButton" then

		if type(profile.onclick) == "function" then
			obj:SetScript("OnClick", profile.onclick);
		end
	elseif profile.type == "Icon" then
		local label = _G[obj:GetName() .. "TextLabel"];
		if type(profile.text) == "string" then
			label:SetText(profile.text);
		end
		height = height + label:GetHeight() * 1.8;
		offsetY = -10;
		if profile.framealign then
			obj.framealign = profile.framealign;
		else
			obj.framealign = "c";
		end
		obj.OnChanged = profile.OnChanged;
	elseif profile.type == "Dummy" then
		obj:SetHeight(profile.height);
		obj:SetWidth(profile.width);
		height = profile.height;
	elseif profile.type == "EditField" then
		obj:SetHeight(profile.height);
		obj:SetWidth(profile.width);
		height = profile.height;
	elseif profile.type == "CodeField" then
		obj:SetHeight(profile.height);
		obj:SetWidth(profile.width);
		height = profile.height;
	elseif profile.type == "TreeView" then --- tree view
		obj:SetHeight(profile.height);
		obj:SetWidth(profile.width)
		height = profile.height;
	elseif profile.type == "SoundSelection" then --- Sound Select
		obj:SetHeight(profile.height);
		obj:SetWidth(profile.width)
		height = profile.height;
		if profile.OnSelect then
			obj.treeView:AddScript("OnSelectionChange", profile.OnSelect);
		end
	elseif profile.type == "ImageList" then
		obj:SetHeight(profile.height);
		obj:SetWidth(profile.width);
		if profile.scaleX or profile.scaleY then
			obj.SetScale(profile.scaleX or 1, profile.scaleY or 1)
		end
		height = profile.height;
		obj.OnSelect = profile.OnSelect;
	elseif profile.type == "HBar" then
		height = 5;
		obj:SetWidth(profile.width);
	end
	obj:ClearAllPoints()

	extraX = profile.xOff or 0;
	extraY = profile.yOff or 0;

	if profile.align == "c" then
		obj:SetPoint("CENTER", parent, "CENTER", 0 + extraX, offsetY + extraY);
	elseif profile.align == "r" then
		if parent.lastRight then
			local y = 0;
			if parent.lastRight.type == "CustomDD" or parent.lastRight.type == "QualityDD" then
				y = 5;
			elseif parent.lastRight.type == "Icon" then
				y = 10;
			elseif parent.lastRight.type == "CheckBox" then
				y = 180;
			end
			obj:SetPoint("RIGHT", parent.lastRight, "LEFT", -offsetX + extraX, offsetY + extraY + y);
			parent.lastRight = obj;
		else
			obj:SetPoint("RIGHT", parent, "RIGHT", -offsetX + extraX, offsetY + extraY);
			parent.lastRight = obj;
		end

	else
		if parent.lastLeft then
			local y = 0;
			if parent.lastLeft.type == "CustomDD" or parent.lastLeft.type == "QualityDD" then
				y = 5;
			elseif parent.lastLeft.type == "Icon" then
				y = 10;
			end

			local x = 0;
			if parent.lastLeft  then
				if parent.lastLeft.type == "CheckBox" then
					x = 180;
				end
			end

			obj:SetPoint("LEFT", parent.lastLeft, "RIGHT", offsetX + extraX + x, offsetY + extraY + y);
			parent.lastLeft = obj;
		else
			obj:SetPoint("LEFT", parent, "LEFT", offsetX + extraX, offsetY + extraY);
			parent.lastLeft = obj;
		end
	end

	--GHI_Message((profile.label or "nil")..": "..type(profile.OnLoad));
	if type(profile.OnLoad) == "function" then
		--local This = self;
		--this = obj;
		profile.OnLoad(obj);
		--self = This;
	end
	obj:Show();

	return height;
end

function GHM_CreateLine(num, profile, parent, offset)
	if type(profile) == "table" and type(offset) == "number" then
		local tallest = 0;
		local line = CreateFrame("Frame", parent:GetName() .. "_L" .. num, parent);
		local main = parent:GetParent();
		Warning("Inserted line " .. num .. " Start at " .. offset);
		line:SetPoint("TOPLEFT", parent:GetParent(), "TOPLEFT", main.frame_offset_x, offset);
		line:SetWidth(main.frame_x);
		line:SetHeight(20);

		if ShowLines == true then
			GHM_TempBG(line);
		end
		local i = 1;
		while type(profile[i]) == "table" do
			local height = GHM_CreateObject(i, profile[i], line);
			if height > tallest then
				tallest = height;
			end
			i = i + 1;
		end
		if tallest == 0 then -- force line height to 20
			tallest = 20;
		end
		line:Show();
		line:SetHeight(tallest);
		if main.lineDistance then
			offset = offset - tallest - main.lineDistance;
		else
			offset = offset - tallest - 3;
		end
	end
	return offset;
end

local urlMenuList;
local function CreatePage(num, profile, parent, lineSpacing)
	if type(profile) == "table" then
		local page = CreateFrame("Frame", parent:GetName() .. "_P" .. num, parent); Warning("Inserted page " .. num);
		local i = 1;
		local offset = -(parent.frame_offset_y or 0);
		lastestEditbox = nil
		while type(profile[i]) == "table" do --and -offset <((parent.frame_offset_y or 0) + (parent.frame_y or 0)) do

			offset = GHM_CreateLine(i, profile[i], page, offset);
			i = i + 1;
			offset = offset - lineSpacing;
		end
		parent.pageHeight = max(-(offset + lineSpacing), parent.pageHeight or 0);
		Warning("End of page after " .. (i - 1) .. " lines. " .. #(profile) .. " planned")
		if num == 1 then
			page:Show();

		else
			page:Hide();
		end

		-- help button
		if profile.help then
			if not(urlMenuList) then
				urlMenuList = GHI_MenuList("GHI_URLUI");
			end
			local loc = GHI_Loc();
			local button = CreateFrame("Button","$parentHelpButton",page,"GHM_Button_Template");
			button:SetPoint("BOTTOMLEFT",page:GetParent(),"BOTTOMLEFT",15,15);
			button:SetText(loc.HELP);
			button:SetScript("OnClick",function()
				local url = string.format("http://pilus.info/index.php?title=%s",profile.help);
				urlMenuList.New(url);
			end)

		end

		page.active = true;
		return page;
	end
end

local highest = -10;
local layerFrames = {};

function GHM_LayerHandle(frame)
	if frame:IsShown() then
		local i = 1;
		while i <= #(layerFrames) do
			local f = layerFrames[i];
			if f == frame or not (frame:IsShown()) then
				table.remove(layerFrames, i);
			else
				i = i + 1;
			end
		end
		table.insert(layerFrames, frame);
		for i, f in pairs(layerFrames) do
			f:SetFrameLevel(i * 10)
		end
	end
end



function GHM_NewFrame(self, profile)
      local loc = GHI_Loc()
	if type(profile) == "table" and type(profile.name) == "string" then
		--[[
		if _G[profile.name] then
			Warning("A frame named "..profile.name.." already exsists.");
			return _G[profile.name];
		end --]]
		local theme = profile.theme
		if not (theme) then
			theme = "StdTheme";
		end


		local main = CreateFrame("Frame", profile.name, UIParent, "GHM_" .. theme .. "_Template");
		if _G[profile.name .. "TitleString"] then
			_G[profile.name .. "TitleString"]:SetText(profile.title);
		end
		main.LabelData = {};
		main.LabelFrame = {};

		main.icon = icon;
		if profile.height then
			main:SetHeight(profile.height);
		end
		if profile.width then
			main:SetWidth(profile.width);
			main.frame_x = profile.width; -- - 100;
		end
		if theme == "SpellBookTheme" then
			main.frame_y = main:GetHeight() - (main.frame_offset_y + 120);
			local icon = _G[main:GetName() .. "Icon"];
			icon.SetIcon(icon, profile.icon);
		else
			main.frame_y = main:GetHeight()
		end

		--	function_ initlization
		main.RegisterLabel = function(label, frame) assert(not (type(label) == "table"), "a table?");
		if not (label == nil) then
			main.LabelFrame[label] = frame;
		end;
		end;
		main.SetLabel = function(label, data) if not (label == nil) then
			if not (main.LabelFrame[label]) then
				main.RegisterLabel(label, self);
			end
			main.LabelData[label] = data;
		end;
		end;
		main.GetLabel = function(label)
			if not (label == nil) then
				local frame = main.LabelFrame[label];
				if frame and frame.GetValue and not(frame.IgnoreGetValueFunc) then
					return frame:GetValue();
				else
					return main.LabelData[label];
				end
			end;
		end;
		main.ForceLabel = function(label, ...) if not (label == nil) then
			local f = main.LabelFrame[label];
			if f and type(f.Force) == "function" then
				f.Force(...);
			else print("Could not force label: ",label);
			end
			main.SetLabel(label, ...);
		end
		end;
		main.GetLabelFrame = function(label)
			return main.LabelFrame[label];
		end;
		main.ClearAll = function(self)
			for index, value in pairs(main.LabelFrame) do
				if type(value) == "table" and type(value.Clear) == "function" then
					value.Clear();
				end
			end
			if main.bn then
				main.currentPage = 1;
				main.UpdatePages();
			end
		end;
		main.GetAllLabels = function()
			local t = {}
			for i,v in pairs(main.LabelFrame) do
				table.insert(t,i);
			end
			return t;
		end

		main.pages = {};

		local i = 1;
		while type(profile[i]) == "table" do
			main.pages[i] = CreatePage(i, profile[i], main, profile.lineSpacing or 0);
			i = i + 1;
		end
		main.numPages = i - 1;
		main.currentPage = 1;
		main.autohide = profile.autohide;
		--print(main.currentPage)
		main.madeBy = self;
		--print("level ",main:GetFrameLevel());
		--main:SetFrameLevel(main:GetFrameLevel()+5);--issue

		if not (profile.height) then
			main:SetHeight(main.pageHeight);
		end

		-- function handling
		main.OnOk = function() end;
		if type(profile.OnOk) == "function" then
			main.OnOk = profile.OnOk;
		end

		if type(profile.OnShow) == "function" then
			--main:SetScript("OnShow",profile.OnShow);
			main.onShow = profile.OnShow; --changed due to layer handling
		end
		if type(profile.OnHide) == "function" then
			main.onHide = profile.OnHide; --changed due to layer handling
		end

		-- page and button handling
		if theme == "WizardTheme" or theme == "BlankWizardTheme" then
			main.bb = _G[main:GetName() .. "Back"];
			main.bn = _G[main:GetName() .. "Next"];

			-- setup handle
			main.UpdatePages = function(self)
				local pagesActive = {};
				for i,page in pairs(main.pages) do
					if page.active then
						table.insert(pagesActive,i);
					end
				end


				local currentIndex = 1;
				for index,pageIndex in pairs(pagesActive) do
					if main.currentPage == pageIndex then
						currentIndex = index;
						break;
					elseif main.currentPage < pageIndex then
						main.currentPage = pagesActive[index-1];
						currentIndex = index-1;
						break;
					end
				end

				if currentIndex == 1 then
					main.bb:Disable();
				else
					main.bb:Enable();
					main.bb.targetPage = pagesActive[currentIndex - 1];
				end
				main.bb:SetText(loc.BACK);

				if currentIndex == #(pagesActive) then
					main.bn:SetText(loc.FINISH);
					main.bn.targetPage = "ok";
				else
					main.bn:SetText(loc.NEXT);
					main.bn.targetPage = pagesActive[currentIndex + 1];
				end

				for i = 1, main.numPages do
					local p = main.pages[i];
					if i == main.currentPage then
						p:Show();
					else
						p:Hide();
					end
				end

				if main.OnPageChange then
					main.OnPageChange(main.currentPage);
				end
			end


			main.bb:SetScript("OnClick", function(self)
				local main = self:GetParent();
				main.currentPage = self.targetPage;
                    if DropDownList1:IsShown() then
                         DropDownList1:Hide();
                    end
				main.UpdatePages()
			end);

			main.bn:SetScript("OnClick", function(self)
				local main = self:GetParent();
				if self.targetPage == "ok" then
					main.OnOk(self);
					if not (main.autohide == false) then
						main:Hide();
                         end
                         if DropDownList1:IsShown() then
                              DropDownList1:Hide();
                         end
				else
					main.currentPage = self.targetPage;
					main.UpdatePages()
                         if DropDownList1:IsShown() then
                              DropDownList1:Hide();
                         end
				end
			end);

			main.SetPage = function(p)
				main.currentPage = p;
				main.UpdatePages();
			end

			main.ActivatePage = function(i)
				main.pages[i].active = true;
				main.UpdatePages();
			end

			main.DeactivatePage = function(i)
				main.pages[i].active = false;
				main.UpdatePages();
			end


			main.UpdatePages();
		elseif theme == "SpellBookTheme" then
			main.ok = _G[main:GetName() .. "Ok"];
			main.cancel = _G[main:GetName() .. "Cancel"];
			main.ok:SetScript("OnClick", function(self)
				local main = self:GetParent();
				main.OnOk(self);
				main:Hide();
				if not (main.autohide == false) then
					main:Hide();
				end
			end);
			local h = main:GetHeight();
			if h > 512 then
				_G[main:GetName() .. "BotLeft"]:SetHeight(h - 256);
				_G[main:GetName() .. "BotRight"]:SetHeight(h - 256);
				local yoff = floor((h - 512) / 3);
				main.ok:SetPoint("BOTTOM", main, "BOTTOM", -60, 90 + yoff);
				main.cancel:SetPoint("BOTTOM", main, "BOTTOM", 60, 90 + yoff);
			end
		elseif theme == "StdTheme" then
			main.ok = _G[main:GetName() .. "Ok"];
			main.cancel = _G[main:GetName() .. "Cancel"];
			main.ok:SetScript("OnClick", function(self)
				local main = self:GetParent();
				main.OnOk(self);
				main:Hide();
				if not (main.autohide == false) then
					main:Hide();
				end
			end);
		elseif theme == "BlankTheme" then
		end


		if profile.useWindow then
			local window = CreateFrame("Frame", nil, UIParent, "GHM_Window");
			window.settingUp = true;
			main.window = window;
			window:SetWidth(main:GetWidth() + 30);
			window.menu = main;
			window:SetHeight(main:GetHeight() + 30);

			-- TestWin:SetPoint("TOPRIGHT",TestWin:GetParent(),"CENTER");
			--window:SetPoint("CENTER",-5,0);

			window:SetDevMode(false);
			window:SetContent(main);
			window:SetTitle(profile.title);
			window:SetIcon(profile.icon);

			if type(profile.menuBar) == "table" then
				for i=1,#(profile.menuBar) do
					GHM_Toolbar(window.MenuBar, main, profile.menuBar[i]);
				end
				window:ShowMenuBar();
			else
				window:HideMenuBar();
			end

			if profile.statusBar then
				window:ShowStatusBar();
			else
				window:HideStatusBar();
			end

			local texture =  profile.background or GHM_GetBackground() or "Interface/DialogFrame/UI-DialogBox-Background"
			window.BgFrame:SetBackdrop({
				bgFile = texture,
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				tile = false,
				tileSize = 16,
				edgeSize = 16,
				insets = { left = 4, right = 4, top = 4, bottom = 4 }
			});

			window.BgFrame2:SetBackdrop({
				bgFile = "Interface\\AddOns\\GHI\\texture\\white.tga",
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				tile = false,
				tileSize = 16,
				edgeSize = 16,
				insets = { left = 4, right = 4, top = 4, bottom = 4 },
			});
			window.BgFrame2:SetBackdropColor(GHM_GetBackgroundColor());

			window.BgFrame:SetFrameLevel(window.BgFrame2:GetFrameLevel() + 1);
			window.TopBgFrame:SetFrameLevel(window.BgFrame:GetFrameLevel() + 1);
			window.TitleBar:SetFrameLevel(window.TopBgFrame:GetFrameLevel() + 1);


			-- Top bar
			window.TopBgFrame:SetBackdrop({
				edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
				tile = false,
				tileSize = 0,
				edgeSize = 16,
				insets = { left = 4, right = 4, top = 4, bottom = 0 }
			});
			window.TitleBar.bg = window.TitleBar:CreateTexture();
			window.TitleBar.bg:SetAllPoints(window.TitleBar);
			window.TitleBar.bg:SetTexture(GHM_GetTitleBarColor());
			window.TopBgFrame:SetFrameLevel(window.BgFrame:GetFrameLevel() + 1);


			window:SetFrameStrata("MEDIUM");

			--window.Height = window:GetHeight();
			--window.Width = window:GetWidth();

			main:SetScript("OnShow", function(self) GHM_LayerHandle(self.window or self); if self.onShow then self.onShow(self); end end);
			main:SetScript("OnHide", function(self) GHM_LayerHandle(self.window or self); if self.onHide then self.onHide(self); end end);
			main.ShowOrig = main.Show;
			main.Show = function(self) window:Show();
			window:ClearAllPoints();
			window:SetPoint("CENTER", 0, 0);
			main:ShowOrig()
			end;
			main.HideOrig = main.Hide;
			main.Hide = function(self) window:Hide(); main:HideOrig() end;

			main.AnimatedShow = function(self)
				self:Show();
				self.window:AnimatedShow();
			end

			--GHM_UpdateMenuStringColors(main);

			window.settingUp = false;

			return main;
		end


		main:ClearAllPoints()
		main:SetPoint("CENTER", UIParent, "CENTER", 0, 0);




		-- layer handling
		if main.onShow then
			main:SetScript("OnShow", function(self) GHM_LayerHandle(self); self.onShow(self); end);
		else
			main:SetScript("OnShow", function(self) GHM_LayerHandle(self); end);
		end
		main:SetScript("OnHide", function(self) GHM_LayerHandle(self); end);

		return main;
	end
end

local GetColorDiff = function(r1, g1, b1, r2, g2, b2)
	return abs(r1 - r2) + abs(g1 - g2) + abs(b1 - b2);
end

--[[
function GHM_UpdateMenuStringColors(frame)
	local children = { frame:GetChildren() };
	for _, child in ipairs(children) do
		GHM_UpdateMenuStringColors(child);
	end
	local regions = { frame:GetRegions() };
	for _, region in ipairs(regions) do
		if region:GetObjectType() == "FontString" then
			if GetColorDiff(1, 1, 1, region:GetTextColor()) < 0.02 then
				region:SetTextColor(GHM_GetDetailsTextColor());
			elseif GetColorDiff(1, 0.82, 0, region:GetTextColor()) < 0.02 then
				region:SetTextColor(GHM_GetHeadTextColor());
			end
		end
	end
end   --]]

--[[ Profile structure
For wizard:
	profile[x][y][z]   =  Info table about page x, line y, object z


]]
local iconSearchString = nil;
local iconTypeShown = 1; -- 1 SHOW_BOTH, 2 SHOW_STOCK, 3 SHOW_GHI
local iconCategory = 1;
local iconSubCategory = 1;
local icons = {};

function GHM_UpdateIconList()
	local searches = nil;
	wipe(icons);
	local subcategoryName = GHM_IconSubcategories[GHM_IconCategories[iconCategory]][iconSubCategory];
	local stockIconSelection = {};
	local customIconSelection = {}

	if (iconSearchString ~= nil) then
		searches = { string.split(" ", string.lower(iconSearchString)) };
		stockIconSelection = GHM_StockIcons;
		customIconSelection = GHM_GHIIcons;
	else
		stockIconSelection[subcategoryName] = GHM_StockIcons[subcategoryName];
		customIconSelection[subcategoryName] = GHM_GHIIcons[subcategoryName];
	end

	if (iconTypeShown == 1) or (iconTypeShown == 2) then
		for _, cat in pairs(stockIconSelection) do
			for _, icon in pairs(cat) do
				local match = true;
				if (searches ~= nil) then
					for _, search in pairs(searches) do
						if not (string.find(string.lower(icon), search)) then
							match = false;
							break;
						end
					end
				end
				if (match) then
					table.insert(icons, "Interface\\Icons\\" .. icon);
				end
			end
		end
	end
	if (iconTypeShown == 1) or (iconTypeShown == 3) then
		for _, cat in pairs(customIconSelection) do
			for _, icon in pairs(cat) do
				local match = true;
				if (searches ~= nil) then
					for _, search in pairs(searches) do
						if not (string.find(string.lower(icon), search)) then
							match = false;
							break;
						end
					end
				end
				if match then
					table.insert(icons, "Interface\\AddOns\\GHM\\GHI_Icons\\" .. icon);
				end
			end
		end
	end
end

function GHM_IconScrollbarOnShow(self)
	if self.updateInProgress then return end;
	local scrollFrame = self;

	local lines = floor(((table.getn(icons) + 1) / 4) + 0.5) - 3;
	if lines == nil then return; end
	self.updateInProgress = true;
	FauxScrollFrame_Update(scrollFrame, lines, 1, 16);
	local offset = FauxScrollFrame_GetOffset(scrollFrame);
	self.updateInProgress = false
	local iconFrame = self:GetParent();

	for i = 1, 16 do
		local frame = _G[iconFrame:GetName() .. "_PopupButton" .. i];
		local texture;
		local off = offset * 4 + i - #(GHM_StockIcons[category] or {});
		if icons[off] then
			texture = icons[off];
		else
			texture = nil;
		end

		if texture == nil then
			SetItemButtonTexture(frame, "");
			frame.path = "";
			frame:Hide();
		else
			frame:Show();
			SetItemButtonTexture(frame, texture);
			frame.path = texture;
			local tex = _G[frame:GetName().."IconTexture"]:GetTexture();
			if tex ~= texture then
				SetItemButtonTexture(frame, "");
			end
		end
	end
end

function GHM_SetCategory(iconFrame, category)
	local scroll = _G[iconFrame:GetName() .. "ScrollBar"];
	if (category ~= iconCategory) then
		iconCategory = category;
		iconSubCategory = 1;
		GHM_UpdateIconList(iconFrame);
		scroll:SetVerticalScroll(1);
		scroll:SetVerticalScroll(0);
	end
end

function GHM_SetSubCategory(iconFrame, subCategory)
	local scroll = _G[iconFrame:GetName() .. "ScrollBar"];
	if (subCategory ~= iconSubCategory) then
		iconSubCategory = subCategory;
		GHM_UpdateIconList();
		scroll:SetVerticalScroll(1);
		scroll:SetVerticalScroll(0);
	end
end

function GHM_SetSearchString(iconFrame, searchString)
	local scroll = _G[iconFrame:GetName() .. "ScrollBar"];
	if (searchString == "") then
		searchString = nil;
	end

	if (searchString ~= iconSearchString) then
		iconSearchString = searchString;
		GHM_UpdateIconList(iconFrame);
		scroll:SetVerticalScroll(1);
		scroll:SetVerticalScroll(0);
	end
end

function GHM_SetIconType(iconFrame, iconType)
	local scroll = _G[iconFrame:GetName() .. "ScrollBar"];
	if (iconType ~= iconTypeShown) then
		iconTypeShown = iconType;
		GHM_UpdateIconList(iconFrame);
		scroll:SetVerticalScroll(1);
		scroll:SetVerticalScroll(0);
	end
end

function GHM_SetUpRoundIcon(self, halfSize) --- Current issue
	local m = 1;
	if halfSize then m = 1.8; end
	--local self = _G[self];
	local res = 20
	Warning("Setting up round icon");
	local tex_x1 = 0.06;
	local tex_x2 = 0.94;
	local tex_y1 = 0.06;
	local tex_y2 = 0.94;
	local diameter = 58 / m;
	local fsize = diameter / res;
	local xunit = (tex_x2 - tex_x1) / res;
	local yunit = (tex_y2 - tex_y1) / res;

	--local c = 1;

	self:SetHeight(diameter);
	self:SetWidth(diameter);
	self:SetFrameLevel(0);


	--[ [ New
	local cir = {};
	local info = {};

	info = {};
	info.x_o = 3;
	info.x = 14;
	info.y_o = 3;
	info.y = 14;
	table.insert(cir, info);

	-- top
	info = {};
	info.x_o = 5;
	info.x = 10;
	info.y_o = 0;
	info.y = 1;
	table.insert(cir, info);

	info = {};
	info.x_o = 4;
	info.x = 12;
	info.y_o = 1;
	info.y = 1;
	table.insert(cir, info);

	info = {};
	info.x_o = 3;
	info.x = 14;
	info.y_o = 2;
	info.y = 1;
	table.insert(cir, info);



	-- left
	info = {};
	info.x_o = 2;
	info.x = 1;
	info.y_o = 3;
	info.y = 14;
	table.insert(cir, info);

	info = {};
	info.x_o = 1;
	info.x = 1;
	info.y_o = 4;
	info.y = 12;
	table.insert(cir, info);

	info = {};
	info.x_o = 0;
	info.x = 1;
	info.y_o = 5;
	info.y = 10;
	table.insert(cir, info);


	-- right
	info = {};
	info.x_o = 17;
	info.x = 1;
	info.y_o = 3;
	info.y = 14;
	table.insert(cir, info);

	info = {};
	info.x_o = 18;
	info.x = 1;
	info.y_o = 4;
	info.y = 12;
	table.insert(cir, info);

	info = {};
	info.x_o = 19;
	info.x = 1;
	info.y_o = 5;
	info.y = 10;
	table.insert(cir, info);

	-- buttom
	info = {};
	info.x_o = 5;
	info.x = 10;
	info.y_o = 19;
	info.y = 1;
	table.insert(cir, info);

	info = {};
	info.x_o = 4;
	info.x = 12;
	info.y_o = 18;
	info.y = 1;
	table.insert(cir, info);

	info = {};
	info.x_o = 3;
	info.x = 14;
	info.y_o = 17;
	info.y = 1;
	table.insert(cir, info);

	--]]

	for i = 1, #(cir) do
		local f = CreateFrame("Frame", self:GetName() .. i, self, "GHM_RoundIconPiece_Template");
		local icon = _G[f:GetName() .. "Icon"];
		local x = cir[i].x;
		local y = cir[i].y;
		local x_off = cir[i].x_o;
		local y_off = cir[i].y_o;


		f:SetHeight(fsize * y);
		f:SetWidth(fsize * x);
		f:SetPoint("TOPLEFT", self, "TOPLEFT", fsize * x_off, -fsize * y_off);

		icon:SetHeight(fsize * y);
		icon:SetWidth(fsize * x);
		icon:SetTexCoord(tex_x1 + xunit * x_off, tex_x1 + xunit * (x_off + x), tex_y1 + yunit * y_off, tex_y1 + yunit * (y_off + y));
		Warning("Created " .. f:GetName());
		Warning(tex_x1 + xunit * x_off .. " , " .. tex_x1 + xunit * (x_off + x) .. " , " .. tex_y1 + yunit * y_off .. " , " .. tex_y1 + yunit * (y_off + y))
	end
	self.numPieces = #(cir);

	self.SetIcon = function(icon, path)
		if not (path) then
			path = "Interface\\Icons\\INV_Misc_QuestionMark";
		end

		if icon then
			local n = icon:GetName();
			for i = 1, icon.numPieces do
				local f = _G[n .. i .. "Icon"];
				f:SetTexture(path);
			end
		end
	end

	--print("round icon set")
end



function GHM_ChatConfig_CreateCheckboxes(frame, checkBoxTable, checkBoxTemplate, title)
	local checkBoxNameString = frame:GetName() .. "CheckBox";
	local checkBoxName, checkBox, check;
	local width, height;
	local padding = 8;
	local text;
	local checkBoxFontString;

	frame.checkBoxTable = checkBoxTable;
	if (title) then
		_G[frame:GetName() .. "Title"]:SetText(title);
	end
	for index, value in ipairs(checkBoxTable) do
		--If no checkbox then create it
		checkBoxName = checkBoxNameString .. index;
		checkBox = _G[checkBoxName];
		if (not checkBox) then
			checkBox = CreateFrame("Frame", checkBoxName, frame, checkBoxTemplate);
		end
		if (not width) then
			width = checkBox:GetWidth();
			height = checkBox:GetHeight();
		end
		if (index > 1) then
			checkBox:SetPoint("TOPLEFT", checkBoxNameString .. (index - 1), "BOTTOMLEFT", 0, 0);
		else
			checkBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4);
		end
		if (value.text) then
			text = value.text;
		else
			text = _G[value.type];
		end
		if (value.noClassColor) then
			_G[checkBoxName .. "ColorClasses"]:Hide();
		end
		checkBox.type = value.type;
		checkBoxFontString = _G[checkBoxName .. "CheckText"];
		checkBoxFontString:SetText(text);
		check = _G[checkBoxName .. "Check"];
		check.func = value.func;
		check:SetID(index);
		check.tooltip = value.tooltip;
		if (value.maxWidth) then
			checkBoxFontString:SetWidth(0);
			if (checkBoxFontString:GetWidth() > value.maxWidth) then
				checkBoxFontString:SetWidth(value.maxWidth);
				check.tooltip = text;
				check.tooltipStyle = 0;
			end
		end

		-- extra
		if value.noCheck then
			check:Hide();
			checkBoxFontString:SetParent(checkBox);
			checkBoxFontString:SetPoint("LEFT", 5, 0);
		end

		--local swatch = _G[checkBoxName.."ColorSwatch"];
		checkBox.hasOpacity = value.hasOpacity;
		checkBox.a = 0;
		checkBox.OnColor = value.OnColor;
	end
	--Set Parent frame dimensions
	if (#checkBoxTable > 0) then
		frame:SetWidth(width + padding);
		frame:SetHeight(#checkBoxTable * height + padding);
	end
end



--[[

RC_List = {}
RC_List[1] = {}
RC_List[2] = {}
RC_List[3] = {}
RC_List[4] = {}
RC_List[5] = {}
RC_List[6] = {}
RC_List[7] = {}
RC_List[8] = {}
RC_List[1]["type"]="Script";
RC_List[1]["details"]="A script that do something";
RC_List[2]["type"]="GHR";
RC_List[2]["details"]="Stormwind Militia";
RC_List[2]["req"]=3;
RC_List[3]["type"]="Bag";
RC_List[3]["details"]="4 slots";
RC_List[3]["req"]=2;
RC_List[4]["type"]="Expression";
RC_List[4]["details"]="looks around.";
RC_List[5]["type"]="Expression";
RC_List[5]["details"]="For Stormwind.";
RC_List[6]["type"]="Random expression";
RC_List[6]["details"]="Six expressions";
RC_List[7]["req"]=1;
RC_List[7]["type"]="Script";
RC_List[7]["details"]="while( (drunk == true or drunk == false) and awake == true and self:GetNearstAleSupply():GetStorageAmount() > 0) do self.Drink(beer) end";
RC_List[8]["type"]="Letter/Book";
RC_List[8]["details"]="2 pages";
local obj = {};

TestProfile = {};
TestProfile.name = "GHM_Tester";
TestProfile.title = "Create new GHI item";
TestProfile.theme = "WizardTheme";
TestProfile.height = 512;
TestProfile.OnOk = function()  end
TestProfile.icon = "Interface\\Icons\\Trade_Engineering";

TestProfile[1] = {};
TestProfile[1].name = "Generel";
TestProfile[1][1] = {};
TestProfile[1][2] = {};
TestProfile[1][3] = {};
TestProfile[1][4] = {};
TestProfile[1][5] = {};
TestProfile[1][6] = {};
TestProfile[1][7] = {};
TestProfile[1][8] = {};
TestProfile[1][9] = {};
TestProfile[1][10] = {};


TestProfile[2] = {};
TestProfile[2].name = "Right Click";
TestProfile[2][1] = {};
TestProfile[2][2] = {};
TestProfile[2][3] = {};
TestProfile[2][4] = {};
TestProfile[2][5] = {};
TestProfile[2][6] = {};
TestProfile[2][7] = {};

local obj2 = {};

obj = {};
obj.type = "List";
obj.lines = 6;
obj.align = "c";
obj.label = "RCList";
obj2 = {};
obj2[1] = {}
obj2[1].type = "Icon";
obj2[1].catagory = "";
obj2[1].width = 20;
obj2[1].label = "icon";
obj2[2] = {}
obj2[2].type = "Text";
obj2[2].catagory = "Type";
obj2[2].width = 120;
obj2[2].label = "type";
obj2[3] = {}
obj2[3].type = "Text";
obj2[3].catagory = "Details";
obj2[3].width = 200;
obj2[3].label = "details";
obj2[4] = {}
obj2[4].type = "CycleButton";
obj2[4].cycles = {"Run Always","is forfilled","is not forfilled"};
obj2[4].catagory = "Run When Req.";
obj2[4].width = 100;
obj2[4].label = "req";
obj.column = obj2;
table.insert(TestProfile[2][2],obj);



obj = {};
obj.type = "Text";
obj.fontSize = 16;
obj.text = "General Item Info";
obj.align = "c";
table.insert(TestProfile[1][1],obj);

obj = {};
obj.type = "Text";
obj.fontSize = 11;
obj.text = "Buff";
obj.align = "l";
obj.width = 40
obj.singleLine = true;
table.insert(TestProfile[1][2],obj);

obj = {};
obj.type = "Text";
obj.fontSize = 11;
obj.text = "A Holy Blessing";
obj.align = "l";
obj.width = 80
obj.singleLine = true;
table.insert(TestProfile[1][2],obj);

obj = {};
obj.type = "Button";
obj.text = "Run Always";
obj.align = "l";
obj.label = "button1";
obj.compact = true;
obj.onclick = function()  end
obj.width = 80;
table.insert(TestProfile[1][2],obj);

obj = {};
obj.type = "Button";
obj.text = "Clicky";
obj.align = "r";
obj.label = "button2";
obj.compact = true;
obj.onclick = function()  end
obj.width = 50;
table.insert(TestProfile[1][2],obj);


obj = {};
obj.type = "Editbox";
obj.text = "Name:";
obj.align = "l";
obj.label = "name";
table.insert(TestProfile[1][3],obj);

obj = {};
obj.type = "QualityDD";
obj.text = "Quality:";
obj.align = "c";
obj.label = "quality";
table.insert(TestProfile[1][3],obj);

obj = {};
obj.type = "Icon";
obj.text = "Icon:";
obj.align = "r";
obj.label = "icon";
obj.framealign = "r";
obj.CloseOnChoosen = true;
table.insert(TestProfile[1][3],obj);

obj = {};
obj.type = "Editbox";
obj.text = "White text 1:";
obj.align = "c";
obj.label = "white1";
table.insert(TestProfile[1][4],obj);

obj = {};
obj.type = "Editbox";
obj.text = "White text 2:";
obj.align = "c";
obj.label = "white2";
table.insert(TestProfile[1][5],obj);

obj = {};
obj.type = "Editbox";
obj.text = "Yellow quoted text:";
obj.align = "c";
obj.label = "quote";
table.insert(TestProfile[1][6],obj);

obj = {};
obj.type = "Editbox";
obj.text = "Amount:";
obj.align = "r";
obj.label = "amount";
obj.width = 50;
obj.numbersOnly = true;
table.insert(TestProfile[1][7],obj);

obj = {};
obj.type = "StackSlider";
obj.text = "Stack Size:";
obj.align = "c";
obj.label = "stackSize";
table.insert(TestProfile[1][7],obj);

obj = {};
obj.type = "CheckBox";
obj.text = "Copyable by others";
obj.align = "l";
obj.label = "copyable";
table.insert(TestProfile[1][7],obj);

obj = {};
obj.type = "TimeSlider";
obj.text = "Item duration:";
obj.align = "c";
obj.label = "duration";
obj.values = {0,1,5,10,15,30,60,90,120,60*5,60*10,60*15,60*30,60*60,60*90,60*60*2,60*60*5,60*60*10,60*60*20,60*60*24,60*60*24*2,60*60*24*7,60*60*24*14,60*60*24*30,60*60*24*30*2,60*60*24*30*3,60*60*24*30*6,60*60*24*365}
table.insert(TestProfile[1][8],obj);

obj = {};
obj.type = "CheckBox";
obj.text = "Start duration when traded";
obj.align = "l";
obj.label = "durationWhenTraded";
table.insert(TestProfile[1][9],obj);

obj = {};
obj.type = "CheckBox";
obj.text = "Use real time, instead of played time for duration.";
obj.align = "c";
obj.label = "durationWhenTraded";
table.insert(TestProfile[1][9],obj);





obj = {};
obj.type = "Text";
obj.fontSize = 16;
obj.text = "Rightclick Actions";
obj.align = "c";
table.insert(TestProfile[2][1],obj);  --]]

--[[
obj = {};
obj.type = "Text";
obj.fontSize = 18;
obj.text = "CENTER!";
obj.align = "c";
obj.label = "headline";
table.insert(TestProfile[1][1],obj);

obj = {};
obj.type = "Text";
obj.fontSize = 11;
obj.text = "Left";
obj.align = "l";
obj.label = "string1";
table.insert(TestProfile[1][2],obj);

obj = {};
obj.type = "Editbox";
obj.text = "Name:";
obj.align = "c";
obj.label = "Name";
table.insert(TestProfile[1][3],obj);

obj = {};
obj.type = "Text";
obj.fontSize = 11;
obj.text = "After";
obj.align = "c";
obj.label = "string2";
table.insert(TestProfile[1][4],obj);


obj = {};
obj.type = "StackSlider";
obj.text = "Time to live:";
obj.align = "r";
obj.label = "stackSize";
table.insert(TestProfile[1][5],obj);

obj = {};
obj.type = "TimeSlider";
obj.text = "Name3:";
obj.align = "l";
obj.label = "time";
table.insert(TestProfile[1][6],obj);


obj = {};
obj.type = "CheckBox";
obj.text = "Choose";
obj.align = "r";
obj.label = "chosen";
table.insert(TestProfile[1][7],obj);

obj = {};
obj.type = "QualityDD";
obj.text = "Quality:";
obj.align = "c";
obj.label = "quality";
table.insert(TestProfile[1][8],obj);

obj = {};
obj.type = "Icon";
obj.text = "Icon:";
obj.align = "r";
obj.label = "icon";
obj.framealign = "r";
obj.CloseOnChoosen = true;
table.insert(TestProfile[1][8],obj);

obj = {};
obj.type = "Icon";
obj.text = "Icon:";
obj.align = "c";
obj.label = "icon";
obj.CloseOnChoosen = true;
table.insert(TestProfile[1][9],obj);


obj = {};
obj.type = "QualityDD";
obj.text = "Quality:";
obj.align = "r";
obj.label = "quality2";
obj.initPos = 4;
table.insert(TestProfile[1][12],obj);

obj = {};
obj.type = "Button";
obj.text = "Exit.";
obj.align = "l";
obj.label = "button1";
obj.compact = false;
obj.onclick = function() GHI_Message("clicked"); end
table.insert(TestProfile[1][13],obj);

obj = {};
obj.type = "Icon";
obj.text = "Icon:";
obj.align = "c";
obj.label = "icon";
obj.CloseOnChoosen = true;
table.insert(TestProfile[1][14],obj);

]]
