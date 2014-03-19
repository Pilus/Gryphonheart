--[[

local testFunctions = {};
local runNum = 0;


function GHI_RegisterTest(testName, v)
	testFunctions[testName] = v;
end

local currentTests;
local step;
function GHI_RunTests()
	print("Running unit tests.")
	runNum = runNum + 1;
	for i, v in pairs(testFunctions) do
		currentTests = i;
		step = 1;
		v(i, runNum);
	end
	print("Done")
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
		print(resultStr, testName, "Run", runNum, "Step", testStepNum, "(" .. (details or "") .. ")");
	else
		print(resultStr, testName, "Run", runNum, "Step", testStepNum);
	end
end

local ToString = function(var)
	if type(var) == "string" or type(var) == "number" or type(var) == "boolean" then
		return tostring(var).." ["..type(var).."]";
	end
	return tostring(var);
end

GHTest = {
	AddTest = GHI_RegisterTest,
	Equals = function(expected, result, comment)
		if expected == result then
			GHI_TestResult(currentTests, runNum, step, 2);
		else
			GHI_TestResult(currentTests, runNum, step, 4,
				string.format("\nGot:         %s\nExpected: %s. %s",
					ToString(result),
					ToString(expected),
					comment or ""));
		end
		step = step + 1;
	end,
}


GHI_Timer(function()
	if strlower(GetAddOnMetadata("GHI", "X-DevVersion")) == "true" then
		GHI_RunTests()
	end
end,2,true); --]]

