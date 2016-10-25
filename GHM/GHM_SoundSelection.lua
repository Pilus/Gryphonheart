--
--
--				GHM_SoundSelection
--  			GHM_SoundSelection.lua
--
--		Menu for sound selection
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--

local count = 1;
function GHM_SoundSelection(profile, parent, settings)
	local frame = CreateFrame("Frame", "GHM_SoundSelection" .. count, parent, "GHM_SoundSelection_Template");
	count = count + 1;
	local list = _G[frame:GetName().."ListScrollList"];

	if not (GHM_SoundList) then
		GHM_InitSoundList()
	end

	local width = profile.width or 200;
	local height = profile.height or 200;
	frame:SetWidth(width);
	frame:SetHeight(height);


	local tree = CreateFrame("Frame", list:GetName() .. "TreeView", list, "GHM_TreeView_Template");
	tree:SetAllPoints();
	list.treeView = tree;

	frame.treeView = tree;
	local miscAPI = GHI_MiscAPI().GetAPI();

	local cc = 0;
	local StringContainsKeyword = function(str)
		local keywords = list.keywords or {};
		for _, keyword in pairs(keywords) do
			if not (string.find(string.lower(str), string.lower(keyword))) then
				return false;
			end
		end
		return true;
	end

	local TableContainsKeyword;
	TableContainsKeyword = function(pTree, index, tableValue)
		if pTree and pTree.Value then
			index = string.join("", unpack(pTree:GetFullPath())) .. index;
		end
		if index and (StringContainsKeyword(index)) then     -- the whole subtable is okay
			return true;
		end

		if tableValue then
			for i, v in pairs(tableValue) do
				if (StringContainsKeyword(index..i)) then
					return true;
				elseif (type(v) == "table") then
					if TableContainsKeyword(nil, index .. i, v) then
						return true;
					end
				end
			end
		end
		return false;
	end

	local OnExpand;

	local InsertNode = function(pTree, index, text, nodeValue, tableValue)
		local subTree
		if pTree.Elements and pTree.Elements[index] then
			subTree = pTree.Elements[index];
			subTree.Value = nodeValue;
			subTree.Title.Text:SetText(text);
		else
			subTree = pTree:AddNode(text, nodeValue, width, 15) -- pTree:GetWidth() - 15
			subTree:AddScript("OnExpand", OnExpand);
		end

		subTree:SetMargins(15, 0);
		subTree.tableValue = tableValue;
		if (type(tableValue) == "table") then
			if #(subTree.Elements or {}) == 0 then
				local dummyNode = subTree:AddNode("dummy", "dummy", subTree:GetWidth() - 15, 15);
				dummyNode:AddScript("OnExpand", OnExpand);
			end
			if subTree.playBtn then
				subTree.playBtn:Hide();
			end
		else
			local playBtn = CreateFrame("Button", "$parentPlayButton", subTree);
			playBtn:SetWidth(14);
			playBtn:SetHeight(14);
			playBtn:SetPoint("TOPLEFT", 0, 0);
			playBtn:SetNormalTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up");
			playBtn:SetPushedTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Down");
			playBtn:SetScript("OnClick", function(self)
				local node = self:GetParent();
				PlaySoundFile(strjoin("", unpack(node:GetFullPath())));
			end);
			playBtn:RegisterForClicks("AnyUp");
			playBtn:SetFrameLevel(subTree.Title:GetFrameLevel() + 1)
			subTree.playBtn = playBtn;

			if type(tableValue) == "number" then
				local timeString = miscAPI.GHI_GetPreciseTimeString(tableValue);
				if tableValue == 0.05 or tableValue == 0 then
					timeString = "(Unknown)"
				end
				local coloredTimeString = miscAPI.GHI_ColorString(timeString, 0.0, 0.7, 0.5);
				subTree.Title.Text:SetText(text .. " " .. coloredTimeString);
			end
		end
		pTree.Elements[index]:Show();
	end

	local function pairsByKeys(t, f)
		local a = {}
		for n in pairs(t) do table.insert(a, n) end
		table.sort(a, f)
		local i = 0 -- iterator variable
		local iter = function() -- iterator function
			i = i + 1
			if a[i] == nil then return nil
			else return a[i], t[a[i]]
			end
		end
		return iter
	end

	OnExpand = function(pTree)
		if not (pTree.refreshing == true) and type(pTree.tableValue) == "table" then
			local i = 1;
			for index, value in pairsByKeys(pTree.tableValue) do
				local name = string.gsub(index, "[\\_]", "");
				name = string.gsub(name, ".mp3", "")
				if type(value) == "table" then
					InsertNode(pTree, i, name, index, value);

					if TableContainsKeyword(pTree, index, value) then
						pTree.Elements[i]:Show();
					else
						pTree.Elements[i]:Hide();
					end

					i = i + 1;
				end
			end
			for index, value in pairsByKeys(pTree.tableValue) do
				local name = string.gsub(index, "[\\_]", "");
				name = string.gsub(name, ".mp3", "")
				if type(value) == "number" and TableContainsKeyword(pTree, index, nil) then
					InsertNode(pTree, i, name, index, value);
					i = i + 1;
				end
			end
			while pTree.Elements[i] do
				pTree.Elements[i]:Hide();
				i = i + 1;
			end

			pTree.refreshing = true;
			if pTree.Collapse and pTree.Expand then
				pTree:Collapse();
				pTree:Expand();
			end
			pTree:SkipAllHidden()
			pTree.refreshing = false;
		end
	end

	local EnvokeExpandOnAllExpanded;
	EnvokeExpandOnAllExpanded = function(pTree)
		OnExpand(pTree);
		for _, child in pairs(pTree.Elements) do
			if child.Expanded then
				EnvokeExpandOnAllExpanded(child);
			end
		end
	end

	local textBox = _G[frame:GetName() .. "Editbox"];
	textBox:SetScript("OnTextChanged", function(box)
		list.keywords = { string.split(" ", box:GetText()) };
		EnvokeExpandOnAllExpanded(tree);
	end)

	tree.tableValue = GHM_SoundList;
	local loaded = false;
	tree:SetScript("OnShow", function()
		OnExpand(tree);
	end)

	-- Frame positioning
	local extraX = profile.xOff or 0;
	local extraY = profile.yOff or 0;

	if profile.align == "c" then
		frame:SetPoint("CENTER", parent, "CENTER", extraX, extraY);
	elseif profile.align == "r" then
		frame:SetPoint("RIGHT", parent.lastRight or parent, "RIGHT", extraX, extraY);
		parent.lastRight = frame;
	else
		if parent.lastLeft then frame:SetPoint("LEFT", parent.lastLeft, "RIGHT", extraX, extraY); else frame:SetPoint("LEFT", parent, "LEFT", extraX, extraY); end
		parent.lastLeft = frame;
	end

	-- functions
	local currentSound = "";
	local varAttFrame;

	local Change = function(path,duration)
		if profile.OnSelect then
		   profile.OnSelect(path,duration or 0);
		end
	end

	tree:AddScript("OnSelectionChange", function(node)
		if type(node.tableValue) == "number" then
			currentSound = strjoin("", unpack(node:GetFullPath()));
			Change(currentSound,node.tableValue);
		end
	end);

	local Force1 = function(data)
		currentSound = data;
		Change(data);
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
		currentSound = "";
		Change("")
	end


	frame.EnableVariableAttributeInput = function(self, scriptingEnv, item)
		if not (varAttFrame) then
			varAttFrame = GHM_VarAttInput(frame, frame, frame:GetWidth());
			frame:SetHeight(frame:GetHeight());
		end
		varAttFrame:EnableVariableAttributeInput(scriptingEnv, item, profile.outputOnly)
	end

	frame.GetValue = function(self)
		if (varAttFrame and not (varAttFrame:IsStaticTabShown())) then
			return varAttFrame:GetValue();
		else
			return currentSound;
		end
	end

	--tree:SetWidth(main:GetWidth() - 20);

	frame.SetPosition = function(xOff, yOff, width, height)
		frame:SetWidth(width);
		frame:SetHeight(height);
		frame:SetPoint("TOPLEFT", parent, "TOPLEFT", xOff, -yOff);
		--tree:SetWidth(width)
	end

	frame.GetPreferredDimensions = function()
		return profile.width, profile.height;
	end

	if type(profile.OnLoad) == "function" then
		profile.OnLoad(frame);
	end

	frame.Clear();
	frame:Show();

	return frame;

end

