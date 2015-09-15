

libMSPWrapper = {
	Update = function()
		return msp:Update();
	end
	Request = function(player, fields)
		return msp:Request(player, fields);
	end
	SetMy = function(values)
		msp.my = values;
	end
	GetOther = function(charName)
		return msp.char[charName];
	end
	AddReceivedAction = function(action)
		table.insert(msp.callback.received, action)
	end
	GetEmptyFieldsObj = function()
		return {};
	end
}
