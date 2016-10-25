--
--									
--									GHI Buff Handler
--								GHI_BuffHandler.lua
--
--				Handles applying of GHI buffs, including area buffs.
--	
-- 						(c)2013 The Gryphonheart Team
--								All rights reserved
--


local class;
function GHI_BuffHandler()
	if class then
		return class;
	end
	class = GHClass("GHI_BuffHandler");

	local ApplyBuff, PackBuffInfo, UnpackBuffInfoAndRemoveDelay, ReceiveApplyBuff, CheckTarget, BuffRecieveSubscription, SendBuffInfo, BuffRecieveInfo, BuffChanged, UpdateBuffSubscriptions;
	local delayedBuffs = {};
	local delayedRemoveBuffs = {};
	local subscribedPlayers = {};
	local subscriptionsSend = {};
	local buff = GHI_BuffUI("Custom GHI buff", 0.0, 0.7, 0.5);
	local areaBuff = GHI_AreaBuff();
	local comm = GHI_Comm();
	local errorThrower = GHI_ErrorThrower();
	local log = GHI_Log();

	GHI_Timer(function()
		for i, v in pairs(delayedBuffs) do
			if type(v) == "table" and (v.time or 0) <= time() then
				class.CastBuff(UnpackBuffInfoAndRemoveDelay(v));
				delayedBuffs[i] = nil;
			end
		end
		for i, v in pairs(delayedRemoveBuffs) do
			if type(v) == "table" and (v.time or 0) <= time() then
				class.RemoveBuff(unpack(v));
				delayedRemoveBuffs[i] = nil;
			end
		end
		CheckTarget();
	end, 1, false, "Delayed buffs");

	class.CastBuff = function(buffName, buffDetails, buffIcon, untilCanceled, filter, buffType, buffDuration, cancelable, stackable, count, delay, range, alwaysCastOnSelf)
		log.Add(3,"Cast Buff",{
			buffName=buffName,
			buffDetails=buffDetails,
			buffIcon=buffIcon,
			untilCanceled=untilCanceled,
			filter=filter,
			buffType=buffType,
			buffDuration=buffDuration,
			cancelable=cancelable,
			stackable=stackable,
			count=count,
			delay=delay,
			range=range,
			alwaysCastOnSelf=alwaysCastOnSelf,
		});

		if type(delay) == "number" and delay > 0 then
			local packedBuffInfo = PackBuffInfo(buffName, buffDetails, buffIcon, untilCanceled, filter, buffType, buffDuration, cancelable, stackable, count, delay, range, alwaysCastOnSelf)
			packedBuffInfo.time = time() + delay;
			table.insert(delayedBuffs, packedBuffInfo);
			return
		end

		if type(range) == "number" and range > 0 then
			areaBuff.Send(buffName, buffDetails, buffIcon, untilCanceled, filter, buffType, buffDuration, cancelable, stackable, count, delay, range);
		else
			if alwaysCastOnSelf or UnitName("target") == UnitName("player") or not (UnitName("target")) then
				ApplyBuff(buffName, buffDetails, buffIcon, untilCanceled, filter, buffType, buffDuration, cancelable, stackable, count)
			else
				if CheckInteractDistance("target", 1) then
					comm.Send(nil, UnitName("target"), "ApplyBuff", PackBuffInfo(buffName, buffDetails, buffIcon, untilCanceled, filter, buffType, buffDuration, cancelable, stackable, count, delay, range, alwaysCastOnSelf));
				else
					errorThrower.TooFarAway();
				end
			end
		end
	end

	ApplyBuff = function(name, text, texture, untilCancelled, filter, debuffType, duration, cancelable, stackable, count)
		buff:CastBuff(string.lower(filter), name, GHUnitGUID("player"), name, text, texture, (not (untilCancelled) and duration) or 0, (not (untilCancelled) and GetTime() + duration) or 0, count, debuffType, stackable)
	end

	PackBuffInfo = function(buffName, buffDetails, buffIcon, untilCanceled, filter, buffType, buffDuration, cancelable, stackable, count, delay, range, alwaysCastOnSelf)
		return {
			buffName = buffName,
			buffDetails = buffDetails,
			buffIcon = buffIcon,
			untilCanceled = untilCanceled,
			filter = filter,
			buffType = buffType,
			buffDuration = buffDuration,
			cancelable = cancelable,
			stackable = stackable,
			count = count,
			delay = delay,
			range = range,
			alwaysCastOnSelf = alwaysCastOnSelf,
		};
	end
	UnpackBuffInfoAndRemoveDelay = function(info)
		return info.buffName, info.buffDetails, info.buffIcon, info.untilCanceled, info.filter, info.buffType, info.buffDuration, info.cancelable, info.stackable, info.count, 0, info.range, info.alwaysCastOnSelf;
	end

	ReceiveApplyBuff = function(sender, click)
		ApplyBuff(click.buffName, click.buffDetails, click.buffIcon, click.untilCanceled, click.filter, click.buffType, click.buffDuration, click.cancelable, click.stackable, click.count or 1, click.delay or 0)
	end
	comm.AddRecieveFunc("ApplyBuff", ReceiveApplyBuff)


	-- stick Setup
	if GHI_MiscData["stick_player_buffs"] == nil then
		if BuffFrame:IsShown() then
			GHI_MiscData["stick_player_buffs"] = true;
		else
			GHI_MiscData["stick_player_buffs"] = false;
		end
	end


	buff:StickToBlizzFrame("player", GHI_MiscData["stick_player_buffs"]);
	buff:StickToBlizzFrame("target", GHI_MiscData["stick_target_buffs"]);

	GHI_Event("PLAYER_TARGET_CHANGED", function(...)
		if UnitName("target") and (GHI_MiscData["stick_target_buffs"] == nil) then
			if TargetFrame:IsShown() then
				GHI_MiscData["stick_target_buffs"] = true;
			else
				GHI_MiscData["stick_target_buffs"] = false;
			end
			buff:StickToBlizzFrame("target", GHI_MiscData["stick_target_buffs"]);
		end
		CheckTarget();
	end);


	class.UpdateBuffSticking = function() -- used by options panel
		buff:StickToBlizzFrame("player", GHI_MiscData["stick_player_buffs"]);
		buff:StickToBlizzFrame("target", GHI_MiscData["stick_target_buffs"]);
	end

	class.CountBuffs = function(name, unit)
		unit = unit or "player";
		return buff:CountBuff(name, GHUnitGUID(unit))
	end

	class.RemoveBuff = function(name, filter, count, delay)
		if delay and delay > 0 then
			local t = {name, filter, count, 0};
			t.time = time() + delay;
			table.insert(delayedRemoveBuffs,t);
			return;
		else
			buff:RemoveBuff(name, GHUnitGUID("player"), count or 1,filter)
		end
	end

	class.RemoveAllBuffs = function()
		buff:ClearAllBuffs(GHUnitGUID("player"));
		delayedBuffs = {};
	end

	CheckTarget = function()
		local unit = "target";
		local name, realm = UnitName(unit)
		local legalPlayerUnit = not (strlower(unit) == "player") and UnitIsPlayer(unit);
		local factionAvailability = UnitIsFriend(unit, "PLAYER") or (UnitIsPlayer(unit) and #(GHI_VersionInfo().GetPlayerAddOns(UnitName(unit))) > 0);
		if legalPlayerUnit and factionAvailability and realm == nil then
			if type(subscriptionsSend[name]) == "number" and (GetTime() - subscriptionsSend[name]) < 60 * 3 then
				return;
			end
			comm.Send("NORMAL", name, "BuffSubscribe", 60 * 5)
			subscriptionsSend[name] = GetTime();
		end
	end

	BuffRecieveSubscription = function(sender, subscriptionTime, requestedFromWrathProtocol, ...)
		if requestedFromWrathProtocol and (subscribedPlayers[sender] or 0) + subscriptionTime > GetTime() then --v.1.3 change
			return;
		end
		subscribedPlayers[sender] = GetTime() + subscriptionTime;
		SendBuffInfo(sender);
	end
	comm.AddRecieveFunc("BuffSubscribe", BuffRecieveSubscription)

	SendBuffInfo = function(players)
		local guid = GHUnitGUID("player");
		local buffs, debuffs = buff:Serialize(guid);

		if type(players) == "string" then
			local name = players;
			players = {};
			players[name] = "dummy";
		end


		for name, _ in pairs(players) do
			comm.Send("NORMAL", name, "BuffInfo", guid, buffs, debuffs)
		end
	end

	BuffRecieveInfo = function(sender, guid, buffData, debuffData, ...)
		buff:Deserialize(guid, buffData, debuffData);
		if buffData == false then --v.1.3
			subscriptionsSend[sender] = nil;
		end
	end
	comm.AddRecieveFunc("BuffInfo", BuffRecieveInfo)

	BuffChanged = function(guid)
		if GHUnitGUID("player") == guid then
			UpdateBuffSubscriptions()
			SendBuffInfo(subscribedPlayers)
		end
	end


	UpdateBuffSubscriptions = function()
		for player, timeout in pairs(subscribedPlayers) do
			if timeout < GetTime() then
				subscribedPlayers[player] = nil;
			end
		end
	end

	buff:SetFeedbackFunc(BuffChanged)
	areaBuff.SetApplyBuffFunc(ApplyBuff);

	return class;
end

