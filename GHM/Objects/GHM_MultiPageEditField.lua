--
--
--				GHM_MultiPageEditField
--  			GHM_MultiPageEditField.lua
--
--	          Text field editing multi-page text information.
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--


local codeFields = {};
local count = 1;
function GHM_MultiPageEditField(profile, parent, settings)
	
	local miscApi = GHI_MiscAPI().GetAPI();
	local actAPI = GHI_ActionAPI().GetAPI();
	local loc = GHI_Loc()
	local iconMenuList = GHM_IconPickerList()
	local imageMenuList = GHM_ImagePickerList()
	
	local frame = CreateFrame("Frame", "GHM_MultiPageEditField" .. count, parent, "GHM_MultiPageEditField_Template");
	count = count + 1;

	local label = _G[frame:GetName().."TextLabel"];
	label:SetText(profile.text or "");
	local areaFrame = _G[frame:GetName().."Area"];
	local fieldFrame = _G[frame:GetName().."AreaScrollText"];
	local navFrame = _G[areaFrame:GetName().."NavArea"]
	local prevButt = _G[navFrame:GetName().."PreviousPage"]
	local nextButt = _G[navFrame:GetName().."NextPage"]
	local befButt = _G[navFrame:GetName().."InsertBefore"]
	local aftButt = _G[navFrame:GetName().."InsertAfter"]
	local delButt = _G[navFrame:GetName().."DelPage"]
	local curPageNumFrame = _G[navFrame:GetName().."PageNumberFrameCurrentPageNumber"]
	local totalPageNumFrame = _G[navFrame:GetName().."PageNumberFrameTotalPageNumber"]
	
	frame.pages = {}
	frame.currentPage = 1
	----- Book Editing Functions
	
	function GHI_GetHighlightedText(frame)
		if not (frame) then return nil end
		local origText = frame:GetText();
		if not (origText) then return nil end
	
		frame:Insert("\127");
		local a = string.find(frame:GetText(), "\127");
		local dLen = math.max(0,string.len(origText)-string.len(frame:GetText())-1);
		frame:SetText(origText);
		frame:HighlightText(a - 1, a + dLen + 1);
		return a - 1, a + dLen + 1;
	end
	
	local function SavePage()
		local text = fieldFrame:GetText()
		frame.pages[frame.currentPage] = GHI_StringToHtml(text)	
	end
		
	local function SetPage()
		local text = frame.pages[frame.currentPage]
		fieldFrame:SetText(GHI_HtmlToString(text))
	end
	
	local function UpdatePageNumbers()
		totalPageNumFrame:SetText("of "..#frame.pages)
		curPageNumFrame:SetText(frame.currentPage.." ")
	end
	
	local function DeletePage()
		if frame.currentPage == 1 then
			frame.currentPage = frame.currentPage + 1
			table.remove(frame.pages,frame.currentPage - 1)
		else
			frame.currentPage = frame.currentPage - 1
			table.remove(frame.pages,frame.currentPage + 1)
		end		
		SetPage()
		UpdatePageNumbers()
	end
				
	local function GHI_AlignChoose(self,value)
		local ht1, ht2 = GHI_GetHighlightedText(fieldFrame);
		if ht1 and ht2 then
			local orig_text = fieldFrame:GetText();
			local t1, t2, t3;
			t1 = string.sub(orig_text, 0, ht1);
			t2 = string.sub(orig_text, ht1 + 1, ht2);
			t3 = string.sub(orig_text, ht2 + 1);
			text = t1 .. "<al="..value..">" .. t2 .. "</al>\n" .. t3;
			fieldFrame:SetText(text);
			fieldFrame:SetCursorPosition(ht2 + 6);
			self.AL = 0;
		else
	
			if self.AL == nil then
				self.AL = 0;
			end
			if self.AL == 0 then
				local text = fieldFrame:GetText();
				fieldFrame:SetText(text .. "<al="..value..">");
				self.AL = 1;
			else
				local text = fieldFrame:GetText();
				fieldFrame:SetText(text .. "</al>\n");
				self.AL = 0;
			end
		end
	end
	
	local function GHI_Book_InsertAttribute(self)
		local ht1, ht2 = GHI_GetHighlightedText(fieldFrame);
		if ht1 and ht2 then
			local orig_text = fieldFrame:GetText();
			local t1, t2, t3;
			t1 = string.sub(orig_text, 0, ht1);
			t2 = string.sub(orig_text, ht1 + 1, ht2);
			t3 = string.sub(orig_text, ht2 + 1);
			text = t1 .. "<Att>" .. t2 .. "</Att>" .. t3;
			fieldFrame:SetText(text);
			fieldFrame:SetCursorPosition(ht2 + 5);
			self.H1 = 0;	
		else	
			if self.H1 == nil then
				self.H1 = 0;
			end
			if self.H1 == 0 then
				local text = fieldFrame:GetText();
				fieldFrame:SetText(text .."<Att></Att>");
				self.H1 = 1;
			end
		end
		--miscApi.GHI_ColorString("Place Attribute to be inserted inside the tag. If the Attribute doesn't exist nothing will appear when book is shown.",0.5,0.5,0)
	end
	
	--[[local function GHI_Book_InsertVariable(self)
		local ht1, ht2 = GHI_GetHighlightedText(fieldFrame);
		if ht1 and ht2 then
			local orig_text = fieldFrame:GetText();
			local t1, t2, t3;
			t1 = string.sub(orig_text, 0, ht1);
			t2 = string.sub(orig_text, ht1 + 1, ht2);
			t3 = string.sub(orig_text, ht2 + 1);
			text = t1 .. "<Var>" .. t2 .. "</Var>" .. t3;
			fieldFrame:SetText(text);
			fieldFrame:SetCursorPosition(ht2 + 5);
			self.Var = 0;	
		else	
			if self.Var == nil then
				self.Var = 0;
			end
			if self.Var == 0 then
				local text = fieldFrame:GetText();
				fieldFrame:SetText(text .."<Var></Var>");
				self.Var = 1;
			end
		end
		miscApi.GHI_ColorString("Place Variable to be inserted inside the tag. If the Variable doesn't exist nothing will appear when book is shown.",0.5,0.5,0)
	end]]
		
	local function GHI_Book_H1OnClick(self, value)
		local ht1, ht2 = GHI_GetHighlightedText(fieldFrame);
		if ht1 and ht2 then
			local orig_text = fieldFrame:GetText();
			local t1, t2, t3;
			t1 = string.sub(orig_text, 0, ht1);
			t2 = string.sub(orig_text, ht1 + 1, ht2);
			t3 = string.sub(orig_text, ht2 + 1);
			text = t1 .. "<al="..value.."><H1>" .. t2 .. "</H1></al>\n" .. t3;
			fieldFrame:SetText(text);
			fieldFrame:SetCursorPosition(ht2 + 11);
			self.H1 = 0;	
		else	
			if self.H1 == nil then
				self.H1 = 0;
			end
			if self.H1 == 0 then
				local text = fieldFrame:GetText();
				fieldFrame:SetText(text .."<al="..value.. "><H1>");
				self.H1 = 1;
			else
				local text = fieldFrame:GetText();
				fieldFrame:SetText(text .. "</H2></al>\n");
				self.H1 = 0;
			end
		end
	end

	local function GHI_Book_H2OnClick(self, value)
		local ht1, ht2 = GHI_GetHighlightedText(fieldFrame);
		if ht1 and ht2 then
			local orig_text = fieldFrame:GetText();
			local t1, t2, t3;
			t1 = string.sub(orig_text, 0, ht1);
			t2 = string.sub(orig_text, ht1 + 1, ht2);
			t3 = string.sub(orig_text, ht2 + 1);
			text = t1 .. "<al="..value.."><H2>" .. t2 .. "</H2></al>\n" .. t3;
			fieldFrame:SetText(text);
			fieldFrame:SetCursorPosition(ht2 + 11);
			self.H2 = 0;	
		else	
			if self.H2 == nil then
				self.H2 = 0;
			end
			if self.H2 == 0 then
				local text = fieldFrame:GetText();
				fieldFrame:SetText(text .."<al="..value.. "><H2>");
				self.H2 = 1;
			else
				local text = fieldFrame:GetText();
				fieldFrame:SetText(text .. "</H2></al>\n");
				self.H2 = 0;
			end
		end
	end
	
	local function GHI_Book_InsertLink(page, linkText)
		if not (page) or not (linkText) then
			return;
		end
		local text = fieldFrame:GetText();
		if not text then text = ""; end
	
		local A = text .. "<A href=\34" .. page .. "\34>" .. linkText .. "</A>";
		fieldFrame:SetText(A);
	end
	----- Begin Link Edit Frame
	local linkMenuFrame
	local linkT = {
		{
			{
				{
					type = "Editbox",
					text = loc.ENTER_LINK_TEXT,
					align = "l",
					label = "linkText",
					texture = "Tooltip",
					width = 200,                  
				},
				{
					type = "Editbox",
					text = loc. ENTER_PAGE_NUMBER,
					align = "r",
					label = "linkPage",
					texture = "Tooltip",
					width = 48,
					numbersOnly = true,                   
				},
			},
			{
				{
					type = "Button",
					text = OKAY,
					align = "l",
					label = "ok",
					compact = false,
					OnClick = function(self)
						local page = linkMenuFrame.GetLabel("linkPage")
						local linkText = linkMenuFrame.GetLabel("linkText")
						GHI_Book_InsertLink(page, linkText)
						linkMenuFrame:Hide();
					end,
				},
				{
					type = "Button",
					text = CANCEL,
					align = "r",
					label = "cancel",
					compact = false,
					OnClick = function(obj)
						linkMenuFrame:Hide();
					end,
				},
			},
		},
		title = loc.INSERT_LINK,
		name = "GHI_BookLinkFrame"..count,
		theme = "BlankTheme",
		width = 300,
		height = 120,
		useWindow = true,
	}
	linkMenuFrame = GHM_NewFrame("LinkMenu", linkT);
	linkMenuFrame:SetScript("OnShow",function(self)
		linkMenuFrame.ForceLabel("linkText","")
		linkMenuFrame.ForceLabel("linkPage","")
	end)
	linkMenuFrame:Hide()
	----- Insert Color
	
	local function GHI_Book_InsertColor(color)
		local r,g,b = color.r or color[1], color.g or color[2], color.b or color[3]
		local text
		local ht1, ht2 = GHI_GetHighlightedText(fieldFrame);
		local colorTag = string.format("<Color=%s,%s,%s,>",r,g,b)
		
		if ht1 and ht2 then
			local orig_text = fieldFrame:GetText();
			local t1, t2, t3;
			
			t1 = string.sub(orig_text, 0, ht1);
			t2 = string.sub(orig_text, ht1 + 1, ht2);
			t3 = string.sub(orig_text, ht2 + 1);
			
			text = t1 .. colorTag .. t2 .. "</Color>" .. t3;
			fieldFrame:SetText(text);
			fieldFrame:SetCursorPosition(ht2 + 9);
			self.H2 = 0;	
		else	
			if self.H2 == nil then
				self.H2 = 0;
			end
			if self.H2 == 0 then
				local text = fieldFrame:GetText();
				fieldFrame:SetText(text .. colorTag .. "</Color>");
				self.H2 = 1;
			end
		end
	end	
	----- Confirm Delete Edit Frame
	local deleteT = {
		{
			{
				{
					type = "Button",
					text = OKAY,
					align = "l",
					label = "ok",
					compact = false,
					OnClick = function(self)
						if #frame.pages > 1 then
							SavePage()
							DeletePage()
							SavePage()
						else
							frame.currentPage = 1
							fieldFrame:SetText("")
							SavePage()
							SetPage()
						end
						deleteMenuFrame:Hide();
					end,
				},
				{
					type = "Button",
					text = CANCEL,
					align = "r",
					label = "cancel",
					compact = false,
					OnClick = function(obj)
						deleteMenuFrame:Hide();
					end,
				},
			},
		},
		title = loc.CONFIRM_DELETE_PAGE,
		name = "GHI_DeletePageFrame"..count,
		theme = "BlankTheme",
		width = 200,
		height = 60,
		useWindow = true,
	}
	deleteMenuFrame = GHM_NewFrame("DeleteFrame", deleteT);
	deleteMenuFrame:Hide()
	
	local logoMenuFrame
		
	local logoT = {
		{
			{
				{
					type = "Logo",
					text = "Logo:",
					label = "logo",
					align = "c",
				},
			},
			{
				{
					type = "Slider",
					text = "Alignment",
					label = "align",
					align = "c",
					width = 128,
					values = {"L","C","R"},
				},
			},
			{
				{
					type = "Button",
					text = OKAY,
					align = "l",
					label = "ok",
					compact = false,
					OnClick = function(self)
						local align = logoMenuFrame.GetLabel("align")
						local num = logoMenuFrame.GetLabel("logo")
						if num <= 9 then num = "0"..num end
						fieldFrame:Insert("<Icon," .. num .. "," .. align .. ">");
						logoMenuFrame:Hide();
					end,
				},
				{
					type = "Button",
					text = CANCEL,
					align = "r",
					label = "cancel",
					compact = false,
					OnClick = function(self)
						logoMenuFrame:Hide();
					end,
				},
			},
		},
		title = loc.INSERT_LOGO,
		name = "GHI_InsertLogoFrame"..count,
		theme = "BlankTheme",
		width = 200,
		height = 250,
		lineSpacing = 15,
		useWindow = true,
		OnShow = function()
			logoMenuFrame.ForceLabel("logo", 0)
			logoMenuFrame.ForceLabel("align", "C")
		end,
	}
	logoMenuFrame = GHM_NewFrame("LogoMenu", logoT);
	logoMenuFrame:Hide()
		
	UpdatePageNumbers()
			
	befButt:SetScript("OnClick", function(self)
		SavePage()
		table.insert(frame.pages,frame.currentPage -1,"")
		frame.currentPage = frame.currentPage + 1
		UpdatePageNumbers()
	end)
	
	aftButt:SetScript("OnClick", function(self)
		SavePage()
		table.insert(frame.pages,frame.currentPage + 1,"")
		UpdatePageNumbers()
	end)
	
	nextButt:SetScript("OnClick", function(self)
		PlaySound("igMainMenuOptionCheckBoxOn");
		SavePage()
		if frame.currentPage == #frame.pages then
			return
		else
			frame.currentPage = frame.currentPage +1
			SetPage()
			UpdatePageNumbers()
		end
	end)
	
	prevButt:SetScript("OnClick", function(self)
		PlaySound("igMainMenuOptionCheckBoxOn");
		SavePage()
		if frame.currentPage == 1 then
			return
		else
			frame.currentPage = frame.currentPage -1
			SetPage()
			UpdatePageNumbers()
		end
	end)
	
	delButt:SetScript("OnClick", function(self)
		PlaySound("igMainMenuOptionCheckBoxOn");
		deleteMenuFrame:Show()
	end)
	
	fieldFrame:SetScript("OnTextChanged", function()
		SavePage()	
	end)
	
	
	frame.field = fieldFrame;

	if profile.height then
		frame:SetHeight(profile.height);
	end
	if profile.width then
		frame:SetWidth(profile.width);
	end

	frame.GetPreferredDimensions = function()
		return profile.width, profile.height;
	end

	fieldFrame:SetWidth(frame:GetWidth()-33);

	-- toolbar buttons
	local toolbar = GHM_Toolbar(areaFrame,fieldFrame);
	toolbar:SetPoint("TOPLEFT",3,-3);
		
	local toolbarButtons
	local dropDownMenu = GHM_DropDownMenu()
	
	local HTMLtoolbarButtons = {
			{
				texture = "interface\\addons\\GHM\\Textures\\GHI_Book_Editor_Align",
				func = function()
					local DDmenuFrame = CreateFrame("Frame","AlignMenu",frame,"GHM_DropDownMenuTemplate")
					local menuList = {
							{text = loc.LEFT, func = function()GHI_AlignChoose(self,"l")end, notCheckable = true},
							{text = loc.CENTER, func = function()GHI_AlignChoose(self,"c")end, notCheckable = true,},
							{text = loc.RIGHT, func = function()GHI_AlignChoose(self,"r")end, notCheckable = true,},
						}
					dropDownMenu.EasyMenu(menuList, DDmenuFrame, "cursor",0,0,"MENU",0.5)
					DDmenuFrame:Show()
				end,
				tooltip = loc.ALIGNMENT,
			},
			{
				texture = "interface\\addons\\GHM\\Textures\\GHI_Book_Editor_H1",
				func = function()
					local DDmenuFrame = CreateFrame("Frame","H1AlignMenu",frame,"GHM_DropDownMenuTemplate")
					local menuList = {
							{text = loc.LEFT, func = function()GHI_Book_H1OnClick(self,"l")end, notCheckable = true},
							{text = loc.CENTER, func = function()GHI_Book_H1OnClick(self,"c")end, notCheckable = true,},
							{text = loc.RIGHT, func = function()GHI_Book_H1OnClick(self,"r")end, notCheckable = true,},
						}
					dropDownMenu.EasyMenu(menuList, DDmenuFrame, "cursor",0,0,"MENU",0.5)
					DDmenuFrame:Show()				
				end,
				tooltip = loc.HEADLINE_1,
			},
			{
				texture = "interface\\addons\\GHM\\Textures\\GHI_Book_Editor_H2",
				func = function()
					local DDmenuFrame = CreateFrame("Frame","H2AlignMenu",frame,"GHM_DropDownMenuTemplate")
					local menuList = {
							{text = loc.LEFT, func = function()GHI_Book_H2OnClick(self,"l")end, notCheckable = true},
							{text = loc.CENTER, func = function()GHI_Book_H2OnClick(self,"c")end, notCheckable = true,},
							{text = loc.RIGHT, func = function()GHI_Book_H2OnClick(self,"r")end, notCheckable = true,},
						}
					dropDownMenu.EasyMenu(menuList, DDmenuFrame, "cursor",0,0,"MENU",0.5)
					DDmenuFrame:Show()

				end,
				tooltip = loc.HEADLINE_2,
			},
			{
				texture = "interface\\addons\\GHM\\Textures\\GHI_Book_Editor_Link",
				func = function()
					linkMenuFrame:Show()				
				end,
				tooltip = loc.INSERT_LINK,
			},
			{
				texture = "interface\\addons\\GHM\\Textures\\GHI_Book_Editor_Image",
				tooltip = loc.INSERT_IMAGE,
				func = function()
					imageMenuList.New(function(selectedImage, selectedX, selectedY)
					local path = string.gsub(selectedImage,"\\","/");
					local imageText = string.format("\<img src\=%q align\=%q width\=%q height\=%q \/\>",path,"center",selectedX,selectedY)
					fieldFrame:Insert(imageText);
					end)
				end,
			},
			{
				texture = "interface\\addons\\GHM\\Textures\\GHI_Book_Editor_Icon",
				tooltip = loc.INSERT_ICON,
				func = function()
					iconMenuList.New(function(icon)
						local path = string.gsub(icon,"\\","/");
						local imageText = string.format("\<img src\=%q align\=%q width\=%q height\=%q \/\>",path,"center",64,64)
						fieldFrame:Insert(imageText);
					end);
				end,
			},
			{
				texture = "interface\\addons\\GHM\\Textures\\GHI_Book_Editor_Logo",
				tooltip = loc.INSERT_LOGO,
				func = function()
					logoMenuFrame:Show()
				end,
			},
			{
				texture = "interface\\addons\\GHM\\Textures\\GHI_Book_Editor_Att",
				tooltip = "Insert Attribute",
				func = function()
					GHI_Book_InsertAttribute(self)					
				end,
			},
			{
				texture = "interface\\addons\\GHM\\Textures\\GHI_Book_Editor_Color",
				func = function()
					GHM_ColorPickerList().New(function(color)
						GHI_Book_InsertColor(color)
						end)			
				end,
				tooltip = "Insert Color",
			},
		}
		if profile.HTMLtools then
			for _,toolbarButton in pairs(HTMLtoolbarButtons) do
				toolbar.AddButton(toolbarButton.texture,toolbarButton.func,toolbarButton.tooltip);
			end
		end
		
		if profile.toolbarButtons then
			toolbarButtons = profile.toolbarButtons
			for _,toolbarButton in pairs(toolbarButtons) do
				toolbar.AddButton(toolbarButton.texture,toolbarButton.func,toolbarButton.tooltip);
			end
		end

	-- functions
	local varAttFrame;

	local Force1 = function(data)
		if type(data) == "table" then
			frame.pages = data
			SetPage()
			UpdatePageNumbers()
		elseif type(data) == "string" then
			fieldFrame:SetText(data);
		end
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
			varAttFrame = GHM_VarAttInput(frame, areaFrame, frame:GetWidth());
			frame:SetHeight(frame:GetHeight());
		end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
	end

	frame.GetValue = function(self)
		if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
			return varAttFrame:GetValue();
		else
			return frame.pages
		end
	end

	frame.Insert = function(t)
		fieldFrame:Insert(t)
	end

	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end
	
	if profile.singlePage then
		navFrame:Hide()
	end
	
	frame.Clear();
	frame:Show();

	return frame;
end