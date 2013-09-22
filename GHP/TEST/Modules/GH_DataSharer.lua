

describe("GH_DataSharer",function()
	require("StandardMock");
	require("CommunicationClientSimulation");
	require("GH_DataSharer");


	it("should load libs",function()
		strmatch = string.match;
		require("LibStub");
		require("AceSerializer");
	end);

	--[[
	it("the communication simulator should work correctly",function()

		local bob = CommunicationClient("Bob");
		local alice = CommunicationClient("Alice");

		local receive = spy.new(function() end);

		alice.AddRecieveFunc("TEST",receive);

		bob.Send(nil,"Alice","TEST",{"data"},"more data");
		bob.Update(0.1);

		assert.spy(receive).was.called(1);
		assert.spy(receive).was.called_with("Bob",{"data"},"more data");


	end);  --]]

	-- Mock for getting the active players
	local ACTIVE_PLAYERS = {};
	GHI_VersionInfo = function()
   		return {
			GetAllPlayers = function(addonShort)
				if addonShort == "GHP" then
					local t = {};
					for _,v in pairs(ACTIVE_PLAYERS) do
						table.insert(t,v);
					end
					return t;
				end
			end
		};
	end

	GHI_Timer = function()
	end

	GHI_ChannelComm = function()
		return {
			Send = function()
			end,
			AddRecieveFunc = function()
			end,
		}
	end

	it("should implement DatasetChanged(guid)",function()
		GHI_Comm = function()
			return {
				Send = function() end,
				AddRecieveFunc = function() end,
			}
		end

		local ds = GH_DataSharer("GHP","9F1AE67CD",function()end,function()end,function()end);
		assert.are.same(type(ds.DatasetChanged),"function");

	end);

	it("should send GH_UpdatedData up a call to dataset changed",function()

		local SETGUID = "9F1AE67CD";
		local SUBSETGUID = "9F1AEDA0B";
		local DATA = {"dataset for test",test=42,test2=43 }
		local DATA2;
		local VERSION = 24;

		ACTIVE_PLAYERS = {"PlayerC","PlayerB","PlayerD"}

        local getFunction = function(guid)
			if guid == SUBSETGUID then
				return {
					GetVersion = function() return VERSION; end,
					Serialize = function() return DATA; end,
				};
			elseif guid == "Subset2" then
				return {
					GetVersion = function() return VERSION; end,
					Serialize = function() return DATA2; end,
				};
			end
		end

		local sendSpy;
		local sendData = {}
		GHI_Comm = function()
			local c = {
				Send = spy.new(function(prio,target,tag,subsetGuid, version, players, data,num,total)
				 	sendData[subsetGuid] = sendData[subsetGuid] or {};
					sendData[subsetGuid][num] = data;
				end),
				AddRecieveFunc = function() end,
			}
			sendSpy = c.Send;
			return c;
		end

		local ds = GH_DataSharer("GHP",SETGUID,getFunction,function()end,function()end);

		assert.are.same("table",type(sendSpy))
		assert.spy(sendSpy).was.called(0);

		ds.DatasetChanged(SUBSETGUID);

		assert.spy(sendSpy).was.called(1);
		--UpdatedData (setGuid, subsetGuid, version, players, busyPlayers, data, isLast)
		local serializedData = LibStub("AceSerializer-3.0"):Serialize(DATA);
		assert.spy(sendSpy).was.called_with("BULK","PlayerC","GH_UpdatedData_"..SETGUID,SUBSETGUID,VERSION,{"PlayerB","PlayerD"},serializedData,1,1);

		-- It should split the data into chunks if it is too large
		DATA2 = { string.rep("It should split the data into chunks if it is too large",100)};


		ds.DatasetChanged("Subset2");
		assert.spy(sendSpy).was.called(8);

		assert.are.same(7,#(sendData["Subset2"]));
		local str = "";
		for i=1,#(sendData["Subset2"]) do
			str = str..sendData["Subset2"][i];
		end
		local success,d = LibStub("AceSerializer-3.0"):Deserialize(str);
		assert.are.same(DATA2,d);
		--]]
	end);

	it("should register a function listening to GH_UpdatedData",function()

		local regFunc;
		local SETGUID = "9F1B21B7C";

		GHI_Comm = function()
			return {
				Send = function() end,
				AddRecieveFunc = function(prefix,func)
					if prefix == "GH_UpdatedData_"..SETGUID then
						regFunc = func;
					end
				end
			}
		end

		local ds = GH_DataSharer("GHP",SETGUID,function()end,function()end,function()end);
		assert.are.same("function",type(regFunc));

	end);

	it("should act correctly upon receiving GH_UpdatedData",function()

		local regFunc,sendSpy;

		local SETGUID = "9F1AE67CD";

		GHI_Comm = function()
			sendSpy = spy.new(function() end);
			return {
				Send = sendSpy,
				AddRecieveFunc = function(prefix,func)
					if prefix == "GH_UpdatedData_"..SETGUID then
						regFunc = func;
					end
				end,
				GetQueueSize = function()
					return 0;
				end,
			}
		end

		local serializer = LibStub("AceSerializer-3.0");

		local OBJS = {};
		local SET_DATA = {};
		local getFunc = function(guid)
			return OBJS[guid];
		end

		local setFunc = function(guid,data)
			SET_DATA[guid] = data;
		end

		local ds = GH_DataSharer("GHP",SETGUID,getFunc,setFunc,function()end);

		-- CASE 1: Data is not existing
		local SUBSETGUID = "Subset1";
		local DATA = {"abc","9F1B1BC62" }
		local dataStr = serializer:Serialize(DATA);
		regFunc("PlayerA",SUBSETGUID,2,{"NextPlayer","LastPlayer"},string.sub(dataStr,0,7),1,2);
		regFunc("PlayerA",SUBSETGUID,2,{"NextPlayer","LastPlayer"},string.sub(dataStr,8),2,2);

		assert.are.same(DATA,SET_DATA[SUBSETGUID]);
		assert.spy(sendSpy).was.called_with("BULK","NextPlayer","GH_UpdatedData_"..SETGUID,SUBSETGUID,2,{"LastPlayer"},string.sub(dataStr,0,7),1,2);
		assert.spy(sendSpy).was.called_with("BULK","NextPlayer","GH_UpdatedData_"..SETGUID,SUBSETGUID,2,{"LastPlayer"},string.sub(dataStr,8),2,2);

		-- CASE 2: Own version is lower
		local SUBSETGUID = "Subset2";
		local DATA = {"abc9F1DABE01","9F1DABEBB" }
		local dataStr = serializer:Serialize(DATA);
		OBJS[SUBSETGUID] = {
			GetVersion = function() return 3; end,
		}

		regFunc("PlayerA",SUBSETGUID,4,{"NextPlayer2","LastPlayer"},string.sub(dataStr,0,7),1,2);
		regFunc("PlayerA",SUBSETGUID,4,{"NextPlayer2","LastPlayer"},string.sub(dataStr,8),2,2);

		assert.are.same(DATA,SET_DATA[SUBSETGUID]);
		assert.spy(sendSpy).was.called_with("BULK","NextPlayer2","GH_UpdatedData_"..SETGUID,SUBSETGUID,4,{"LastPlayer"},string.sub(dataStr,0,7),1,2);
		assert.spy(sendSpy).was.called_with("BULK","NextPlayer2","GH_UpdatedData_"..SETGUID,SUBSETGUID,4,{"LastPlayer"},string.sub(dataStr,8),2,2);

		-- CASE 3: Same version
		local SUBSETGUID = "Subset3";
		local DATA = {"abc9F1DABE019F1DB2EB9","9F1DB2F49" }
		local dataStr = serializer:Serialize(DATA);
		OBJS[SUBSETGUID] = {
			GetVersion = function() return 4; end,
		}

		regFunc("PlayerA",SUBSETGUID,4,{"NextPlayer2","LastPlayer"},string.sub(dataStr,0,7),1,2);
		regFunc("PlayerA",SUBSETGUID,4,{"NextPlayer2","LastPlayer"},string.sub(dataStr,8),2,2);

		assert.are.same(nil,SET_DATA[SUBSETGUID]);
		assert.spy(sendSpy).was.called_with("BULK","NextPlayer2","GH_UpdatedData_"..SETGUID,SUBSETGUID,4,{"LastPlayer"},string.sub(dataStr,0,7),1,2);
		assert.spy(sendSpy).was.called_with("BULK","NextPlayer2","GH_UpdatedData_"..SETGUID,SUBSETGUID,4,{"LastPlayer"},string.sub(dataStr,8),2,2);


		-- CASE 4: Newer version
		local SUBSETGUID = "Subset4";
		local DATA = {"abc9F9F1DB64332EB9","9F1DB64AA" }
		local DATA_NEW = {"9F1DB6985","9F1DB69D2"}
		local dataStr = serializer:Serialize(DATA);
		local newDataStr = serializer:Serialize(DATA_NEW);
		OBJS[SUBSETGUID] = {
			GetVersion = function() return 6; end,
			Serialize = function() return DATA_NEW; end,
		}
		ACTIVE_PLAYERS = {"PlayerA","PlayerC","PlayerD"}


		regFunc("PlayerA",SUBSETGUID,4,{"PlayerX","PlayerY"},string.sub(dataStr,0,7),1,2);
		regFunc("PlayerA",SUBSETGUID,4,{"PlayerX","PlayerY"},string.sub(dataStr,8),2,2);

		assert.are.same(nil,SET_DATA[SUBSETGUID]);
		assert.spy(sendSpy).was.called_with("BULK","PlayerA","GH_UpdatedData_"..SETGUID,SUBSETGUID,6,{"PlayerC","PlayerD"},newDataStr,1,1);

	end);

	it("Should handle long queue",function()
		local regFunc,sendSpy,queueFullRegFunc;

		local SETGUID = "9F1AE67CD";
		local QUEUE_SIZE = 0;
		GHI_Comm = function()
			sendSpy = spy.new(function() end);
			return {
				Send = sendSpy,
				AddRecieveFunc = function(prefix,func)
					if prefix == "GH_UpdatedData_"..SETGUID then
						regFunc = func;
					elseif prefix == "GH_QueueFull_"..SETGUID then
						queueFullRegFunc = func;
					end
				end,
				GetQueueSize = function()
					return QUEUE_SIZE;
				end,
			}
		end

		local serializer = LibStub("AceSerializer-3.0");

		local OBJS = {};
		local SET_DATA = {};
		local getFunc = function(guid)
			return OBJS[guid];
		end

		local setFunc = function(guid,data)
			SET_DATA[guid] = data;
		end

		local ds = GH_DataSharer("GHP",SETGUID,getFunc,setFunc,function()end);

		local SUBSETGUID = "Subset5";
		local DATA = {"abc","9F1B1BC62" }
		local dataStr = serializer:Serialize(DATA);
		QUEUE_SIZE = 10000;

		assert.spy(sendSpy).was.called(0);
		regFunc("PlayerA",SUBSETGUID,2,{"NextPlayer","LastPlayer"},string.sub(dataStr,0,7),1,2);
		regFunc("PlayerA",SUBSETGUID,2,{"NextPlayer","LastPlayer"},string.sub(dataStr,8),2,2);

		assert.are.same(DATA,SET_DATA[SUBSETGUID]);
		assert.spy(sendSpy).was.called(1);
		assert.spy(sendSpy).was.called_with("ALERT","PlayerA","GH_QueueFull_"..SETGUID,SUBSETGUID);

		-- Sending client rerouting data when a queuefull message is received
		local ds = GH_DataSharer("GHP",SETGUID,getFunc,setFunc,function()end);

		local SUBSETGUID = "Subset6";
		local DATA = {"9F202DEFD","9F202DE92" ,"9F202E7619F202E7839F202E7969F202E7A49F202E7B1"}
		local dataStr = serializer:Serialize(DATA);
		QUEUE_SIZE = 0;

		assert.spy(sendSpy).was.called(0);
		regFunc("PlayerA",SUBSETGUID,2,{"PlayerC","PlayerD","PlayerE"},string.sub(dataStr,0,7),1,3);
		regFunc("PlayerA",SUBSETGUID,2,{"PlayerC","PlayerD","PlayerE"},string.sub(dataStr,8,16),2,3);
		assert.spy(sendSpy).was.called(2);
		assert.spy(sendSpy).was.called_with("BULK","PlayerC","GH_UpdatedData_"..SETGUID,SUBSETGUID,2,{"PlayerD","PlayerE"},string.sub(dataStr,0,7),1,3);
		assert.spy(sendSpy).was.called_with("BULK","PlayerC","GH_UpdatedData_"..SETGUID,SUBSETGUID,2,{"PlayerD","PlayerE"},string.sub(dataStr,8,16),2,3);

		-- playerC sends back that his queue is full
		queueFullRegFunc("PlayerC",SUBSETGUID);
		assert.spy(sendSpy).was.called(4);
		assert.spy(sendSpy).was.called_with("BULK","PlayerD","GH_UpdatedData_"..SETGUID,SUBSETGUID,2,{"PlayerE"},string.sub(dataStr,0,7),1,3);
		assert.spy(sendSpy).was.called_with("BULK","PlayerD","GH_UpdatedData_"..SETGUID,SUBSETGUID,2,{"PlayerE"},string.sub(dataStr,8,16),2,3);

		-- following received messages should then be relayed to both player C and D
		regFunc("PlayerA",SUBSETGUID,2,{"PlayerC","PlayerD","PlayerE"},string.sub(dataStr,17),3,3);
		assert.spy(sendSpy).was.called(6);
		assert.spy(sendSpy).was.called_with("BULK","PlayerC","GH_UpdatedData_"..SETGUID,SUBSETGUID,2,{},string.sub(dataStr,17),3,3);
		assert.spy(sendSpy).was.called_with("BULK","PlayerD","GH_UpdatedData_"..SETGUID,SUBSETGUID,2,{"PlayerE"},string.sub(dataStr,17),3,3);
	end);


	it("should send message to the channel with current versions",function()
		local SETGUID = "9F2314BFE";

		local VERSIONS = {
			subguid1 = 43,
			subguid2 = 24,
		}

		ACTIVE_PLAYERS = {"PlayerC","PlayerB","PlayerD"}

		local getFunction = function(guid)
			return {
				GetVersion = function() return VERSIONS[guid]; end,
				Serialize = function() return {}; end,
			};
		end

		local getAllGuidFunc = function()
			local t = {};
			for i,v in pairs(VERSIONS) do
				table.insert(t,i);
			end
			return t;
		end

		GHI_Comm = function()
			local c = {
				Send = function() end,
				AddRecieveFunc = function() end,
			}
			return c;
		end

		local sendSpy;
		GHI_ChannelComm = function()
			local c = {
				Send = spy.new(function() end),
				AddRecieveFunc = function() end,
			}
			sendSpy = c.Send;
			return c;
		end

		local ds = GH_DataSharer("GHP",SETGUID,getFunction,function()end,getAllGuidFunc);
		assert.spy(sendSpy).was.called(1);
		assert.spy(sendSpy).was.called_with("ALERT","GH_DataVersions_"..SETGUID,VERSIONS);


	end);

	it("should react correctly to received versions",function()
		local SETGUID = "9F2A8ED70";

		local sendSpy;
		GHI_Comm = function()
			local c = {
				Send =  spy.new(function() end),
				AddRecieveFunc = function() end,
			}
			sendSpy = c.Send;
			return c;
		end

		local channelReceiveFunc;
		GHI_ChannelComm = function()
			local c = {
				Send = spy.new(function() end),
				AddRecieveFunc = function(prefix,func)
					if prefix == "GH_DataVersions_"..SETGUID then
						channelReceiveFunc = func;
					end
				end,
			}
			return c;
		end

		local VERSIONS = {
			newerGuid = 43,
			olderGuid = 24,
			sameGuid = 15,
			exclusiveGuid = 30,
		}

		local DATA = {
			newerGuid = {"test" },
			exclusiveGuid = {string.rep("long long string with a lot of data",40)},
		}

		local getAllGuidFunc = function()
			local t = {};
			for guid,_ in pairs(VERSIONS) do
				table.insert(t,guid);
			end
			return t;
		end

		local getFunction = function(guid)
			if VERSIONS[guid] then
				return {
					GetVersion = function() return VERSIONS[guid]; end,
					Serialize = function() return DATA[guid]; end,
				};
			end
		end

		local ds = GH_DataSharer("GHP",SETGUID,getFunction,function()end,getAllGuidFunc);

		channelReceiveFunc("PlayerA",{newerGuid = 20, olderGuid = 30, sameGuid = 15, notexistingGuid = 3});
		assert.spy(sendSpy).was.called(2);
		assert.spy(sendSpy).was.called_with("ALERT","PlayerA","GH_DataOffer_"..SETGUID,{newerGuid = 43,exclusiveGuid = 30},{newerGuid = 1,exclusiveGuid=2});
		assert.spy(sendSpy).was.called_with("ALERT","PlayerA","GH_DataRequest_"..SETGUID,{"olderGuid","notexistingGuid"});

	end);

	it("should receive offers for new versions after sending out its versions",function()
		local SETGUID = "9F2314BFE";

		local VERSIONS = {
			subguid1 = 43,
			subguid2 = 24,
		}

		ACTIVE_PLAYERS = {"PlayerC","PlayerB","PlayerD"}

		local getFunction = function(guid)
			return {
				GetVersion = function() return VERSIONS[guid]; end,
				Serialize = function() return {}; end,
			};
		end

		local getAllGuidFunc = function()
			local t = {};
			for i,v in pairs(VERSIONS) do
				table.insert(t,i);
			end
			return t;
		end

		local sendSpy,receiveOfferFunc;
		GHI_Comm = function()
			local c = {
				Send =  spy.new(function() end),
				AddRecieveFunc = function(prefix,func)
					if prefix == "GH_DataOffer_"..SETGUID then
						receiveOfferFunc = func;
					end
				end,
			}
			sendSpy = c.Send;
			return c;
		end

		local channelSendSpy,channelReceiveFunc;
		GHI_ChannelComm = function()
			local c = {
				Send = spy.new(function() end),
				AddRecieveFunc = function(prefix,func)
					if prefix == "GH_DataVersions_"..SETGUID then
						channelReceiveFunc = func;
					end
				end,
			}
			channelSendSpy = c.Send;
			return c;
		end

		local timerFunc,timerInterval;
		GHI_Timer = function(func,interval)
			timerFunc,timerInterval = func,interval;
		end

		local ds = GH_DataSharer("GHP",SETGUID,getFunction,function()end,getAllGuidFunc);
		assert.spy(channelSendSpy).was.called(1);
		assert.spy(channelSendSpy).was.called_with("ALERT","GH_DataVersions_"..SETGUID,VERSIONS);

		assert.are.same("function",type(receiveOfferFunc));

		receiveOfferFunc("PlayerB",{subguid1 = 50,somethingNew = 24,somethingInCommon = 10},{somethingInCommon = 5})
		receiveOfferFunc("PlayerC",{subguid1 = 45,subguid2 = 48,somethingInCommon = 10},{somethingInCommon = 5})

		assert.are.same("function",type(timerFunc));
		assert.are.same(10,timerInterval);

		assert.spy(sendSpy).was.called(0);

		timerFunc();

		assert.spy(sendSpy).was.called(2);
		assert.spy(sendSpy).was.called_with("ALERT","PlayerB","GH_DataRequest_"..SETGUID,{"somethingNew",{guid="somethingInCommon",pieces={2,4}},"subguid1"});
		assert.spy(sendSpy).was.called_with("ALERT","PlayerC","GH_DataRequest_"..SETGUID,{{guid="somethingInCommon",pieces={1,3,5}},"subguid2"});



	end);

	it("should handle received requests",function()
		local SETGUID = "9F2314BFE";

		local VERSIONS = {
			subguid1 = 43,
			subguid2 = 24,
		}

		local DATA = {
			subguid1 = {"test1"},
			subguid2 = {string.rep("some long text that is going to be repeated several times",18)}
		}

		local serializer = LibStub("AceSerializer-3.0");
		local dataStr1 = serializer:Serialize(DATA.subguid1);
		local dataStr2 = serializer:Serialize(DATA.subguid2);

		ACTIVE_PLAYERS = {"PlayerC","PlayerB","PlayerD"}

		local getFunction = function(guid)
			if VERSIONS[guid] then
				return {
					GetVersion = function() return VERSIONS[guid]; end,
					Serialize = function() return DATA[guid]; end,
				};
			end
		end

		local getAllGuidFunc = function()
			local t = {};
			for i,v in pairs(VERSIONS) do
				table.insert(t,i);
			end
			return t;
		end

		local sendSpy,receiveRequestFunc;
		GHI_Comm = function()
			local c = {
				Send =  spy.new(function() end),
				AddRecieveFunc = function(prefix,func)
					if prefix == "GH_DataRequest_"..SETGUID then
						receiveRequestFunc = func;
					end
				end,
			}
			sendSpy = c.Send;
			return c;
		end

		local channelSendSpy,channelReceiveFunc;
		GHI_ChannelComm = function()
			local c = {
				Send = spy.new(function() end),
				AddRecieveFunc = function(prefix,func)
					channelReceiveFunc = func;
				end,
			}
			channelSendSpy = c.Send;
			return c;
		end

		local timerFunc,timerInterval;
		GHI_Timer = function(func,interval)
			timerFunc,timerInterval = func,interval;
		end

		local ds = GH_DataSharer("GHP",SETGUID,getFunction,function()end,getAllGuidFunc);
		assert.spy(channelSendSpy).was.called(1);
		assert.spy(channelSendSpy).was.called_with("ALERT","GH_DataVersions_"..SETGUID,VERSIONS);

		assert.are.same("function",type(receiveRequestFunc));

		receiveRequestFunc("PlayerB",{"subguid1",{guid="subguid2",pieces={2}},"something not existing"});

		assert.are.same("function",type(timerFunc));
		assert.are.same(10,timerInterval);

		assert.spy(sendSpy).was.called(0);

		timerFunc();

		assert.spy(sendSpy).was.called(2);
		assert.spy(sendSpy).was.called_with("BULK","PlayerB","GH_UpdatedData_"..SETGUID,"subguid1",43,{},dataStr1,1,1);
		assert.spy(sendSpy).was.called_with("BULK","PlayerB","GH_UpdatedData_"..SETGUID,"subguid2",24,{},string.sub(dataStr2,1024,2047),2,2);

		-- request after timer have hit
		receiveRequestFunc("PlayerB",{"subguid2"});

		assert.spy(sendSpy).was.called(4);
		assert.spy(sendSpy).was.called_with("BULK","PlayerB","GH_UpdatedData_"..SETGUID,"subguid2",24,{},string.sub(dataStr2,0,1023),1,2);
		assert.spy(sendSpy).was.called_with("BULK","PlayerB","GH_UpdatedData_"..SETGUID,"subguid2",24,{},string.sub(dataStr2,1024,2047),2,2);


	end)

	-- many requests for the same data  => scenario 1
	it("should use scnario 1 if receiving more than X requests for the same dataset",function()
		local SETGUID = "9F2314BFE";

		local VERSIONS = {
			subguid1 = 43,
			subguid2 = 24,
		}

		local DATA = {
			subguid1 = {"test1"},
			subguid2 = {string.rep("some long text that is going to be repeated several times",18)}
		}

		local serializer = LibStub("AceSerializer-3.0");
		local dataStr1 = serializer:Serialize(DATA.subguid1);
		local dataStr2 = serializer:Serialize(DATA.subguid2);

		ACTIVE_PLAYERS = {"PlayerC","PlayerB","PlayerD"}

		local getFunction = function(guid)
			if VERSIONS[guid] then
				return {
					GetVersion = function() return VERSIONS[guid]; end,
					Serialize = function() return DATA[guid]; end,
				};
			end
		end

		local getAllGuidFunc = function()
			local t = {};
			for i,v in pairs(VERSIONS) do
				table.insert(t,i);
			end
			return t;
		end

		local sendSpy,receiveRequestFunc;
		GHI_Comm = function()
			local c = {
				Send =  spy.new(function() end),
				AddRecieveFunc = function(prefix,func)
					if prefix == "GH_DataRequest_"..SETGUID then
						receiveRequestFunc = func;
					end
				end,
			}
			sendSpy = c.Send;
			return c;
		end

		local channelSendSpy,channelReceiveFunc;
		GHI_ChannelComm = function()
			local c = {
				Send = spy.new(function() end),
				AddRecieveFunc = function(prefix,func)
					channelReceiveFunc = func;
				end,
			}
			channelSendSpy = c.Send;
			return c;
		end

		local timerFunc,timerInterval;
		GHI_Timer = function(func,interval)
			timerFunc,timerInterval = func,interval;
		end

		local ds = GH_DataSharer("GHP",SETGUID,getFunction,function()end,getAllGuidFunc);
		assert.spy(channelSendSpy).was.called(1);
		assert.spy(channelSendSpy).was.called_with("ALERT","GH_DataVersions_"..SETGUID,VERSIONS);

		assert.are.same("function",type(receiveRequestFunc));

		receiveRequestFunc("PlayerB",{"subguid2"});
		receiveRequestFunc("PlayerC",{"subguid2"});
		receiveRequestFunc("PlayerD",{"subguid2"});

		assert.spy(sendSpy).was.called(0);


		timerFunc();

		assert.spy(sendSpy).was.called(2);
		assert.spy(sendSpy).was.called_with("BULK","PlayerB","GH_UpdatedData_"..SETGUID,"subguid2",24,{"PlayerC","PlayerD"},string.sub(dataStr2,0,1023),1,2);
		assert.spy(sendSpy).was.called_with("BULK","PlayerB","GH_UpdatedData_"..SETGUID,"subguid2",24,{"PlayerC","PlayerD"},string.sub(dataStr2,1024,2047),2,2);

		-- request after timer have hit
		receiveRequestFunc("PlayerB",{"subguid2"});

		assert.spy(sendSpy).was.called(4);
		assert.spy(sendSpy).was.called_with("BULK","PlayerB","GH_UpdatedData_"..SETGUID,"subguid2",24,{},string.sub(dataStr2,0,1023),1,2);
		assert.spy(sendSpy).was.called_with("BULK","PlayerB","GH_UpdatedData_"..SETGUID,"subguid2",24,{},string.sub(dataStr2,1024,2047),2,2);
	end)


	it("should implement a lock",function()
		local SETGUID = "9F2DBBC58";
		local sendSpy,dataLockFunc,dataUnlockFunc;
		GHI_ChannelComm = function()
			local c = {
				Send = spy.new(function() end),
				AddRecieveFunc = function(prefix,func)
					if prefix == "GH_DataLock_"..SETGUID then
						dataLockFunc = func;
					elseif prefix == "GH_DataUnlock_"..SETGUID then
						dataUnlockFunc = func;
					end
				end,
			}
			sendSpy = c.Send;
			return c;
		end

		local ds = GH_DataSharer("GHP",SETGUID,function() end,function()end,function()end);

		assert.are.same("function",type(ds.RequestLock));
		assert.are.same("function",type(ds.ReleaseLock));

		local SUB_GUID = "9F2DB88C8";

		local result = nil;
		local lockFunc = function(_result)
			result = _result;
		end


		local NAME = "PlayerA"
		UnitName = function()
			return NAME;
		end

		-- default usage
		ds.RequestLock(SUB_GUID,lockFunc);
		assert.are.same(nil,result);
		assert.spy(sendSpy).was.called(2);
		assert.spy(sendSpy).was.called_with("ALERT","GH_DataLock_"..SETGUID,SUB_GUID);

		assert.are.same("function",type(dataLockFunc))
		dataLockFunc(NAME,SUB_GUID);
		assert.are.same(true,result);

		-- unlocks
		ds.ReleaseLock(SUB_GUID);
		assert.spy(sendSpy).was.called(3);
		assert.spy(sendSpy).was.called_with("ALERT","GH_DataUnlock_"..SETGUID,SUB_GUID);

		-- someone else locks first
		result = nil;
		SUB_GUID = "9F2DC3D06";

		ds.RequestLock(SUB_GUID,lockFunc);
		assert.are.same(nil,result);

		dataLockFunc("Someone else",SUB_GUID);
		assert.are.same(false,result)


		result = nil;
		dataUnlockFunc("Someone else",SUB_GUID)
		assert.are.same(nil,result);
		ds.RequestLock(SUB_GUID,lockFunc);
		dataLockFunc(NAME,SUB_GUID);
		assert.are.same(true,result);

	end)


	local TEST_PLAYER_AMOUNT = 10;
	local TEST_DATA_SIZE = 1;

	it("should work on a larger scale aswell",function()
		local PrepareClient = function(name)
			local client = CommunicationClient(name);
			GHI_Comm = function()
				return {
					Send = client.Send,
					AddRecieveFunc = client.AddRecieveFunc,
					GetQueueSize = function()
						return 0;
					end,
				}
			end
			GHI_ChannelComm = function()
				return {
					Send = client.ChannelSend,
					AddRecieveFunc = client.AddRecieveFunc,
					GetQueueSize = function()
						return 0;
					end,
				}
			end
			return client;
		end



		local SETGUID = "MASS_TEST";
		local SUBSETGUID = "9F207CA15";
		local DATA = {string.rep("9F2083FE39F208408A9F20840A49F20840B19F20840BD",TEST_DATA_SIZE)};
		--assert.are.True(string.len(DATA[1]))
		local getFunc = function(subsetguid)
			if subsetguid == SUBSETGUID then
				return {
					Serialize = function()
						return DATA;
					end,
					GetVersion = function()
						return 1;
					end,
				}
			end
		end





		local client = PrepareClient("Player1");
		local dataSharers = {};
		dataSharers[1] = GH_DataSharer("GHP",SETGUID,getFunc,function()end,function() return {SUBSETGUID}; end,true);
		dataSharers[1].client = client;
		ACTIVE_PLAYERS = {};

		local recievedData = {};
		local SetFunc = function(index,g,data)
			recievedData[index] = data;
		end
		local getAllFunc = function(index)     --  assert.are.same(recievedData[index] ,index)
			if recievedData[index] then
				return {SUBSETGUID};
			end
			return {};
		end

		for i=2,TEST_PLAYER_AMOUNT do
			local timerFunc,timerInterval;
			GHI_Timer = function(func,interval)
				timerFunc,timerInterval = func,interval;
			end
			local client = PrepareClient("Player"..i);
			dataSharers[i] = GH_DataSharer("GHP",SETGUID,function(guid)
				if recievedData[i] then
					return getFunc(guid)
				end
			end,function(g,data) SetFunc(i,g,data) end,function() return getAllFunc(i) end);
			dataSharers[i].client = client;
			table.insert(ACTIVE_PLAYERS,"Player"..i);
			timerFunc();
		end

		local UpdateAll = function(dt)
			for i=#(dataSharers),1,-1 do
				local ds = dataSharers[i];
				ds.client.Update(dt);
			end
		end

		for i=1,1000 do
			UpdateAll(0.1);
		end

		-- Share the data
		dataSharers[1].DatasetChanged(SUBSETGUID);

		local c = 0;
		while recievedData[TEST_PLAYER_AMOUNT] == nil and c <= 10000 do
			UpdateAll(0.01);
			c = c + 0.01;

			if recievedData[10] then
				--assert.are.same("reached",c)
			end
		end

		if c < 10000 then
			for i=2,TEST_PLAYER_AMOUNT do
				assert.are.not_equal(recievedData[TEST_PLAYER_AMOUNT],nil)
			end
			--assert.are.True(DEBUG_LOG);
			assert.are.same(DATA,recievedData[TEST_PLAYER_AMOUNT])
		end
		--assert.are.True(c);  -- implement this line to get a message with the time result.


		-- SCENARIO 2 - A new player comes online and needs to be updated
		dataSharers[1].client.Disable();

		local timerFunc,timerInterval;
		GHI_Timer = function(func,interval)
			timerFunc,timerInterval = func,interval;
		end

		DEBUG3 = "";

		local client = PrepareClient("NewGuy");
		local newDS = GH_DataSharer("GHP",SETGUID,function()end,function(g,data) SetFunc("NewGuy",g,data) end,function()end,false);
		newDS.client = client;
		table.insert(dataSharers,newDS)
		table.insert(ACTIVE_PLAYERS,"NewGuy");

		UpdateAll(1);
		UpdateAll(1);
		UpdateAll(1);
		UpdateAll(1);
		UpdateAll(1);

		-- trigger the timed evalute function

		timerFunc();

		local c = 0;
		while recievedData["NewGuy"] == nil and c <= 100 do
			UpdateAll(0.001);
			c = c + 0.001;
		end

		--assert.are.True(c..DEBUG3);

	end);


	it("large scale native reference test",function()

		local SETGUID = "MASS_TEST";
		local SUBSETGUID = "9F207CA15";
		local DATA = {string.rep("9F2083FE39F208408A9F20840A49F20840B19F20840BD",TEST_DATA_SIZE)};
		local serializer = LibStub("AceSerializer-3.0");
		local c = 0;

		local clients = {};
		for i=1,TEST_PLAYER_AMOUNT do
			clients[i] = CommunicationClient("Player"..i);
		end
		clients[1].Done = true;


		clients[1].AddRecieveFunc("DataReq",function(sender,guid)
			local serializedData = serializer:Serialize(DATA);
			clients[1].Send("BULK",sender,"Data",guid,serializedData);
		end);

		for i=2,TEST_PLAYER_AMOUNT do
			clients[i].AddRecieveFunc("NewData",function(sender,guid,version)
				clients[i].Send("ALERT",sender,"DataReq",guid);
			end);

			clients[i].AddRecieveFunc("Data",function(sender,guid,data)
				clients[i].Done = true;
			end);
		end

		clients[1].ChannelSend("ALERT","NewData","9F3067C30",42);

		local UpdateAll = function(dt)
			for i=#(clients),1,-1 do
				clients[i].Update(dt);
			end
		end

		local AllDone = function()
			for _,client in pairs(clients) do
				if not(client.Done==true) then
					return false;
				end
			end
			return true;
		end


		while c <= 10000 do
			UpdateAll(0.01);
			c = c + 0.01;
			if AllDone() then
				break;
			end
		end

		--assert.are.True(c);


		-- Scenario 2
		local c = 0;

		local clientA = CommunicationClient("PlayerA");
		local clientB = CommunicationClient("PlayerB");


		clientB.AddRecieveFunc("DataReq",function(sender,guid,version)
			local serializedData = serializer:Serialize(DATA);
			clientB.Send("BULK",sender,"Data",guid,serializedData);
		end);

		local DONE = false;
		clientA.AddRecieveFunc("Data",function(sender,guid,data)
			DONE = true;
		end);

		clientA.Send("BULK","PlayerB","DataReq",SETGUID,3);

		while c <= 100 do
			clientA.Update(0.001);
			clientB.Update(0.001);
			c = c + 0.001;
			if DONE then
				break;
			end
		end

		--assert.are.True(c);

	end);
end);