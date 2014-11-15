


GHTest_TestHandler = function()

	local testResultCount = 0;

	local results = {};
	local tests = {};

	GHTest = {};

	local currentTest;
	local failureDetails;

	local ToString = function(var)
		if type(var) == "string" or type(var) == "number" or type(var) == "boolean" then
			return tostring(var).." ["..type(var).."]";
		end
		return tostring(var);
	end

	GHTest.Equals = function(expected, result, comment)
		if not(expected == result) then
			local res = ToString(result);
			local exp = ToString(expected);
			failureDetails = string.format("\nGot:\n%s (len: %s)\nExpected:\n%s (len: %s)\n%s",
				res,
				strlen(res),
				exp,
				strlen(exp),
				comment or "");
			error("Test failed");
		end
	end

	GHTest.AddTest = function(cat, name, func)
		if tests[cat..name] then
			error("Duplicated test name: "..cat..name);
		end
		tests[cat..name] = {
			func = func,
			name = name,
			cat = cat,
		}
	end

	local RunTest = function(name)
		currentTest = name;
		failureDetails = nil;

		local func = tests[name].func;
		local result, msg = pcall(func);
		if result == true then
			results[name] = true;
		else
			results[name] = failureDetails or msg;
		end
	end

	local RunAllTests = function()
		for name,_ in pairs(tests) do
			RunTest(name)
		end

		local total = 0;
		local failed = 0;
		for i, v in pairs(results) do
			total = total + 1;
			if not(results[i] == true) then
				print("Test failed:", tests[i].cat, tests[i].name, results[i])
				failed = failed + 1;
			end
		end
		print(string.format("%s tests run. %s failed.", total, failed))
	end

	GHI_Timer(RunAllTests, 2, true);
end
GHTest_TestHandler();