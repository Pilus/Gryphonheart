local name = "GHI_BBCodeConverter_";

GHTest.AddTest(name.."ShouldImplementTheCorrectInterface", function()
	GHTest.Equals("function",type(GHI_BBCodeConverter),"GHI_BBCodeConverter should be a class")
	local converter = GHI_BBCodeConverter();

	GHTest.Equals("function",type(converter.ToMockup),"It should implement a .ToMockup function");
	GHTest.Equals("function",type(converter.ToSimpleHtml),"It should implement a .ToSimpleHtml function");
end);

--[[
GHTest.AddTest(name.."ShouldConvertPlainTextIntoPlainTextInBothWays", function()
	local converter = GHI_BBCodeConverter();
	local simpleHtml = "<html><body><p>First text < 4 \\5 \\> f</p></body></html>";
	local mockup = converter.ToMockup(simpleHtml);

	GHTest.Equals("First text < 4 \\5 \\> f", mockup)

	local simple2 = converter.ToSimpleHtml(mockup);
	GHTest.Equals(mockup, simple2);
end); --]]

GHTest.AddTest(name.."ShouldConvertNestedTags", function()
	local converter = GHI_BBCodeConverter();

	GHTest.Equals('<html><body><p>t</p><a>x<b>y<c>z</c>æ</b>ø</a><p>å</p></body></html>',
	converter.ToSimpleHtml("t[a]x[b]y[c]z[/c]æ[/b]ø[/a]å"));

end);

GHTest.AddTest(name.."ShouldConvertH1Correctly", function()
	local converter = GHI_BBCodeConverter();

	GHTest.Equals('<html><body><p>Some</p><h1>Head line</h1><p>after</p></body></html>',
		converter.ToSimpleHtml("Some[h1]Head line[/h1]after"));
end);

GHTest.AddTest(name.."ShouldConvertAlignmentCorrectly", function()
	local converter = GHI_BBCodeConverter();

	GHTest.Equals('<html><body><p>Before</p><p align="left">To the left</p><p>after</p></body></html>',
		converter.ToSimpleHtml("Before[left]To the left[/left]after"));

	GHTest.Equals('<html><body><p>Before</p><h1>Head </h1><h1 align="left">To the left</h1><h1>Line</h1><p>after</p></body></html>',
			converter.ToSimpleHtml("Before[h1]Head [left]To the left[/left]Line[/h1]after"));

	GHTest.Equals('<html><body><p>Before</p><h1 align="left">To the left</h1></h1><p>after</p></body></html>',
				converter.ToSimpleHtml("Before[h1][left]To the left[/left][/h1]after"));
end);

