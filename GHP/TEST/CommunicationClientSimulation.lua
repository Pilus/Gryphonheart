--
-- Created by IntelliJ IDEA.
-- User: Pilus
-- Date: 22-04-13
-- Time: 10:53
-- To change this template use File | Settings | File Templates.
--

local Clone;
Clone = function(v)
	if type(v) == "table" then
		local t = {};
		for i,vv in pairs(v) do
			t[i] = Clone(vv);
		end
		return t;
	end
	return v;
end

local cclist;
function CommunicationClientList()
	if cclist then
		return cclist;
	end

	cclist = {};

	local clients = {};

	cclist.AddClient = function(client)
		clients[client.GetName()] = client;
	end

	cclist.GetClient = function(name)
		return clients[name];
	end

	cclist.GetAll = function()
		local t = {};
		for i,v in pairs(clients) do
			t[i] = v;
		end
		return t;
	end

	return cclist;
end



function CommunicationClient(name)
	local client = {};
	local enabled = true;
	client.GetName = function()
		return name;
	end

	local sendingBuffer = {};

	client.Send = function(prio, target, prefix,...)
		if prio == "ALERT" then
			table.insert(sendingBuffer,1,{target, prefix,...});
		else
			table.insert(sendingBuffer,{target, prefix,...});
		end
	end

	client.ChannelSend = function(prio, prefix,...)
		if prio == "ALERT" then
			table.insert(sendingBuffer,1,{"channel", prefix,...});
		else
			table.insert(sendingBuffer,{"channel", prefix,...});
		end
	end


	local receiveFunctions = {};

	client.AddRecieveFunc = function(_prefix, _recieveFunc)
		receiveFunctions[_prefix] = _recieveFunc;
	end

	client.Receive = function(prefix,sender,...)
		if receiveFunctions[prefix] and enabled then
			receiveFunctions[prefix](sender,unpack(Clone({...})));
		end
	end


	local DataSize;
	DataSize = function(data)
		local ty = type(data);
		if ty == "string" then
			return string.len(data)
		elseif ty == "table" then
			local size = 10;
			for i,v in pairs(data) do
				size = size + DataSize(v);
			end
			return size;
		end
		return 1;
	end

	local BANDWIDTH_PR_SEC = 1024;

	local bandwidth = BANDWIDTH_PR_SEC;
	local c = 0;
	client.Update = function(deltaT)
		if not(enabled) then return end;
		if math.floor(c + deltaT) > math.floor(c) then
			if #(sendingBuffer) > 0 then
				bandwidth = bandwidth + BANDWIDTH_PR_SEC
			else
				bandwidth = BANDWIDTH_PR_SEC
			end
		end
		c = c + deltaT;

		while (true) do
			local first = sendingBuffer[1];
			if first then
				local target,prefix,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14 = unpack(first)

				local size = DataSize({arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14});

				if size <= bandwidth then
					table.remove(sendingBuffer,1);

					if target == "channel" then
				   		local all = CommunicationClientList().GetAll();
						for _,client in pairs(all) do
							client.Receive(prefix,name,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14);
						end
					else
						local targetClient = CommunicationClientList().GetClient(target);
						targetClient.Receive(prefix,name,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14);
					end
					bandwidth = bandwidth - size;
				else
					break;
				end
			else
				break;
			end
		end
	end

	client.Disable = function()
		enabled = false;
	end

	CommunicationClientList().AddClient(client);
	return client;

end

