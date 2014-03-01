local name = "GHI_BBCodeConverter_";

GHTest.AddTest(name.."ShouldImplementTheCorrectInterface", function()
	GHTest.Equals("function",type(GHI_BBCodeConverter),"GHI_BBCodeConverter should be a class")
	local converter = GHI_BBCodeConverter();

	GHTest.Equals("function",type(converter.ToMockup),"It should implement a .ToMockup function");
	GHTest.Equals("function",type(converter.ToSimpleHtml),"It should implement a .ToSimpleHtml function");
end);

GHTest.AddTest(name.."ShouldConvertPlainTextIntoPlainTextInBothWays", function()
	local converter = GHI_BBCodeConverter();
	local mockup = "First text < 4 \\5 \\> f";

	local html = converter.ToSimpleHtml(mockup);
	GHTest.Equals("<html><body><p>First text &lt; 4 \\5 \\&gt; f</p></body></html>", html)

	local mockup2 = converter.ToMockup(html);
	GHTest.Equals(mockup, mockup2);
end);

GHTest.AddTest(name.."ShouldConvertNestedTags", function()
	local converter = GHI_BBCodeConverter();

	GHTest.Equals('<html><body><p>t</p><h1>x</h1><p>å</p></body></html>',
	converter.ToSimpleHtml("t[h1]x[/h1]å"));

	GHTest.Equals('<html><body><h1>x</h1></body></html>',
		converter.ToSimpleHtml("[h1]x[/h1]"));
end);

GHTest.AddTest(name.."ShouldConvertNestedTagsNotBreakingP", function()
	local converter = GHI_BBCodeConverter();

	GHTest.Equals('<html><body><p>t\124T:0:0:<a>x\124T:0:0:<b>y\124T:0:0:<c>z</c>\124tæ</b>\124tø</a>\124tå</p></body></html>',
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

	GHTest.Equals('<html><body><p>Before</p><h1 align="left">To the left</h1><p>after</p></body></html>',
				converter.ToSimpleHtml("Before[h1][left]To the left[/left][/h1]after"));
end);     --]]


GHTest.AddTest(name.."ShouldConvertH1Correctly", function()
	local converter = GHI_BBCodeConverter();

	GHTest.Equals('<html><body><p>Some</p><h1>Head line</h1><p>after</p></body></html>',
		converter.ToSimpleHtml("Some[h1]Head line[/h1]after"));
end);

GHTest.AddTest(name.."ShouldConvertArgumentsCorrectly", function()
	local converter = GHI_BBCodeConverter();

	local bbCode = "Some[obj arg1=A]Text[/obj]after";

	local html = converter.ToSimpleHtml(bbCode);
	GHTest.Equals('<html><body><p>Some\124T:0:0:<obj arg1="A">Text</obj>\124tafter</p></body></html>', html);

	local bbCode2 = converter.ToMockup(html);
	GHTest.Equals(bbCode, bbCode2);
end);
