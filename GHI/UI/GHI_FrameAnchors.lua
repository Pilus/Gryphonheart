local frames = {};

function GHI_ContainerAnchorFrame(f, special)
	local frameC = 1;
	if special == "display" then -- it is proberbly a eq display
		if not (f.anchorPlate) then

			local ap = CreateFrame("Frame", "GHI_AnchoredFrame" .. frameC, UIParent)
			frameC = frameC + 1;
			ap:SetFrameStrata("BACKGROUND")

			ap:SetWidth(155);
			ap:SetHeight(308);

			--ap:Hide();
			f.anchorPlate = ap;
			--f.parent:SetParent(ap);
			f:ClearAllPoints();

			if f:IsShown() then
				f.main:Hide();
			else
				f.main:Hide();
				f.main:Show();
			end

			f:SetPoint("CENTER", ap, "CENTER", 0, 0);
		end
		f.anchorPlate.realLeft = nil;
		GHI_RemoveAnchorFrame(f.anchorPlate);
		table.insert(frames, f.anchorPlate);
	else
		f.realLeft = nil;
		GHI_RemoveAnchorFrame(f);
		table.insert(frames, f);
	end

	GHI_UpdateContainerFrameAnchors();
end

function GHI_RemoveAnchorFrame(f)
	--frames[f:GetName()] = nil
	local t = {};
	for i = 1, #(frames) do
		if not (frames[i] == f) then
			table.insert(t, frames[i]);
		end
	end
	frames = t;
	GHI_UpdateContainerFrameAnchors();
end


function GHI_UpdateContainerFrameAnchors()
	local index = table.getn(ContainerFrame1.bags) + 1;
	local frame, xOffset, yOffset, screenHeight, freeScreenHeight;
	local screenWidth = GetScreenWidth();
	local containerScale = 1;

	screenHeight = GetScreenHeight() / containerScale;
	-- Adjust the start anchor for bags depending on the multibars
	xOffset = CONTAINER_OFFSET_X / containerScale;
	yOffset = CONTAINER_OFFSET_Y / containerScale;
	freeScreenHeight = screenHeight;

	local prevBag = nil;

	local shownFrames = {};
	local hiddenFrames = {};
	for i, frame in pairs(frames) do
		if frame then
			if not (frame:IsShown()) then
				table.insert(hiddenFrames, frame);
			else
				table.insert(shownFrames, frame);
				local y = 0;
				if prevBag then
					y = prevBag:GetTop();
				elseif index > 1 then
					y = _G[ContainerFrame1.bags[index - 1]]:GetTop();
				end
				freeScreenHeight = screenHeight - y - VISIBLE_CONTAINER_SPACING;

				frame:ClearAllPoints();

				if prevBag then
					if (freeScreenHeight < frame:GetHeight()) then
						local x = screenWidth - (prevBag.realLeft or prevBag:GetLeft());
						-- new column
						frame:SetPoint("BOTTOMRIGHT", frame:GetParent(), "BOTTOMRIGHT", -x, yOffset);

						frame.realLeft = frame:GetLeft();

					else
						-- Anchor to the previous bag
						frame:SetPoint("BOTTOMRIGHT", prevBag, "TOPRIGHT", 0, CONTAINER_SPACING);
						frame.realLeft = min(prevBag.realLeft or prevBag:GetLeft(), frame:GetLeft());
					end
				elseif (index == 1) then

					-- First bag
					frame:SetPoint("BOTTOMRIGHT", frame:GetParent(), "BOTTOMRIGHT", -xOffset, yOffset);
					frame.realLeft = frame:GetLeft();
				elseif (freeScreenHeight < frame:GetHeight()) then

					-- Start a new column
					local x = screenWidth - _G[ContainerFrame1.bags[index - 1]]:GetRight();
					frame:SetPoint("BOTTOMRIGHT", frame:GetParent(), "BOTTOMRIGHT", -x - (1 * frame:GetWidth()), yOffset);
					frame.realLeft = frame:GetLeft();
				else
					-- Anchor to the previous bag
					frame:SetPoint("BOTTOMRIGHT", ContainerFrame1.bags[index - 1], "TOPRIGHT", 0, CONTAINER_SPACING);
					frame.realLeft = min(frame:GetLeft(), _G[ContainerFrame1.bags[index - 1]]:GetLeft());
				end

				prevBag = frame;
			end
		end
	end

	-- reordering
	for _, frame in pairs(hiddenFrames) do
		table.insert(shownFrames, frame);
	end
	frames = shownFrames
end

local orig_ContainerFrame_GenerateFrame = ContainerFrame_GenerateFrame
ContainerFrame_GenerateFrame = function(frame,size,id)
	orig_ContainerFrame_GenerateFrame(frame,size,id)
	local origShow = frame:GetScript("OnShow");
	local origHide = frame:GetScript("OnHide");
	frame:SetScript("OnShow",function(...)
		origShow(...)
		GHI_UpdateContainerFrameAnchors();
	end);
	frame:SetScript("OnHide",function(...)
		origHide(...)
		GHI_UpdateContainerFrameAnchors();
	end);
	GHI_UpdateContainerFrameAnchors();
end

function GHI_DragContainer(obj,state)
	if not(type(obj)=="table") then return end

	if state == 1 then -- start drag
		GHI_RemoveAnchorFrame(obj);
		return;
	end


	local x,y = GetCursorPosition();
	local s = obj:GetEffectiveScale();

	local xpos, ypos = x/s, y/s;


	-- Hide the tooltip
	GameTooltip:Hide();

	-- Set the position
	obj:ClearAllPoints();
	obj:SetPoint("TOP", UIParent, "BOTTOMLEFT", xpos, ypos);

	if state == 2 and (GetScreenWidth() - obj:GetRight()) < obj:GetWidth()*2 then

		GHI_ContainerAnchorFrame(obj);
	end
end