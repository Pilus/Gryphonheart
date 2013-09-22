local Result = GHI_TestResult;
local PENDING = 1;
local PASSED = 2;
local WARNING = 3;
local FAILED = 4;

local name = "GHM_Highlight_";

GHI_RegisterTest(name.."Comment1", function(testSetName, runNum)
	local i=1;

	local text = "abc--def";
	local expected = "abc"..GHM_ColorSyntax("--def","comment");
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;

	local text = "af abc--def. ef\nej";
	local expected = "af abc"..GHM_ColorSyntax("--def. ef","comment").."\nej";
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;

	local text = "af abc--def--[[. e]]f\nej";
	local expected = "af abc"..GHM_ColorSyntax("--def--[[. e]]f","comment").."\nej";
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;
end);

GHI_RegisterTest(name.."Comment2", function(testSetName, runNum)
	local i=1;

	local text = "abc--[[def]]";
	local expected = "abc"..GHM_ColorSyntax("--[[def]]","comment");
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;

	local text = "af abc--[[def. ef\nej]]e\ns";
	local expected = "af abc"..GHM_ColorSyntax("--[[def. ef\nej]]","comment").."e\ns";
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;
end);

GHI_RegisterTest(name.."String1", function(testSetName, runNum)
	local i=1;

	local text = "abc 'test'";
	local expected = "abc "..GHM_ColorSyntax("'test'","string");
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;

	local text = "af abc 'test' def";
	local expected = "af abc "..GHM_ColorSyntax("'test'","string").." def";
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;
end);

GHI_RegisterTest(name.."String2", function(testSetName, runNum)
	local i=1;

	local text = 'abc "test"';
	local expected = "abc "..GHM_ColorSyntax('"test"',"string");
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;

	local text = 'af abc "test" def';
	local expected = "af abc "..GHM_ColorSyntax('"test"',"string").." def";
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;
end);

GHI_RegisterTest(name.."String3", function(testSetName, runNum)
	local i=1;

	local text = 'abc [[test]]';
	local expected = "abc "..GHM_ColorSyntax('[[test]]',"string");
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;

	local text = 'af abc [[test]] def';
	local expected = "af abc "..GHM_ColorSyntax('[[test]]',"string").." def";
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;

	local text = 'af abc [[te\nst]] def';
	local expected = "af abc "..GHM_ColorSyntax('[[te\nst]]',"string").." def";
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;

	local text = 'af abc [[te\nst]] def';
	local expected = "af abc "..GHM_ColorSyntax('[[te\nst]]',"string").." def";
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;

	local text = 'af abc-[[te\nst]] def';
	local expected = "af abc-"..GHM_ColorSyntax('[[te\nst]]',"string").." def";
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;
end);


GHI_RegisterTest(name.."Number1", function(testSetName, runNum)
	local i=1;

	local text = "abc 80.2 a";
	local expected = "abc "..GHM_ColorSyntax("80.2","number").." a";
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;

	local text = "abc[3] a";
	local expected = "abc["..GHM_ColorSyntax("3","number").."] a";
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got '%s', expected '%s'.",result,expected));
	end
	i = i + 1;

	local text = "abc=3/2;";
	local expected = "abc="..GHM_ColorSyntax("3","number").."/"..GHM_ColorSyntax("2","number")..";";
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got '%s', expected '%s'.",result,expected));
	end
	i = i + 1;
end);

GHI_RegisterTest(name.."Keyword", function(testSetName, runNum)
	local i=1;

	local text = "abc and def";
	local expected = "abc "..GHM_ColorSyntax("and","keyword").." def";
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;

	local text = "if true then";
	local expected = GHM_ColorSyntax("if","keyword").." "..GHM_ColorSyntax("true","boolean").." "..GHM_ColorSyntax("then","keyword");
	local result = GHM_HighlightKeywords(text);
	if expected == result then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got '%s', expected '%s'.",result,expected));
	end
	i = i + 1;

end);

