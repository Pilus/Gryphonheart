local Result = GHI_TestResult;
local PENDING = 1;
local PASSED = 2;
local WARNING = 3;
local FAILED = 4;

local name = "SetLayout_Scenario";

GHI_RegisterTest(name.."1", function(testSetName, runNum)
	local i=1;

	local set = GHI_DynamicActionInstanceSet();

	local instance1 = GHI_DynamicActionInstance("test_01");
	set.AddInstance(instance1);
	local instance2 = GHI_DynamicActionInstance("test_01");
	set.AddInstance(instance2);

	set.SetInstanceAtPort("onclick",instance1,"setup");

	instance1.SetPortConnection("out1",instance2,"setup");
	instance1.SetPortConnection("onsetup",instance2,"in1");
	instance1.SetPortConnection("out2",instance1,"in2");

	set.UpdateDisplayStructure();

	local x, y = set.GetInstanceCoordinates(instance1.GetGUID());

	local result = x;
	local expected = 3;
	if result == expected then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;

	local result = y;
	local expected = 1;
	if result == expected then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;

	local x, y = set.GetInstanceCoordinates(instance2.GetGUID());

	local result = x;
	local expected = 8;
	if result == expected then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;

	local result = y;
	local expected = 2;
	if result == expected then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;

	local result = set.GetNumConnections();
	local expected = 4;
	if result == expected then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;

	local connection1 = set.GetConnectionCoors(1);


end);

GHI_RegisterTest(name.."2", function(testSetName, runNum)
	local i=1;

	local set = GHI_DynamicActionInstanceSet();

	local instance1 = GHI_DynamicActionInstance("test_01");
	set.AddInstance(instance1);
	local instance2 = GHI_DynamicActionInstance("test_01");
	set.AddInstance(instance2);
	local instance3 = GHI_DynamicActionInstance("test_01");
	set.AddInstance(instance3);

	set.SetInstanceAtPort("onclick",instance1,"setup");

	instance1.SetPortConnection("onsetup",instance2,"setup");
	instance1.SetPortConnection("out1",instance3,"setup");
	instance2.SetPortConnection("onsetup",instance3,"in1");
	instance2.SetPortConnection("out1",instance3,"in2")
	instance3.SetPortConnection("onsetup",instance2,"in1");

	set.UpdateDisplayStructure();

	local x, y = set.GetInstanceCoordinates(instance1.GetGUID());

	local result = x;
	local expected = 3;
	if result == expected then
		Result(testSetName, runNum, i, PASSED);
	else
		Result(testSetName, runNum, i, FAILED,string.format("Got %s, expected %s.",result,expected));
	end
	i = i + 1;



end);