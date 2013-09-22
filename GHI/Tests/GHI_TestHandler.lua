local testFunctions = {};
local runNum = 0;


function GHI_RegisterTest(testName, v)
	testFunctions[testName] = v;
end

function GHI_RunTests()
	print("Running unit tests.")
	runNum = runNum + 1;
	for i, v in pairs(testFunctions) do
		v(i, runNum);
	end
end



local resultStrings = {
	{ "Pending", 0.5, 0.5, 0.5 },
	{ "Passed", 0, 1, 0 },
	{ "Warning", 0.7, 0.7, 0 },
	{ "Failed", 1, 0, 0 },
}

function GHI_TestResult(testName, runNum, testStepNum, result, details)
	local misc = GHI_MiscAPI().GetAPI();
	local resultStr = misc.GHI_ColorString(unpack(resultStrings[result] or {}));
	if details then
		print("Test", testName, "Run", runNum, "Step", testStepNum, "=", resultStr, "(" .. (details or "") .. ")");
	else
		print("Test", testName, "Run", runNum, "Step", testStepNum, "=", resultStr);
	end
end

--[[
GHI_Timer(function()
	if UnitName("player") == "Bhitz" then
		GHI_RunTests()
	end
end,2,true); --]]

