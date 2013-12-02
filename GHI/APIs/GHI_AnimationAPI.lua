
--===================================================
--					GHI Animation API
--				   ghi_animationAPI.lua
--
--			API for special animation actions
--		
--	
-- 				(c)2013 The Gryphonheart Team
--					  All rights reserved
--===================================================

function GHI_Animation_AllowCameraMove(allow)
	if allow then 
		GHI_ALLOWCAMERAMOVE = allow
		return
	end
end


local class;

function GHI_AnimationAPI()
	if class then
		return class;
	end

	class = GHClass("GHI_AnimationAPI");

	local api = {};
	local miscAPI = GHI_MiscAPI().GetAPI()

	api.GHI_AnimHoverTexture = function(texture, effectDuration, startingColor, endingColor,xPos,yPos)
		if not(texture) then
			print("No texture defined")
			return
		end
		
		local animFrame		
		if _G["GHI_AnimFrame_Spell"] then
			animFrame = _G["GHI_AnimFrame_Spell"]
		else
			animFrame = GHI_CreateAnimationFrame("Spell")
		end
		
		local animInfo = GHI_AnimationInfo()
		
		animFrame.Clear()
		animFrame.SetAnimType("Shimmer")
		if xPos > 0 or yPos > 0 then --user set
			aniFrame.SetPosition("Custom",xPos,yPos)
		else
			animFrame.SetPosition("Head")
		end
		animFrame.SetTotalDuration(effectDuration)
		
		if type(texture) == "table" then
			local tex, raient, blend = unpack(texture)
			if blend then
				animFrame.SetTextureBlend(blend)
			end
			if ratio then
				animFrame.SetOrientation(orient)
			end
			animFrame.SetTexture(tex, startingColor, endingColor)
		else
			animFrame.SetTexture(texture, startingColor, endingColor)
		end
		animFrame:Show()
		animFrame.PlayAnimation()
	end
	
	api.GHI_AnimBuffCastTexture = function(texture, effectDuration, startingColor, endingColor)
		if not(texture) then
			print("No texture defined")
			return
		end
		
		local animFrame		
		if _G["GHI_AnimFrame_Spell"] then
			animFrame = _G["GHI_AnimFrame_Spell"]
		else
			animFrame = GHI_CreateAnimationFrame("Spell")
		end
		
		local animInfo = GHI_AnimationInfo()
		
		animFrame.Clear()
		animFrame.SetAnimType("Buff Cast")
		animFrame.SetPosition("Head")
		animFrame.SetRepeating(false)
		
		if type(texture) == "table" then
			local tex, raient, blend = unpack(texture)
			if blend then
				animFrame.SetTextureBlend(blend)
			end
			if ratio then
				animFrame.SetOrientation(orient)
			end
			animFrame.SetTexture(tex, startingColor, endingColor)
		else
			animFrame.SetTexture(texture, startingColor, endingColor)
		end
		animFrame:Show()
		animFrame.PlayAnimation()
	end
	
	api.GHI_AnimShield = function(texture, effectDuration, startingColor, endingColor,xPos,yPos)
		if not(texture) then
			print("No texture defined")
			return
		end
		
		local animFrame		
		if _G["GHI_AnimFrame_Spell"] then
			animFrame = _G["GHI_AnimFrame_Spell"]
		else
			animFrame = GHI_CreateAnimationFrame("Spell")
		end
		
		local animInfo = GHI_AnimationInfo()
		
		local raceScale = animInfo.GetRaceScale()
		
		animFrame.Clear()
		animFrame.SetAnimType("Shimmer")
		if xPos > 0 or yPos > 0 then --user set
			aniFrame.SetPosition("Custom",xPos,yPos)
		else
			animFrame.SetPosition("Body")
		end
		animFrame.SetTotalDuration(effectDuration)
		
		animFrame.SetSize((288 * raceScale), (288 * raceScale))
		
		if type(texture) == "table" then
			local tex, raient, blend = unpack(texture)
			if blend then
				animFrame.SetTextureBlend(blend)
			end
			if ratio then
				animFrame.SetOrientation(orient)
			end
			animFrame.SetTexture(tex, startingColor, endingColor)
		else
			animFrame.SetTexture(texture, startingColor, endingColor)
		end
	
		animFrame:Show()
		animFrame.PlayAnimation()
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

--[[
	local GHFlashFrame
	local flashAnims, isAni
	api.GHI_ScreenFlash = function(fadeIn, fadeOut, duration, color, alpha, texture, blend, repeating)
		local api = GHI_MiscAPI().GetAPI()
		local colorList = api.GHI_GetColors()
		--print(duration)
		local blendTypes = {"ADD","BLEND","MOD","ALPHAKEY","DISABLE"}

		if type(color) == "string" then
			color = colorList[color]
		end

		if not (color) and not (texture) then
			GHI_Message("You must define a texture or color.")
			return
		end

	  local delay = duration - (fadeIn + fadeOut)
	  if repeating == nil then
		repeating = 1
	  end

	  if not (GHFlashFrame) then
		GHFlashFrame = CreateFrame("Frame", "GHFlashFrame", UIParent);
		GHFlashFrame:SetFrameStrata("BACKGROUND");
		GHFlashFrame:SetAllPoints(UIParent);
		GHFlashFrame.bg = GHFlashFrame:CreateTexture(nil, "CENTER")
		GHFlashFrame.bg:SetAllPoints(GHFlashFrame)
	  end
	  if not (flashAnims) then
		flashAnims = GHFlashFrame:CreateAnimationGroup("Flashing")
		flashAnims.fadingIn = flashAnims:CreateAnimation("Alpha")
		flashAnims.fadingIn:SetOrder(1)
		flashAnims.fadingIn:SetSmoothing("NONE")
		flashAnims.fadingIn:SetChange(1)
		flashAnims.fadingOut = flashAnims:CreateAnimation("Alpha")
		flashAnims.fadingOut:SetOrder(2)
		flashAnims.fadingOut:SetSmoothing("NONE")
		flashAnims.fadingOut:SetChange(-1)
		flashAnims:SetScript("OnFinished",function(self,requested)
			GHFlashFrame:Hide()
			GHFlashFrame.bg:SetBlendMode("DISABLE")
			isAni = false
		end)
		flashAnims:SetScript("OnPlay",function(self)
			GHFlashFrame:Show()
			GHFlashFrame:SetAlpha(0)
			isAni = true
		end)
	  end

	  flashAnims.fadingIn:SetDuration(fadeIn)
	  flashAnims.fadingIn:SetEndDelay(delay)
	  flashAnims.fadingOut:SetDuration(fadeOut)
	  if repeating > 1 then
		flashAnims:SetLooping("REPEAT")
      else
		flashAnims:SetLooping("NONE")
	  end
	  local timestart = GetTime()
	  local looptime = duration * repeating

	  flashAnims:SetScript("OnLoop", function(self, loopstate)
		  if loopstate == "FORWARD" then
			local curtime = GetTime()
			if difftime(curtime, timestart) == looptime - duration then
			  flashAnims:SetLooping("NONE")
			end
		  end
	  end)

	  if texture then
	  		GHFlashFrame.bg:SetTexture(texture)
			GHFlashFrame.bg:SetBlendMode(blend or "ADD")

			GHFlashFrame.bg:SetAlpha(alpha or 1)

			if color then
				GHFlashFrame.bg:SetVertexColor(
						color.r or color[1],
						color.g or color[2],
						color.b or color[3]
					)
			else
				GHFlashFrame.bg:SetVertexColor(1,1,1,1)
			end
		else
			if not (blend) then
				blend = 5
			end
		  	GHFlashFrame.bg:SetTexture(color.r or color[1], color.g or color[2], color.b or color[3])
			GHFlashFrame.bg:SetBlendMode(blendTypes[blend])
			GHFlashFrame.bg:SetAlpha(alpha or 1)
		end

	  if isAni == true then -- if sone is already animating, stop it and do the new one
		GHFlashFrame:StopAnimating()
		GHFlashFrame.bg:SetAlpha(alpha or 1)
		flashAnims:Play()
	  else -- otherwise animate
		flashAnims:Play()
	  end
	end
	]]--