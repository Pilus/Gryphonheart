
--===================================================
--					GHI Book UI
--					GHI_BookUI.lua
--					GHI_BookUI.xml
--
--			UI Implimentation for GHI Books
--		
-- 			(c)2013 The Gryphonheart Team
--				 All rights reserved
--===================================================

if not(GHI_FontList) then
	GHI_FontList = {
		["Morpheus"] = "Fonts\\MORPHEUS.TTF",
		["Frizqt"] = "Fonts\\FRIZQT__.TTF",
		["Arialn"] = "Fonts\\ARIALN.TTF",
		["Skurri"] = "Fonts\\SKURRI.TTF",
		["Alfabatix"] = "Interface\\Addons\\GHI\\Fonts\\ALFABET_.TTF",
		["Alako"] = "Interface\\Addons\\GHI\\Fonts\\Alakob.TTF",
		["Allura"] = "Interface\\Addons\\GHI\\Fonts\\Allura-Regular.TTF",
		["Astloch"] = "Interface\\Addons\\GHI\\Fonts\\Astloch-Regular.TTF",
		["Audiowide"] = "Interface\\Addons\\GHI\\Fonts\\Audiowide-Regular.TTF",
		["Badscript"] = "Interface\\Addons\\GHI\\Fonts\\Badscript-Regular.TTF",
		["Blkchcry"] = "Interface\\Addons\\GHI\\Fonts\\blkchcry.TTF",
		["Butcherman"] = "Interface\\Addons\\GHI\\Fonts\\Butcherman-Regular.TTF",
		["Condiment"] = "Interface\\Addons\\GHI\\Fonts\\Condiment-Regular.TTF",
		["Fredericka"] = "Interface\\Addons\\GHI\\Fonts\\FrederickatheGreat-Regular.TTF",
		["Frijole"] = "Interface\\Addons\\GHI\\Fonts\\Frijole-Regular.TTF",
		["GochiHand"] = "Interface\\Addons\\GHI\\Fonts\\GochiHand-Regular.TTF",
		["GreatVibes"] = "Interface\\Addons\\GHI\\Fonts\\GreatVibes-Regular.TTF",
		["Holy Empire"] = "Interface\\Addons\\GHI\\Fonts\\HOLY.TTF",
		["IMFellEnglish"] = "Interface\\Addons\\GHI\\Fonts\\IMFeENsc28P.TTF",
		["Killigrew"] = "Interface\\Addons\\GHI\\Fonts\\Killig.TTF",
		["LovedbytheKing"] = "Interface\\Addons\\GHI\\Fonts\\LovedbytheKing.TTF",
		["LoversQuarrel"] = "Interface\\Addons\\GHI\\Fonts\\LoversQuarrel-Regular.TTF",
		["Metamorphous"] = "Interface\\Addons\\GHI\\Fonts\\Metamorphous-Regular.TTF",
		["Miltonian"] = "Interface\\Addons\\GHI\\Fonts\\Miltonian-Regular.TTF",
		["Miniver"] = "Interface\\Addons\\GHI\\Fonts\\Miniver-Regular.TTF",
		["Nightshade"] = "Interface\\Addons\\GHI\\Fonts\\JimNightshade-Regular.TTF",
		["Norican"] = "Interface\\Addons\\GHI\\Fonts\\Norican-Regular.TTF",
		["Nosifer"] = "Interface\\Addons\\GHI\\Fonts\\Nosifer-Regular.TTF",
		["Novacut"] = "Interface\\Addons\\GHI\\Fonts\\Novacut.TTF",
		["OleoScript"] = "Interface\\Addons\\GHI\\Fonts\\OleoScript-Regular.TTF",
		["Rayando"] = "Interface\\Addons\\GHI\\Fonts\\rayando.TTF",
		["Renaissance"] = "Interface\\Addons\\GHI\\Fonts\\bdrenais.TTF",
		["Sarina"] = "Interface\\Addons\\GHI\\Fonts\\Sarina-Regular.TTF",
		["Shojumaru"] = "Interface\\Addons\\GHI\\Fonts\\Shojumaru-Regular.TTF",
		["Sniglet"] = "Interface\\Addons\\GHI\\Fonts\\Sniglet-Regular.TTF",
		["TradeWinds"] = "Interface\\Addons\\GHI\\Fonts\\TradeWinds-Regular.TTF",
	}
end

if not(GHI_Stationeries) then
	GHI_Stationeries = {
		["Orc"] = "Stationery\\Stationery_OG",
		["Tauren"] = "Stationery\\Stationery_TB",
		["Forsaken"] = "Stationery\\Stationery_UC",
		["Winter"] = "Stationery\\Stationery_Chr",
		["Illidari"] = "Stationery\\Stationery_Ill",
		["Vellum"] = "Stationery\\StationeryTest",
		["Auction"] = "Stationery\\AuctionStationery",
		["DeathKnightBlood"] = "TalentFrame\\DeathKnightBlood",
		["DeathKnightFrost"] = "TalentFrame\\DeathKnightFrost",
		["DeathKnightUnholy"] = "TalentFrame\\DeathKnightUnholy",
		["DruidBalance"] = "TalentFrame\\DruidBalance",
		["DruidFeral"] = "TalentFrame\\DruidFeral",
		["DruidRestoration"] = "TalentFrame\\DruidRestoration",
		["HunterBeastMastery"] = "TalentFrame\\HunterBeastMastery",
		["HunterMarksmanship"] = "TalentFrame\\HunterMarksmanship",
		["HunterSurvival"] = "TalentFrame\\HunterSurvival",
		["MageArcane"] = "TalentFrame\\MageArcane",
		["MageFire"] = "TalentFrame\\MageFire",
		["MageFrost"] = "TalentFrame\\MageFrost",
		["PaladinRetribution"] = "TalentFrame\\PALADINCOMBAT",
		["PaladinHoly"] = "TalentFrame\\PALADINHOLY",
		["PaladinProtection"] = "TalentFrame\\PALADINPROTECTION",
		["PriestDiscipline"] = "TalentFrame\\PriestDiscipline",
		["PriestHoly"] = "TalentFrame\\PriestHoly",
		["PriestShadow"] = "TalentFrame\\PriestShadow",
		["RogueAssassination"] = "TalentFrame\\RogueAssassination",
		["RogueCombat"] = "TalentFrame\\RogueCombat",
		["RogueSubtlety"] = "TalentFrame\\RogueSubtlety",
		["ShamanElemental"] = "TalentFrame\\ShamanElementalCombat",
		["ShamanEnhancement"] = "TalentFrame\\ShamanEnhancement",
		["ShamanRestoration"] = "TalentFrame\\ShamanRestoration",
		["WarlockAffliction"] = "TalentFrame\\WarlockCurses",
		["WarlockDestruction"] = "TalentFrame\\WarlockDestruction",
		["WarlockDemonology"] = "TalentFrame\\WarlockSummoning",
		["WarriorArms"] = "TalentFrame\\WarriorArms",
		["WarriorFury"] = "TalentFrame\\WarriorFury",
		["WarriorProtection"] = "TalentFrame\\WarriorProtection",
		["WarriorArm"] = "TalentFrame\\WarriorArm",
	}
end

if not(GHI_BookDefaults) then
	GHI_BookDefaults = {
		font = "Frizqt",
		N = 15,
		H1 = 24,
		H2 = 19,
		H1font = "Morpheus",
		H2font = "Morpheus",
		material = "Parchment",	
		}
end

local bookCount = 1

if not (GHI_BookList) then
	GHI_BookList = {}
end

function GHI_ShowBook(itemContainerGuid, itemSlotGuid, title, pages, edit, material, font, n, h1, h2, h1Font, h2Font, extraMat, cover, actionGuid)
	
	local api = GHI_ClassAPI().GetAPI();
	local containerList = GHI_ContainerList();
	local miscApi = GHI_MiscAPI().GetAPI();
	local loc = GHI_Loc();
	
	local currentStack
	local currentItem
	local GUID
	
	if itemContainerGuid == "Preview" then
		GUID = "Preview"
	elseif (itemContainerGuid) and (itemSlotGuid) then
		currentStack = containerList.GetStack(itemContainerGuid, itemSlotGuid);
		currentItem = currentStack.GetItemInfo()
		GUID = currentItem.GetGUID()
	end
	
	local frame
	local markFrame
	local scrollChild
		
	if GUID then
		if not (GHI_BookList[GUID]) then
			if bookCount > 4 then
				bookCount = bookCount - 4
				frame = _G["GHI_Book"..bookCount]
				frame:SetPoint("LEFT",UIParent,"LEFT",((frame:GetWidth() * (bookCount - 1)) + (10 * bookCount)),0)
					for i, v in pairs(GHI_BookList) do
						if v == "GHI_Book"..bookCount then
							GHI_BookList[i] = nil;
							break
						end
					end
				GHI_BookList[GUID] = frame:GetName()
				scrollChild = _G[frame:GetName().."ScrollFrameChild"]
				markFrame = _G[frame:GetName().."MarkFrame"]
				bookCount = bookCount + 1
			else
				if _G["GHI_Book"..bookCount] then
					frame = _G["GHI_Book"..bookCount]
					frame:SetPoint("LEFT",UIParent,"LEFT",((frame:GetWidth() * (bookCount - 1)) + (10 * bookCount)),0)
				else
					frame = CreateFrame("Frame","GHI_Book"..bookCount,UIParent,"GHI_Book_Template")
					frame:SetPoint("LEFT",UIParent,"LEFT",((frame:GetWidth() * (bookCount - 1)) + (10 * bookCount)),0)
				end
				GHI_BookList[GUID] = frame:GetName()
				scrollChild = _G[frame:GetName().."ScrollFrameChild"]
				markFrame = CreateFrame("EditBox",frame:GetName().."MarkFrame", scrollChild)
				bookCount = bookCount + 1
			end
		else
			local book = GHI_BookList[GUID]
			frame = _G[book]
			frame:SetPoint("LEFT",UIParent,"LEFT",((frame:GetWidth() * (bookCount - 1)) + (10 * bookCount)),0)
			scrollChild = _G[frame:GetName().."ScrollFrameChild"]
			markFrame = _G[frame:GetName().."MarkFrame"]
		end
	else
		frame = CreateFrame("Frame","GHI_Book"..bookCount,UIParent,"GHI_Book_Template")
		scrollChild = _G[frame:GetName().."ScrollFrameChild"]
		markFrame = CreateFrame("EditBox",frame:GetName().."MarkFrame", scrollChild)
		bookCount = bookCount + 1
	end
	
	local pageNumTotal = _G[frame:GetName().."PageNumberFrameTotalPageNumber"]
	local pageNumCurrent = _G[frame:GetName().."PageNumberFrameCurrentPageNumber"]
	local nextButton = _G[frame:GetName().."NextPageButton"]
	local prevButton = _G[frame:GetName().."PrevPageButton"]
	local markButton = _G[frame:GetName().."MarkButton"]
	local editButton = _G[frame:GetName().."EditButton"]
	local scrollFrame = _G[frame:GetName().."ScrollFrame"]
	local scrollChild = _G[frame:GetName().."ScrollFrameChild"]
	local textDisplay = _G[frame:GetName().."ScrollFrameChildPage"]
	local titleText = _G[frame:GetName().."TitleText"]
	local coverPage = _G[frame:GetName().."Cover"]

	frame.currentPage = 1
	
	frame.pages = {}

	if type(pages) == "string" then
		table.insert(frame.pages, pages)
	elseif type(pages) == "table" then
		if type(pages[1]) ==  "table" then
			local cleanPages = {}
			for i,v in pairs(pages) do
				local cleanPage = ""
				for textPart=1, 10 do
					local page = "text"..textPart 
					if pages[i][page] then
						cleanPage = cleanPage .. pages[i][page]
					end
				end
				table.insert(cleanPages,i,cleanPage)
			end
			frame.pages = cleanPages
		else
			frame.pages = pages
		end
	elseif type(pages) == nil then
		frame.pages = {"",}
	end
	frame.GUID = GUID
	frame.material = material or "Parchment"
	
	-- helper fucntions
	frame.IconsInPage = {}
	
	local function RGBPercToHex(r, g, b)
		r = tonumber(r)
		g = tonumber(g)
		b = tonumber(b)
		r = r <= 1 and r >= 0 and r or 0
		g = g <= 1 and g >= 0 and g or 0
		b = b <= 1 and b >= 0 and b or 0
		return string.format("%02x%02x%02x", r*255, g*255, b*255)
	end
	
	local function HexToRGBPerc(hex)
		local rhex, ghex, bhex = string.sub(hex, 1, 2), string.sub(hex, 3, 4), string.sub(hex, 5, 6)
		return tonumber(rhex, 16)/255, tonumber(ghex, 16)/255, tonumber(bhex, 16)/255
	end

	local function CheckForVariablesInPage(text)
		local varCount = 0
		local attCount = 0
		
		for w in string.gmatch(text, "<Var>") do
			varCount = varCount + 1
		end
		
		local varReplace
		for i=1, varCount do
			local a,b = strfind(text,"<Var>")
			if a then
				local c , d = strfind(text,"</Var>")
				if c then
					varReplace = string.sub(text,b+1,c-1)
					local var = GHI_MiscData.ScriptSave[varReplace]
					if var then
						text = string.gsub(text,"<Var>"..varReplace.."</Var>",var)
					else
						text = string.gsub(text,"<Var>"..varReplace.."</Var>","")
					end
				end
			end
		end
		
		for w in string.gmatch(text,"<Att>") do
			attCount = attCount +1
		end
		
		local attReplace
		for i=1, attCount do
			local a,b = strfind(text,"<Att>")
			if a then
				local c , d = strfind(text,"</Att>")
				if c then
					attReplace = string.sub(text,b+1,c-1)
					local att
					if currentStack then
						att = currentStack.GetAttribute(attReplace)
					else
						att = ""
					end
					if att then
						text = string.gsub(text,"<Att>"..attReplace.."</Att>",att)
					else
						text = string.gsub(text,"<Att>"..attReplace.."</Att>","")
					end
				end
			end
		end
		
		return text
	end

	-- <Color=0.5,0.5,0.5,> </Color>
	local function CheckForColors(text)
		text = CheckForVariablesInPage(text)
		local colorCount = 0
		for w in string.gmatch(text, "<Color=") do
			colorCount = colorCount + 1
		end
		
		for i = 1, colorCount do
			local a, b = strfind(text, "<Color=");
			-- find the icon in the text
			if a and b then
				local c, d = strfind(text, ",>", b);
				local data = string.sub(text, b + 1, c - 1);
				local r, g, b = strsplit(",", data);
				local hexCode = "&#124;cff"..RGBPercToHex(r,g,b)
				local colorTag = string.sub(text,a,d)
				text = string.gsub(text,colorTag,hexCode)	
			end
		end
		text = string.gsub(text,"</Color>","&#124;r")
		return text	
	end
	
	local function CheckForIconsInPage(text)
		text = CheckForColors(text)
		frame.IconsInPage = {}
		frame.IconsInPage.count = 0
		for i = 1, 5 do
			if (frame["logo"..i]) then
				frame["logo"..i]:Hide()
			end
			local a, b = strfind(text, "<Icon,");
			-- find the icon in the text
			if a and b then
				local c = strfind(text, ">", b);
				if c then
					local list = {};
					local data = string.sub(text, b + 1, c - 1);
					local num, align = strsplit(",", data);
					list.position = a;
					list.num = num;
					list.align = align;
					frame.IconsInPage[i] = list;
					text = string.sub(text, 0, a - 1) .. strsub(text, c + 1);
				end
			end
			frame.IconsInPage.text = text
		end
		
		local finalText = frame.IconsInPage.text;
		local a;
		local font, fontSize = textDisplay:GetFont();
		if not (fontSize) then return end
		fontSize = tonumber(fontSize);
		if not (fontSize) then return end

		local lines = floor((355 / fontSize) + 1)
		local rest = lines - (355 / fontSize);
		local emptyPageText = "";
		for i = 1, lines do
			emptyPageText = emptyPageText .. "<BR/>"
		end
		
		if frame.IconsInPage[1] then
			for i = 1 , 5 do
								
				GHI_Timer(function()
					if frame.IconsInPage[i] then
						frame.IconsInPage.count = frame.IconsInPage.count + 1
						if not (frame["logo"..i]) then
							frame["logo"..i] = CreateFrame("Frame",frame:GetName().."_Logo"..i,frame,"GHI_LogoTemplate")
						end
						local text = gsub(finalText, "</P></BODY></HTML>", "");
						local pos = frame.IconsInPage[i].position;
						if not pos then return end
						text = strsub(text, 0, pos - 1);
						text = text .. emptyPageText .. "end" .. "</P></BODY></HTML>";
						textDisplay:SetText(text);
						scrollFrame:UpdateScrollChildRect();
						if not (frame:IsShown()) then
							frame:Show()
						end
						
						frame.IconsInPage[i].ypos = scrollFrame:GetVerticalScrollRange();
						local data = frame.IconsInPage[i]

						frame["logo"..i]:ClearAllPoints()
						
						local num = data.num;
						local align = string.lower(data.align);
						local ypos = data.ypos;
						local material = frame.material;

						if (not material) then
							material = "Parchment";
						end
						
						local LeftPart = _G[frame["logo"..i]:GetName() .. "Left"];
						local RightPart = _G[frame["logo"..i]:GetName() .. "Right"];
						
						LeftPart:SetTexture("Textures\\GuildEmblems\\Emblem_" .. num)
						RightPart:SetTexture("Textures\\GuildEmblems\\Emblem_" .. num)

						if align == "r" then
							frame["logo"..i]:SetPoint("RIGHT", textDisplay, "TOPRIGHT", 25, -ypos);
						elseif align == "c" then
							frame["logo"..i]:SetPoint("CENTER", textDisplay, "TOP", 0, -ypos);
						else
							frame["logo"..i]:SetPoint("LEFT", textDisplay, "TOPLEFT", -25, -ypos);
						end

						frame["logo"..i]:SetParent(textDisplay);

						local textColor = GetMaterialTextColors(material);
						
						LeftPart:SetVertexColor(textColor[1], textColor[2], textColor[3]);
						RightPart:SetVertexColor(textColor[1], textColor[2], textColor[3]);

						frame["logo"..i]:Show();
						textDisplay:SetText(text)
					end
				end,0.1, true)
			end
		end

		return finalText
	end

	local standardFont = (font and font.GetFont and font.GetFont()) or font;
	local tpc = GHI_TextPositionCalculator(textDisplay:GetWidth(), standardFont, n, standardFont, h1, standardFont, h2);
	local function HandleObjectsInPage(text)
		local ptrn = "\124T:[^\124]*\124t";
		local i = string.find(text,ptrn);
		while i do
			local match = string.match(strsub(text,i))
			local obj = GHI_BookObj();
			obj.InitializeFromTextCode(match);

			local h,w = obj.GetSize();
			tpc.CalculatePos(strsub(text,0,i-1),w,h,function(x,y)
				obj:SetParent(textDisplay);
				obj:SetPoint("BOTTOMLEFT",textDisplay,"TOPLEFT",x,y);
			end)

			-- Find next
			i = string.find(text,ptrn,i+1);
		end
	end
	
	local function SetPage(p)
		frame.currentPage = p
		local text = frame.pages[p]
		text = CheckForIconsInPage(text)
		-- Handle objects in the page
		--HandleObjectsInPage(text); -- Broken

		local logoCount = frame.IconsInPage.count
		GHI_Timer(function()
			textDisplay:SetText(text)
			pageNumTotal:SetText("of "..#frame.pages)
			pageNumCurrent:SetText(frame.currentPage.." ")
		end,((logoCount/10) + 0.1),true)
	end
	
	local function SetMaterial(material, extraMat)
		local materialParts = {"TopLeft", "TopRight", "BotLeft", "BotRight"}
		local matPart
		local stat1 = _G[frame:GetName().."Stationery1"]
		local stat2 =_G[frame:GetName().."Stationery2"]
		
		if  material == "Parchment" then
			stat1:Hide()
			stat2:Hide()
			for i, v in pairs(materialParts) do
				local part = "Material"..v
				matPart = _G[frame:GetName()..part]
				matPart:Hide()
			end
		else
			stat1:Hide()
			stat2:Hide()
			for i, v in pairs(materialParts) do
				matPart = _G[frame:GetName().."Material"..v]
				matPart:Show()
				matPart:SetTexture("Interface\\ItemTextFrame\\ItemText-"..material.."-"..v)
			end
		end
		
		if extraMat then
			for i, v in pairs(materialParts) do
				local part = "Material"..v
				matPart = _G[frame:GetName()..part]
				matPart:Hide()
			end
			local append1, append2
			if string.find(GHI_Stationeries[extraMat],"Stationery") then
				append1 = "1"
				append2 = "2"
			else
				append1 = "-TopLeft"
				append2 = "-TopRight"
			end
			stat1:SetTexture("Interface\\"..GHI_Stationeries[extraMat]..append1)
			stat2:SetTexture("Interface\\"..GHI_Stationeries[extraMat]..append2)
			stat1:Show()
			stat2:Show()
		end
		
	end
	
	local function DisplayCover(cover)

		if type(cover) == "nil" then
			frame.coverPage:Hide()
		elseif type(cover) == "table" then
			local bg = cover.bg
			local bgColor = cover.bgColor
			local coverLogo = cover.logo
			local coverTitle = title
			local coverColor = cover.color
			
			local colors = miscApi.GHI_GetColors()
			local bgTex = _G[coverPage:GetName().."Background"]
			local imageLogo = _G[coverPage:GetName().."ImageLogo"]
			local LeftPart = _G[coverPage:GetName().."Left"]
			local RightPart = _G[coverPage:GetName().."Right"]
			local titleArea1 = _G[coverPage:GetName().."Title1"]
			local titleArea2 = _G[coverPage:GetName().."Title2"]
			
			if type(bg) == "string" then
				bgTex:SetTexture("Interface\\Addons\\GHI\\texture\\Covers\\GHI_Cover_"..bg)
			else
				bgTex:SetColorTexture(1,1,1,1)
			end
			
			if type(bgColor) == "string" then
				local r,g,b = colors[bgColor].r, colors[bgColor].g, colors[bgColor].b
				bgTex:SetVertexColor(r,g,b,1)
			elseif type(bgColor) == "table" then
				local r,g,b = bgColor.r or bgColor[1], bgColor.g or bgColor[2], bgColor.b or bgColor[3]
				bgTex:SetVertexColor(r,g,b,1)
			else
				bgTex:SetVertexColor(0.85,0.05,0.25,1)
			end
			
			local typeFace, typeHeight = textDisplay:GetFont("H1")
			
			local title1 = ""
			local title2 = ""
			
			if string.find(title, ":") then
				title1, title2 = strsplit(":",title)
				titleArea1:SetText(title1..":")
				titleArea2:SetText(title2)
			elseif strlen(title) > 20 then
				local titleParts = {}				
				for word in string.gmatch(title, "%w+") do
					table.insert(titleParts,word)
				end
				
				local wordsPerLine = math.floor(#titleParts / 2)
				for i = 1, wordsPerLine do
					title1 = title1..titleParts[i].." "
				end
				for i = 1, (#titleParts - wordsPerLine) do
					if i ~= (#titleParts - wordsPerLine) then
						title2 = title2..titleParts[(wordsPerLine + i)].." "
					else
						title2 = title2..titleParts[(wordsPerLine + i)]
					end
				end
				titleArea1:SetText(title1)
				titleArea2:SetText(title2)
			else
				titleArea1:SetText(title)
			end
					
			titleArea1:SetFont(typeFace, typeHeight)
			titleArea1:SetWordWrap(true)
			titleArea1:SetJustifyH("CENTER")
			titleArea1:SetJustifyV("BOTTOM")
			
			titleArea2:SetFont(typeFace, typeHeight)
			titleArea2:SetWordWrap(true)
			titleArea2:SetJustifyH("CENTER")
			titleArea2:SetJustifyV("TOP")
			
			
			if type(coverLogo) == "string" then
				imageLogo:Show()
				LeftPart:Hide()
				RightPart:Hide()

				imageLogo:SetTexture(coverLogo)
			elseif type(coverLogo) == "number" then
				if coverLogo <= 9 then
					coverLogo = "0"..coverLogo
				end
				imageLogo:Hide()
				LeftPart:Show()
				RightPart:Show()

				LeftPart:SetTexture("Textures\\GuildEmblems\\Emblem_" .. coverLogo);
				RightPart:SetTexture("Textures\\GuildEmblems\\Emblem_" .. coverLogo);
			end
			
			if type(coverColor) == "string" then
				local r,g,b = colors[coverColor].r, colors[coverColor].g, colors[coverColor].b
				imageLogo:SetDesaturated(true)
				imageLogo:SetVertexColor(r,g,b,1)
				LeftPart:SetVertexColor(r,g,b,1)
				RightPart:SetVertexColor(r,g,b,1)
				titleArea1:SetTextColor(r,g,b,1)
				titleArea2:SetTextColor(r,g,b,1)
			elseif type(coverColor) == "table" then
				local r,g,b = coverColor.r or coverColor[1], coverColor.g or coverColor[2], coverColor.b or coverColor[3]
				imageLogo:SetDesaturated(true)
				imageLogo:SetVertexColor(r,g,b,1)
				LeftPart:SetVertexColor(r,g,b,1)
				RightPart:SetVertexColor(r,g,b,1)
				titleArea1:SetTextColor(r,g,b,1)
				titleArea2:SetTextColor(r,g,b,1)
			else
				imageLogo:SetDesaturated(true)
				imageLogo:SetVertexColor(1,1,1,1)
				LeftPart:SetVertexColor(1,1,1,1)
				RightPart:SetVertexColor(1,1,1,1)
				titleArea1:SetTextColor(1,1,1,1)
				titleArea2:SetTextColor(1,1,1,1)		
			end
			
			coverPage:SetScript("OnClick", function(self)
				self:Hide()
				nextButton:Show()
				prevButton:Show()
			end)

			coverPage:SetScript("OnShow",function(self)
				self:SetFrameStrata("HIGH")
				nextButton:Hide()
				prevButton:Hide()
			end)
		end
	end
	
	local function TextDisplaySettings(font, h1Font, h2Font, n, h1, h2, material)
		if not(font) or font == nil or font == "nil" then font = GHI_BookDefaults.font	end
		if string.find(font,".TTF") or string.find(font,".ttf") then
			for i,v in pairs(GHI_FontList) do
				if v == font then
					font = i
					break
				end
			end
		end
		if not(h1) then h1 = GHI_BookDefaults.H1 end
		if not(h2) then h2 = GHI_BookDefaults.H2 end
		if not(n) then n = GHI_BookDefaults.N end
		if not (h1Font) then h1Font = font end
		if not (h2Font) then h2Font = h1Font end

		local typeFace = GHI_FontList[font]
		local typeFaceH1 = GHI_FontList[h1Font]
		local typeFaceH2 = GHI_FontList[h2Font]
		local textColor = GetMaterialTextColors(material)
		textDisplay:SetFont(typeFace, n)
		textDisplay:SetTextColor(textColor[1], textColor[2],textColor[3])
		textDisplay:SetFont("H1",typeFaceH1,h1)
		textDisplay:SetTextColor("H1",textColor[1], textColor[2],textColor[3])
		textDisplay:SetFont("H2",typeFaceH2,h2)
		textDisplay:SetTextColor("H2",textColor[1], textColor[2],textColor[3])
	end

	-- Material Settings
	if not(material) or material == "nil" or material == nil then material = GHI_BookDefaults.material end
	
	SetMaterial(material, extraMat)
	TextDisplaySettings(font, h1Font, h2Font, n, h1, h2, material)
	if (cover) then
		DisplayCover(cover)
	end

	-- Mark Frame
	markFrame:SetFontObject("SystemFont_Med1")
	local matType = frame.material
	local textColor = GetMaterialTextColors(matType)
	markFrame:SetTextColor(textColor[1], textColor[2],textColor[3])
	markFrame:SetAllPoints(textDisplay)
	markFrame:SetMultiLine(true)
	markFrame:SetAutoFocus(false)
	markFrame:Hide()

	-- Widget Scripts
	nextButton:SetScript("OnClick", function(self)
		PlaySound("igMainMenuOptionCheckBoxOn");
		markFrame:Hide()
		textDisplay:Show()
		if frame.currentPage == #frame.pages then
			return
		else
			frame.currentPage = frame.currentPage +1
			SetPage(frame.currentPage)
		end
	end)
	
	prevButton:SetScript("OnClick", function(self)
		PlaySound("igMainMenuOptionCheckBoxOn");
		markFrame:Hide()
		textDisplay:Show()
		if frame.currentPage == 1 then
			return
		else
			frame.currentPage = frame.currentPage -1
			SetPage(frame.currentPage)
		end
	end)
	
	markFrame:SetScript("OnShow", function()
		markFrame:SetText(GHI_HtmlToString(frame.pages[frame.currentPage]))
		markFrame.text = markFrame:GetText()
	end)
	markFrame:SetScript("OnTextChanged", function(self, user)
		if user == true then
			markFrame:SetText(markFrame.text)
		end
	end)

	markButton.tooltip = "Mark Text"
	markButton:SetScript("OnClick", function(self)
		PlaySound("igMainMenuOptionCheckBoxOn");
		if not(markFrame:IsShown()) then
			markFrame:Show()
			textDisplay:Hide()
			scrollFrame:UpdateScrollChildRect()
		else
			markFrame:Hide()
			textDisplay:Show()
			scrollFrame:UpdateScrollChildRect()
		end
	end)
	
	editButton.tooltip = "Edit Book Item"--loc.EDIT_BOOK
	editButton:Hide()
	if edit == 1 or edit == true then
		editButton:Show()
	end
	
	editButton:SetScript("OnClick", function(self)
		local contanerAPI = GHI_ContainerAPI().GetAPI()
		local itemList = GHI_ItemInfoList();
		local bookItem = itemList.GetItemInfo(GUID)
		local advancedItemMenuList = GHI_AdvancedItemMenuList();
		
		if bookItem.GetItemComplexity() == "standard" then
			frame:Hide()

			-- Locate the action
			local item = itemList.GetItemInfo(GUID).CloneItem();
			local action;
			for i=1,item.GetSimpleActionCount() do
				local a = item.GetSimpleAction(i);
				if a.GetGuid() == actionGuid then
					action = a;
				end
			end

			if action then
				if GH_TestFeature() then
					GHI_MenuList("GHI_BookEditor").Edit(action, item);
				else
					-- Show the edit book action menu, without any edit item menu.
					local menu = GHI_BookMenu(function()
						item.IncreaseVersion(true);
						itemList.UpdateItem(item);
						GHI_MiscData.lastUpdateItemTime = GetTime();
					end,action);
				end
			else
				print("Book action not found");
			end
		else
			advancedItemMenuList.Edit(GUID)
			frame:Hide()
		end			

	end)
	
	textDisplay:SetScript("OnHyperlinkEnter",function(self,p)
		GameTooltip:SetOwner(self)
		GameTooltip:SetAnchorType("ANCHOR_CURSOR" , 0, 0)
		GameTooltip:ClearLines();
		GameTooltip:SetText("Go to Page: "..p, 0.95,0.95,0.95)
		GameTooltip:Show()
	end)
	
	textDisplay:SetScript("OnHyperlinkLeave",function(self, p)
		GameTooltip:Hide()
	end)
	
	textDisplay:SetScript("OnHyperlinkClick", function(self, p)
		GameTooltip:Hide()
		p = tonumber(p)
		GHI_Timer(function()
		SetPage(p)
		end,0.2,true)
	end)
	
	frame:SetScript("OnShow", function()
		if (cover)then
			coverPage:Show()
		end
	end)
	-- Final Setup
	
	titleText:SetText(title or "")
	SetPage(1)
	-- Show Book
	scrollFrame:UpdateScrollChildRect()
	frame:Show()
end

function GHI_HtmlToString(text)
	if text == nil then
		return "";
	end
	text = string.gsub(text, "<HTML>", "");
	text = string.gsub(text, "</HTML>", "");
	text = string.gsub(text, "<BODY>", "");
	text = string.gsub(text, "</BODY>", "");

	text = string.gsub(text, "&quot;", "\"");
	text = string.gsub(text, "&gt;", ">");
	text = string.gsub(text, "&lt;", "<");
	text = string.gsub(text, "&amp;", "&");
	
	text = string.gsub(text, "</P><P align=\"center\">", "<al=c>");
	text = string.gsub(text, "</P><P align=\"right\">", "<al=r>");
	text = string.gsub(text, "</P><P align=\"left\">", "<al=l>");

	text = string.gsub(text, "</P><P>", "</al>\n");
	text = string.gsub(text,"</H2><P>", "</H2></al>\n");
	text = string.gsub(text,"</H1><P>", "</H1></al>\n");

	text = string.gsub(text, "<H1 align=\"center\">", "<al=c><H1>");
	text = string.gsub(text, "<H1 align=\"left\">", "<al=l><H1>");
	text = string.gsub(text, "<H1 align=\"right\">", "<al=r><H1>");
	
	text = string.gsub(text, "<H2>","<al=l><H2>")
	text = string.gsub(text, "<H2 align=\"center\">", "<al=c><H2>");
	text = string.gsub(text, "<H2 align=\"left\">", "<al=l><H2>");
	text = string.gsub(text, "<H2 align=\"right\">", "<al=r><H2>");	

	text = string.gsub(text, "<P>", "");
	text = string.gsub(text, "</P>", "");
	text = string.gsub(text, "<BR/>", "\n");

	return text;
end

function GHI_StringToHtml(text)
	if text == nil then
		return "";
	end

	--- Clear
	text = string.gsub(text, "<HTML>", "");
	text = string.gsub(text, "</HTML>", "");
	text = string.gsub(text, "<BODY>", "");
	text = string.gsub(text, "</BODY>", "");
	text = string.gsub(text, "<P>", "");
	text = string.gsub(text, "</P>", "");

	text = string.gsub(text, "</H1>\n", "</H1>");
	text = string.gsub(text, "</H2>\n", "</H2>");
	text = string.gsub(text, "</al>\n", "</al>");

	--- clear text for special symbols
	text = string.gsub(text, "&", "&amp;");
	text = string.gsub(text, ">", "&gt;");
	text = string.gsub(text, "<", "&lt;");
	text = string.gsub(text, "\"", "&quot;");
	--	reformat 
	
	text = string.gsub(text, "&lt;al=c&gt;&lt;H1&gt;", "</P><H1 align=\"center\">");
	text = string.gsub(text, "&lt;al=l&gt;&lt;H1&gt;", "</P><H1 align=\"left\">");
	text = string.gsub(text, "&lt;al=r&gt;&lt;H1&gt;", "</P><H1 align=\"right\">");
	text = string.gsub(text, "&lt;/H1&gt;&lt;/al&gt;", "</H1><P>");
	
	text = string.gsub(text, "&lt;al=c&gt;&lt;H2&gt;", "</P><H2 align=\"center\">");
	text = string.gsub(text, "&lt;al=l&gt;&lt;H2&gt;", "</P><H2 align=\"left\">");
	text = string.gsub(text, "&lt;al=r&gt;&lt;H2&gt;", "</P><H2 align=\"right\">");
	text = string.gsub(text, "&lt;/H2&gt;&lt;/al&gt;", "</H2><P>");

	text = string.gsub(text, "&lt;H1&gt;", "</P><H1 align=\"center\">");
	text = string.gsub(text, "&lt;/H1&gt;", "</H1><P>");
	text = string.gsub(text, "&lt;H2&gt;", "</P><H2>");
	text = string.gsub(text, "&lt;/H2&gt;", "</H2><P>");
	text = string.gsub(text, "\n", "<BR/>");

	text = string.gsub(text, "&lt;al=c&gt;", "</P><P align=\"center\">");
	text = string.gsub(text, "&lt;al=l&gt;", "</P><P align=\"left\">");
	text = string.gsub(text, "&lt;al=r&gt;", "</P><P align=\"right\">");

	text = string.gsub(text, "&lt;/al&gt;", "</P><P>");

	--   links
	text = string.gsub(text, "&lt;A href=&quot;", "<A href=\"");
	text = string.gsub(text, "&quot;&gt;", "\">");
	text = string.gsub(text, "&lt;/A&gt;", "</A>");

	-- icons
	text = string.gsub(text, "&lt;Icon,", "<Icon,");
	text = string.gsub(text, ",L&gt;", ",L>");
	text = string.gsub(text, ",R&gt;", ",R>");
	text = string.gsub(text, ",C&gt;", ",C>");
	
	-- colors
	
	text = string.gsub(text,"&lt;Color=","<Color=");
	text = string.gsub(text,",&gt;",",>")
	text = string.gsub(text,"&lt;/Color&gt;","</Color>")

	-- pictures
	text = string.gsub(text, "&lt;img(.-)/&gt;", function(t) t = string.gsub(t, "&quot;", "\""); return ("</P><img" .. t .. "/><P>"); end)
	
	-- Variable
	text = string.gsub(text, "&lt;Var&gt;","<Var>")
	text = string.gsub(text,"&lt;/Var&gt;","</Var>")
	-- Attribute
	text = string.gsub(text, "&lt;Att&gt;","<Att>")
	text = string.gsub(text,"&lt;/Att&gt;","</Att>")

	text = "<HTML><BODY><P>" .. text .. "</P></BODY></HTML>";
	return text;
end

-- Transcribe
function GHI_TranscribeTextItem()
	local loc = GHI_Loc()
	local itemList = GHI_ItemInfoList();
	local guidCreator = GHI_GUID();
	local containerList = GHI_ContainerList();
		
	local item = GHI_ItemInfo({
			authorName = UnitName("player"),
			authorGuid = GHUnitGUID("player"),
			guid = guidCreator.MakeGUID();
		});

	local creator = ItemTextGetCreator();
	local title = ItemTextGetItem();
	item.SetName(title)
	
	local font = GHI_BookDefaults.font
	
	local mat = ItemTextGetMaterial();
		if not (mat) then mat = GHI_BookDefaults.material end
		
		if mat == "Parchment" or not (mat) then
			item.SetWhite1("Book")
			item.SetUseText("Read the Book")
			item.SetIcon("Interface\\Icons\\INV_Misc_Book_08")
			font = "Fonts\\FRIZQT__.TTF"
		else
			item.SetWhite1(loc.INSCRIPTION)
			item.SetUseText("Read Inscription")
			item.SetIcon("Interface\\Icons\\INV_Misc_Note_01")
			font = "Fonts\\FRIZQT__.TTF"
			if GetMinimapZoneText() then
				item.SetComment("Found in " .. GetMinimapZoneText())
			end
		end

	if creator then
		item.SetWhite1(loc.LETTER)
		item.SetWhite2(loc.FROM..": "..creator.." "..date("%d/%m/%y"))
		item.SetIcon("Interface\\Icons\\INV_Misc_Note_01")
	end
	
	local pages = {}
	local p = 0
	if p == 0 and not(ItemTextHasNextPage()) then
		local text = GHI_StringToHtml(ItemTextGetText())
		pages[1] = {}
		pages[1].text1 = text
	
	else
		local c = 1;
		local text = GHI_StringToHtml(ItemTextGetText())
		pages[c] = {}
		pages[c].text1 = text

		while (ItemTextHasNextPage()) do
			ItemTextNextPage()
			c = c + 1;
			p = p + 1;
			local text = GHI_StringToHtml(ItemTextGetText())
			pages[c] = {}
			pages[c].text1 = text
		end

		while (p > 0) do
			ItemTextPrevPage();
			p = p - 1;
		end
	end
	
	item.SetCooldown(1)
	item.SetStackSize(1)
	item.SetConsumed(false)
	item.SetQuality(1);
	local t = {
		Type = "book",
		type_name = "Book",
		icon = "Interface\\Icons\\INV_Misc_Book_08",
		details = title,
		title = title,
		pages = #pages,
	};
	t["font"] = font
	t["n"] = GHI_BookDefaults.N
	t["h1"] = GHI_BookDefaults.H1
	t["h2"] = GHI_BookDefaults.H2
	t["material"] = mat
		
	for i,v in pairs(pages) do
		t[i] = pages[i]
	end
	
	local action = GHI_SimpleAction(t);
	item.AddSimpleAction(action);
	item.IncreaseVersion(true);
	itemList.UpdateItem(item);
	containerList.InsertItemInMainBag(item.GetGUID());
	
	GHI_Message(title .. " " .. loc.TRANSCRIBED .. ".");

end

function GHI_TranscribeMailboxLetter()
	local loc = GHI_Loc()
	local itemList = GHI_ItemInfoList();
	local guidCreator = GHI_GUID();
	local containerList = GHI_ContainerList();
	
	local _, _, creator, title = GetInboxHeaderInfo(InboxFrame.openMailID)
	local bodyText = GetInboxText(InboxFrame.openMailID)	
	bodyText = GHI_StringToHtml(bodyText)

	local item = GHI_ItemInfo({
				authorName = UnitName("player"),
				authorGuid = GHUnitGUID("player"),
				guid = guidCreator.MakeGUID();
			});
			
	item.SetName(title)
	item.SetIcon("Interface\\Icons\\INV_Misc_Note_01")
	item.SetWhite1(loc.LETTER)
	item.SetUseText(loc.READ_LETTER)
	item.SetWhite2(loc.FROM..": "..creator.." "..date("%d/%m/%y"))
	
	item.SetCooldown(1)
	item.SetStackSize(1)
	item.SetConsumed(false)
	item.SetQuality(1);
	
	local t = {
		Type = "book",
		type_name = "Book",
		icon = "Interface\\ICONS\\INV_Misc_Book_08",
		details = title,
		title = title,
		pages = 1,
	};
	t["font"] = GHI_BookDefaults.font
	t["n"] = GHI_BookDefaults.N
	t["h1"] = GHI_BookDefaults.H1
	t["h2"] = GHI_BookDefaults.H2
	t["material"] = GHI_BookDefaults.material
	t[1]={text1 = bodyText}
	
	local action = GHI_SimpleAction(t);
	item.AddSimpleAction(action);
	item.IncreaseVersion(true);
	itemList.UpdateItem(item);
	containerList.InsertItemInMainBag(item.GetGUID());
	GHI_Message(title.." "..loc.TRANSCRIBED);
end