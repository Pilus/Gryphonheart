--===================================================
--					GHI Animation
--				   ghi_animation.lua
--
--			Handler for creating Animation Objects.
--		
--	
-- 				(c)2013 The Gryphonheart Team
--					  All rights reserved
--===================================================

local class

function GHI_AnimationInfo()

	if class then return class end
	
	class = {}
			
	class.GetPositions = function()
		return {
			["Full Screen"] = {
				TOPLEFT = {"TOPLEFT"},
				TOPRIGHT = {"TOPRIGHT"},
				BOTTOMLEFT = {"BOTTOMLEFT"},
				BOTTOMRIGHT = {"BOTTOMRIGHT"}
			},
			["Body"] = {
				TOP = {"CENTER",0,25}
			},
			["Head"] = {
				BOTTOM = {"CENTER"},
			},
		}
	end
	
	class.GetTimes = function(frame)
		return {
			["Shimmer"] = function() return 0.5 end,
			["Buff Cast"] = function() return 1 end,
			["Hover"] = function() return 1 end,
			["Flash"] = function()
				local t1 = frame.flash.fadeIn:GetDuration()
				local t2 = frame.flash.fadeOut:GetDuration()
				local t3 = frame.flash.hold:GetDuration()
				
				return t1 + t2 + t3
			end,
		}
	end
	
	class.GetTypeList = function()
		return {
			["Flash"] = "flash",
			["Shimmer"] = "shimmer",
			["Buff Cast"] = "buffCast",
			["Hover"] = "hover",
		}
	end
	
	class.GetRaceScale = function()
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
		return sizeScale[race][(gender - 1)]
	end
	
	class.GetOrientRatio = function(orient)	
		local sizes = {["s"] = {1,1},["v"] = {1,2},["h"] = {2,1}}
		return sizes[strlower(orient)][1], sizes[strlower(orient)][2]
	end
	
	return class
end

function GHI_CreateAnimationFrame(name)
	local frame = CreateFrame("Frame", "GHI_AnimFrame_"..name,WorldFrame,"GHI_Animation_Template")
	local animInfo = GHI_AnimationInfo()
	
	local animList = animInfo.GetTypeList()
	local animTimes = animInfo.GetTimes(frame)		
	local stylePositions = animInfo.GetPositions()
	
	local AnimOnFinish_Repeat = function(self)
		self.counter = self.counter + 1		
		local repeating = frame.repeating		
		if frame.repeating == false then repeating = 1 end
		if self.counter < repeating then
			self:Play()
		elseif self.counter >= repeating then
			frame:Hide()
		end
	end
	
	local AnimOnFinish = function(self)
		self.counter = self.counter + 1
		frame:Hide()
	end
	
	local function ColorStep(color1, color2)
		local animDuration = animTimes[frame.animType]()
		local totalFrames = GetFramerate() * (frame.duration or 1)
		local diffR = (color2.r or color2[1]) - (color1.r or color1[1])
		local diffG = (color2.g or color2[2]) - (color1.g or color1[2])
		local diffB = (color2.b or color2[3]) - (color1.b or color1[3])
		local diffA = (color2.a or color2[4]) - (color1.a or color1[4])
		local rStep, gStep, bStep, aStep = (diffR / totalFrames), (diffG / totalFrames), (diffB / totalFrames), (diffA / totalFrames)
		
		return rStep, gStep, bStep, aStep
	end
	
	
	local t = frame:CreateTexture(nil,"OVERLAY",nil,6) --for dragging I am getting some of this from the RothUI set of addons
	
	t:SetTexture(0,1,1)
	t:SetAlpha(0)
	
	frame.UnlockTexture = t;
	
	frame.animType = ""
	-- frame.animType sets which type of animation to play.
	
	frame.SetAnimType = function(animType)
		frame.animType = animType
	end
	
	frame.repeating = false
	-- frame.repeating tells us if we repeat the animation
			
	frame.PlayAnimation = function()
		local animationType = animList[frame.animType]
		frame[animationType].counter = 0
		
		frame:Show()
		frame[animationType]:Play()
		
		if type(frame.repeating) == "number" then
			frame[animationType]:SetScript("OnFinished", AnimOnFinish_Repeat)
		elseif frame.repeating == false then
			frame[animationType]:SetScript("OnFinished", AnimOnFinish)
		end
		
		if frame.duration then
			GHI_Timer(function()
				frame[animationType]:Stop()
				frame:Hide()
			end,tonumber(frame.duration),true)
		end
	end
	
	frame.SetFlashTimes = function(inTime, outTime, holdTime)
		frame.flash.fadeIn:SetDuration(inTime)
		frame.flash.fadeOut:SetDuration(outTime)
		frame.flash.hold:SetDuration(holdTime)
	end
	
	frame.SetRepeating = function(rep)
		if type(rep) == "boolean" and rep == false then
			frame.repeating = false
		elseif type(rep) == "number" then
			frame.repeating = rep
		else
			frame.repeating = false
		end
	end
	
	frame.SetTotalDuration = function(duration)
		frame.duration = duration	
	end
	
	frame.SetTexture = function(texture, tint, tint2)
		if texture == "SOLID" then
			frame.tex:SetTexture(1,1,1,1)
		elseif type(texture) == "string" then
			frame.tex:SetTexture(texture)
		end
		
		if type(tint) == "table" then
			frame.tex:SetVertexColor(tint.r or tint[1],tint.g or tint[2],tint.b or tint[3],tint.a or tint[4])
		else
			frame.tex:SetVertexColor(1,1,1,1)
		end
		
		if tint2 then
			local repeatTimes = frame.repeating
			
			if type(repeatTimes) ~= "number" then
				repeatTimes = 1
			end
			
			local rStep, gStep, bStep, aStep =  ColorStep(tint, tint2)
			
			frame:SetScript("OnUpdate", function(self)
				local r,g,b,a = frame.tex:GetVertexColor()
				frame.tex:SetVertexColor(r+rStep, g+gStep, b+bStep,a+aStep)
			end)
		else
			frame:SetScript("OnUpdate", function(self) end)			
		end
		
		frame.tex:Show()
	end
	
	frame.SetTextureBlend = function(blend)
		frame.tex:SetBlendMode(blend)
	end
		
	frame.SetEmblem = function(emblem, tint, tint2)
		if strlen(emblem) < 2 then
			emblem = "0"..emblem
		end
		
		--frame.logo.l = _G[frame.logo:GetName().."Left"]
		--frame.logo.r = _G[frame.logo:GetName().."Right"]

		frame.logo.l:SetTexture("Textures\\GuildEmblems\\Emblem_" .. emblem)
		frame.logo.r:SetTexture("Textures\\GuildEmblems\\Emblem_" .. emblem)

		frame.logo.l:SetVertexColor(tint.r or tint[1],tint.g or tint[2],tint.b or tint[3],tint.a or tint[4]);
		frame.logo.r:SetVertexColor(tint.r or tint[1],tint.g or tint[2],tint.b or tint[3],tint.a or tint[4]);

		if tint2 then
			local repeatTimes = frame.repeating
			
			if type(repeatTimes) ~= "number" then
				repeatTimes = 1
			end
			
			local rStep, gStep, bStep, aStep =  ColorStep(tint, tint2)
			
			frame.logo:SetScript("OnUpdate", function(self)
				local r,g,b,a = self.l:GetVertexColor()
				self.l:SetVertexColor(r + rStep, g + gStep, b + bStep,a + aStep)
				self.r:SetVertexColor(r + rStep, g + gStep, b + bStep,a + aStep)
			end)
		else
			frame.logo:SetScript("OnUpdate", function(self) end)			
		end	
		frame.logo:Show()
	end
	
	frame.UnlockFrame = function(self)
		if InCombatLockdown() then return end
		if frame.locked == false then return end --its unlocked already lets not double up things
		frame:EnableMouse(true)
		framelocked = false
		frame.UnlockTexture:SetAlpha(0.3)
		frame:RegisterForDrag("LeftButton","RightButton")
		---Put in a placeholder texture
		frame:SetScript("OnDragStart", function(self,b)
			if b == "LeftButton" then
				self:StartMoving()
			end
			if b == "RightButton" then
				frame.LockFrame(self)
			end
		end)
		
		frame:SetScript("OnDragStop", function(self)
		  self:StopMovingOrSizing()
		  --may want to do following in lockfunction, unsure
		 --x, y = frame:GetCenter()
		--GHI_MiscData[name.."x"] = x
		--GHI_MiscData[name.."y"] = y
		end)
	
	end
	
	frame.LockFrame = function(self)
		if InCombatLockdown() then return end
		if frame.locked == true then return end --already locked
		frame.locked = true
		frame.dragtexture:SetAlpha(0)
		frame:RegisterForDrag(nil)
		frame:SetScript("OnDragStart", nil)
		frame:SetScript("OnDragStop", nil)
	
	end
		
	frame.SetPosition = function(pos,x,y)
		if pos == "Custom" then
			frame.PositionType = pos
			frame:ClearAllPoints()
			frame:SetPoint("CENTER", WorldFrame, x,y)
		else
			frame.PositionType = pos
			frame:ClearAllPoints()
			for point, data in pairs(stylePositions[pos]) do
				frame:SetPoint(point, WorldFrame, unpack(data))
			end
		end
	end
	
	frame.SetSize = function(x,y)
		frame:SetWidth(x)
		frame:SetHeight(y)
	end
	
	frame.SetOrientation = function(orient)
		local x,y = frame:GetSize()
		local ratX, ratY = animInfo.GetOrientRatio()
		frame:SetSize(x * ratX, y * ratY)
	end
	
	frame.SetModel = function(model)
		frame.model:Show()
		if type(model) == "string" then
			frame.model:SetModel(model)
		end
	end
	
	frame.SetDisplayID = function(ID)
		frame.model:Show()
		frame.model:SetDisplayInfo(tonumber(ID))
	end
	
	frame.SetCamera = function(cam)
		frame.model:SetCamera(tonumber(cam))
	end
	
	frame.Clear = function()
		frame.logo.l = _G[frame.logo:GetName().."Left"]
		frame.logo.r = _G[frame.logo:GetName().."Right"]
		
		frame.tex:SetTexture(nil)
		frame.logo.l:SetTexture(nil)
		frame.logo.r:SetTexture(nil)
		frame.model:ClearModel()
		
		frame.PositionType = nil
		frame.animType = ""
		frame.repeating = false
		frame.duration = nil
		
		frame:SetAlpha(1)
		frame:SetScale(1,1)
		
		frame.tex:Hide()
		frame.logo:Hide()
		frame.model:Hide()
	end
	
	frame:Hide()

	return frame
end