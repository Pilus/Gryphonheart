
--===================================================
--					GHI Animation API
--					ghi_animationAPI.lua
--
--			API for special animation actions
--	
-- 				(c)2013 The Gryphonheart Team
--					  All rights reserved
--===================================================


local class;
local GHI_VertAnimFrame, GHI_VertAnimGroup
local TextAnimInitalize
local animationPlaying = false

function GHI_AnimationAPI()
	if class then
		return class;
	end

	class = GHClass("GHI_AnimationAPI");

	local api = {};
	local miscAPI = GHI_MiscAPI().GetAPI()

	local ratio, blend, tex, startTime
	
	local function getRaceSize()
		local sizeScale = {
			["Human"] = {1,1},
			["Undead"] = {1,1},
			["Blood Elf"] = {1,1},
			["Dwarf"] = {0.75,0.75},
			["Goblin"] = {0.75,0.75},
			["Gnome"] = {0.66,0.66},
			["Orc"] = {1.2,1},
			["Pandaren"] = {1.2,1},
			["Night Elf"] = {1.4,1.4},
			["Draenei"] = {1.2,1.25},
			["Worgen"] = {1.2,1.4},
			["Tauren"] = {1.5,1.5},
			["Troll"] = {1.4,1.2},	
		}
		local race = UnitRace("player")
		local gender = UnitSex("player")
		gender = gender-1
		return sizeScale[race][gender]
	end
	local function getRatioSizes(ratio)
		local sizes = {["s"] = {32,32},["v"] = {32,64},["h"] = {64,32}}
		return sizes[ratio][1], sizes[ratio][2]
	end

	local function createAnimationFrame()

		local frame = CreateFrame("Frame",tostring(frame),WorldFrame)  -- todo: Something is wrong here, frame and group are unintialized globals
		frame:SetSize(32,32)
		frame:SetPoint("CENTER",0,0)	 
		frame.Tex1 = frame:CreateTexture()
		frame.Tex1:SetAllPoints(frame)
		frame:Show()
		local group = frame:CreateAnimationGroup(tostring(group))
		group.trans = group:CreateAnimation("Translation")
		group.alpha = group:CreateAnimation("Alpha")
		group.scale = group:CreateAnimation("Scale")
		group.rot = group:CreateAnimation("Rotation")
		group.path = group:CreateAnimation("Path")
		group:SetScript("OnUpdate", function(self,elapsed)
			local curR, curG, curB  = frame.Tex1:GetVertexColor()
			frame.Tex1:SetVertexColor(curR + (frame.changeR), curG + (frame.changeG), curB + (frame.changeB))
		end)
		group:SetScript("OnPlay", function(self)
			startTime = GetTime()
			animationPlaying = true
		end)
		group:SetScript("OnFinished", function(self)
			frame:Hide()
			animationPlaying = false
		end)
		return frame, group
	end
	
	local function setupFrame(frame, texture, effectDuration, startingColor, endingColor)
				
		frame.Tex1:SetVertexColor(1,1,1)
		frame:SetPoint("CENTER",WorldFrame,"CENTER",0,0)
		frame:SetAlpha(1)
		
		if type(texture) == "table" then
		  tex, ratio, blend = unpack(texture)
		  if blend == nil then 
			blend = "ADD"
		  end 
		  local x, y = getRatioSizes(ratio)
		  frame:SetSize(x,y)
		elseif type(texture) == "string" then
		  tex = texture
		  blend = "ADD"
		  frame:SetSize(32,32)
		end
		
		if not (startingColor) then startingColor = {1,1,1} end
		if not (endingColor) then endingColor = startingColor end
		if not (effectDuration) then effectDuration = 1 end
		
		local colorList = miscAPI.GHI_GetColors() 
		if type(startingColor) == "string" then
			startingColor = colorList[startingColor]
		end
		if type(endingColor) == "string" then
			endingColor = colorList[endingColor]
		end
		local function round(number, decimals)
			return (("%%.%df"):format(decimals)):format(number)
		end
		frame.Tex1:SetBlendMode(blend)
		frame.Tex1:SetTexture(tex)
		frame.Tex1:SetVertexColor(startingColor.r or startingColor[1],startingColor.g or startingColor[2],startingColor.b or startingColor[3])
		frame.Tex1:SetAlpha(1)
		local frameRate = GetMaxAnimFramerate()
		local frameTotal = effectDuration * frameRate
		frame.changeR = ((endingColor.r or endingColor[1]) - (startingColor.r or startingColor[1])) / frameTotal
		frame.changeG = ((endingColor.g or endingColor[2]) - (startingColor.g or startingColor[2])) / frameTotal
		frame.changeB = ((endingColor.b or endingColor[3]) - (startingColor.b or startingColor[3])) / frameTotal
		return frame
	end
	
	local function animationSettings(group,animType,data)
		local animGroup = group[animType]
		animGroup:SetDuration(data.duration or 0)
		if data.order then
		animGroup:SetOrder(data.order or 1)
		end
		if data.delay then
		animGroup:SetStartDelay(data.delay or 0)
		end
		if data.endDelay then
			animGroup:SetEndDelay(data.endDelay or 0)
		end
		if animType == "trans" then
		  animGroup:SetOffset(data.offsetx or 0, data.offsety or 0)
		elseif animType == "scale" then
		  animGroup:SetScale(data.scalex or 0,data.scaley or 0)
		elseif animType == "alpha" then
		  animGroup:SetChange(data.alpha or 0)
		elseif animType == "rot" then
		  animGroup:SetOrigin(data.origin or "CENTER",data.offsetx or 0,data.yoffset or 0)
		  animGroup:SetDegrees(data.degrees or 0)
		end		
	end
	
	local function animLoop(group, effectDuration, bounce)
		if not (effectDuration) then effectDuration = 1 end
		if bounce then
		  group:SetLooping("BOUNCE")
		else
		  group:SetLooping("REPEAT")
		end
		group:SetScript("OnLoop", function(self, loopstate) 
			local curtime = GetTime()
			if difftime(curtime, startTime) == effectDuration then
			  group:SetLooping("NONE")
			end
		end)
	end
	
	local function GHI_PlayAnimation(group)
		if animationPlaying == true then
			return
		elseif animationPlaying == false then
			if GHI_MiscData["allow_camera_move"] then
				SetView(4)
			end
			group:Play()
		end       
	end
	

	api.GHI_AnimHoverTexture = function(texture, effectDuration, startingColor, endingColor)
		if not(texture) then
			print("No texture defined")
			return
		end
		
		local frame, group = createAnimationFrame(frame, group) -- todo: Something is wrong here
		frame = setupFrame(frame, texture, effectDuration, startingColor, endingColor)
		local raceScale = getRaceSize()
		local x,y = frame:GetSize()
		frame:SetSize((x*2)*raceScale,(y*2)*raceScale)
		frame:SetPoint("BOTTOM",WorldFrame,"CENTER",0,25)
		
		animLoop(group, effectDuration, true)
		animationSettings(group, "scale", {duration = 0.25, scalex = 1.025, scaley = 1.025, order = 1})
		animationSettings(group, "alpha", {duration = 0.25,alpha = -0.25, order = 1})
		animationSettings(group, "trans", {offsetx=0,offsety=5,duration=0.5,order=1})
		GHI_PlayAnimation(group)
	end
	
	api.GHI_AnimBuffCastTexture = function(texture, effectDuration, startingColor, endingColor)
		
		if not(texture) then
			print("No texture defined")
			return
		end
		
		local frame, group = createAnimationFrame(frame, group) -- todo: Something is wrong here
		frame = setupFrame(frame, texture, effectDuration, startingColor, endingColor)
		local raceScale = getRaceSize()
		local x,y = frame:GetSize()
		frame:SetSize(x*raceScale,y*raceScale)
		
		frame:SetPoint("CENTER",WorldFrame,"CENTER",0,0)
		animationSettings(group, "alpha", {duration = (effectDuration - 0.25),alpha = 1, order = 1, endDelay = 0.5,})
		animationSettings(group, "scale", {duration = effectDuration, scalex = 3, scaley = 3, order = 1})
		animationSettings(group, "trans", {offsetx=0,offsety=100*raceScale,duration=effectDuration,order=1})
		frame:SetAlpha(0.25)
		GHI_PlayAnimation(group)	
	end
	
	api.GHI_AnimShield = function(texture, effectDuration, startingColor, endingColor)
	
		if not(texture) then
		print("No texture defined")
		return
		end
	
		local frame, group = createAnimationFrame(frame, group)
		frame = setupFrame(frame, texture, effectDuration, startingColor, endingColor)
		local raceScale = getRaceSize()
		local x,y = frame:GetSize()
		frame:SetSize((x*5)*raceScale,(y*5)*raceScale)
		frame:SetPoint("TOP",WorldFrame,"CENTER",0,(40*raceScale))
		animLoop(group, effectDuration, true)
		animationSettings(group, "scale", {duration = 0.5, scalex = 1.025, scaley = 1.025, order = 1})
		animationSettings(group, "alpha", {duration = 0.5,alpha = -0.25, order = 1})
		GHI_PlayAnimation(group)	
	end
	
	api.GHI_LevelUpAlert = function(upperText,lowerText, speed, bg, lines)
		LevelUpDisplay.currSpell = 1;  -- A kludge to stop errors
		LevelUpDisplay.unlockList = {};   -- Another kludge
	  
		if not (upperText and lowerText) then
			LevelUpDisplay.levelFrame.singleline:SetText(upperText)
			LevelUpDisplay.levelFrame.blockText:SetText(lowerText)
			LevelUpDisplay.levelFrame.reachedText:SetText(nil);
			LevelUpDisplay.levelFrame.levelText:SetText(nil);
		else
			LevelUpDisplay.levelFrame.singleline:SetText(nil)
			LevelUpDisplay.levelFrame.blockText:SetText(nil)
			LevelUpDisplay.levelFrame.reachedText:SetText(upperText);
			LevelUpDisplay.levelFrame.levelText:SetText(lowerText);
		end

		--- hide black background ---
		if bg == true then
			LevelUpDisplay.blackBg:Hide()
		else
			LevelUpDisplay.blackBg:Show()
		end

		--- hide gold lines ---
		if lines == true then
			LevelUpDisplay.gLine2:Hide()
			LevelUpDisplay.gLine:Hide()
		else
			LevelUpDisplay.gLine2:Show()
			LevelUpDisplay.gLine:Show()
		end

		LevelUpDisplay:Show();      -- Note the frame doesn't show onscreen until...
		--- fast display speed --
		if speed == true then
			LevelUpDisplay.levelFrame.fastReveal:Play()
		else
			LevelUpDisplay.levelFrame.levelUp:Play()
		end
	end
	
	api.GHI_ScenarioAlert = function(upperText,lowerText,bottomText, bg, lines)
		LevelUpDisplay.currSpell = 1;  -- A kludge to stop errors
		LevelUpDisplay.unlockList = {};   -- Another kludge

		LevelUpDisplay.scenarioFrame.level:SetText(upperText);     -- Set the text
		LevelUpDisplay.scenarioFrame.name:SetText(lowerText);
		LevelUpDisplay.scenarioFrame.description:SetText(bottomText)

		--- hide black background ---
		if bg == true then
			LevelUpDisplay.blackBg:Hide()
		else
			LevelUpDisplay.blackBg:Show()
		end

		--- hide gold lines ---
		if lines == true then
			LevelUpDisplay.gLine2:Hide()
			LevelUpDisplay.gLine:Hide()
		else
			LevelUpDisplay.gLine2:Show()
			LevelUpDisplay.gLine:Show()
		end

		LevelUpDisplay:Show();      -- Note the frame doesn't show onscreen until...
		LevelUpDisplay.scenarioFrame.newStage:Play()

	end
	
	api.GHI_ChallengeAlert = function(upperText,lowerText, bg, lines)
		LevelUpDisplay.currSpell = 1;  -- A kludge to stop errors
		LevelUpDisplay.unlockList = {};   -- Another kludge

		LevelUpDisplay.challengeModeFrame.MedalEarned:SetText(upperText);
		LevelUpDisplay.challengeModeFrame.RecordTime:SetText(lowerText);
	  
		--- hide black background ---
		if bg == true then
			LevelUpDisplay.blackBg:Hide()
		else
			LevelUpDisplay.blackBg:Show()
		end

		--- hide gold lines ---
		if lines == true then
			LevelUpDisplay.gLine2:Hide()
			LevelUpDisplay.gLine:Hide()
		else
			LevelUpDisplay.gLine2:Show()
			LevelUpDisplay.gLine:Show()
		end

		LevelUpDisplay:Show();      -- Note the frame doesn't show onscreen until...
		LevelUpDisplay.challengeModeFrame.challengeComplete:Play()
		  
	end
	
	api.GHI_SpellAlert = function(upperText,lowerText, icon, subIcon, bigSize,  bg, lines)
		LevelUpDisplay.currSpell = 1;  -- A kludge to stop errors
		LevelUpDisplay.unlockList = {};   -- Another kludge
		--- hide black background ---
		if bg == true then
			LevelUpDisplay.blackBg:Hide()
		else
			LevelUpDisplay.blackBg:Show()
		end
		--- hide gold lines ---
		if lines == true then
			LevelUpDisplay.gLine2:Hide()
			LevelUpDisplay.gLine:Hide()
		else
			LevelUpDisplay.gLine2:Show()
			LevelUpDisplay.gLine:Show()
		end
	  
		if icon then
			if icon == "player" then
				SetPortraitTexture(LevelUpDisplay.spellFrame.icon,"player")
				LevelUpDisplay.spellFrame.iconBorder:Hide()
			else
				LevelUpDisplay.spellFrame.icon:SetTexture(icon)
				LevelUpDisplay.spellFrame.iconBorder:Show()
			end
		end
		if subIcon then
			if subIcon == "player" then
				SetPortraitTexture(LevelUpDisplay.spellFrame.subIcon,"player")
			else
				LevelUpDisplay.spellFrame.subIcon:SetTexture(subIcon)
			end
		else
			LevelUpDisplay.spellFrame.subIcon:Hide()
		end

		LevelUpDisplay.spellFrame.upperwhite:SetText("")
		LevelUpDisplay.spellFrame.bottomGiant:SetText("")
		LevelUpDisplay.spellFrame.flavorText:SetText("")
		LevelUpDisplay.spellFrame.name:SetText("")
	
		if bigSize == true then
			LevelUpDisplay.spellFrame.upperwhite:SetText(upperText)
			LevelUpDisplay.spellFrame.bottomGiant:SetText(lowerText)
		else
			LevelUpDisplay.spellFrame.flavorText:SetText(upperText)
			LevelUpDisplay.spellFrame.name:SetText(lowerText)
		end

		LevelUpDisplay:Show();      -- Note the frame doesn't show onscreen until...
		LevelUpDisplay.spellFrame.showAnim:Play()
	end

	class.GetAPI = function()
		local a = {};
		for i, f in pairs(api) do
			a[i] = f;
		end
		return a;
	end
	return class

end