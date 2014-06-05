local name = "GHI_BBCodeConverter_";

GHTest.AddTest(name, "ShouldImplementTheCorrectInterface", function()
	GHTest.Equals("function",type(GHI_BBCodeConverter),"GHI_BBCodeConverter should be a class")
	local converter = GHI_BBCodeConverter();

	GHTest.Equals("function",type(converter.ToMockup),"It should implement a .ToMockup function");
	GHTest.Equals("function",type(converter.ToSimpleHtml),"It should implement a .ToSimpleHtml function");
end);

GHTest.AddTest(name, "ShouldConvertPlainTextIntoPlainTextInBothWays", function()
	local converter = GHI_BBCodeConverter();
	local mockup = "First text < 4 \\5 \\> f";

	local html = converter.ToSimpleHtml(mockup);
	GHTest.Equals("<HTML><BODY><P>First text &lt; 4 \\5 \\&gt; f</P></BODY></HTML>", html)

	local mockup2 = converter.ToMockup(html);
	GHTest.Equals(mockup, mockup2);
end);

GHTest.AddTest(name, "ShouldConvertNestedTags", function()
	local converter = GHI_BBCodeConverter();

	GHTest.Equals('<HTML><BODY><P>t</P><H1>x</H1><P>å</P></BODY></HTML>',
	converter.ToSimpleHtml("t[h1]x[/h1]å"));

	GHTest.Equals('<HTML><BODY><H1>x</H1></BODY></HTML>',
		converter.ToSimpleHtml("[h1]x[/h1]"));
end);

GHTest.AddTest(name, "ShouldConvertNestedTagsNotBreakingP", function()
	local converter = GHI_BBCodeConverter();

	GHTest.Equals('<HTML><BODY><P>t\124T:0:0:<A>x\124T:0:0:<B>y\124T:0:0:<C>z</C>\124tæ</B>\124tø</A>\124tå</P></BODY></HTML>',
	converter.ToSimpleHtml("t[a]x[b]y[c]z[/c]æ[/b]ø[/a]å"));
end);

GHTest.AddTest(name, "ShouldConvertH1Correctly", function()
	local converter = GHI_BBCodeConverter();

	GHTest.Equals('<HTML><BODY><P>Some</P><H1>Head line</H1><P>after</P></BODY></HTML>',
		converter.ToSimpleHtml("Some[h1]Head line[/h1]after"));
end);


GHTest.AddTest(name, "ShouldConvertAlignmentCorrectly", function()
	local converter = GHI_BBCodeConverter();

	GHTest.Equals('<HTML><BODY><P>Before</P><P align="LEFT">To the left</P><P>after</P></BODY></HTML>',
		converter.ToSimpleHtml("Before[left]To the left[/left]after"));

	GHTest.Equals('<HTML><BODY><P>Before</P><H1>Head </H1><H1 align="LEFT">To the left</H1><H1>Line</H1><P>after</P></BODY></HTML>',
			converter.ToSimpleHtml("Before[h1]Head [left]To the left[/left]Line[/h1]after"));

	GHTest.Equals('<HTML><BODY><P>Before</P><H1 align="LEFT">To the left</H1><P>after</P></BODY></HTML>',
				converter.ToSimpleHtml("Before[h1][left]To the left[/left][/h1]after"));
end);     --]]


GHTest.AddTest(name, "ShouldConvertH1Correctly", function()
	local converter = GHI_BBCodeConverter();

	GHTest.Equals('<HTML><BODY><P>Some</P><H1>Head line</H1><P>after</P></BODY></HTML>',
		converter.ToSimpleHtml("Some[h1]Head line[/h1]after"));
end);

GHTest.AddTest(name, "ShouldConvertArgumentsCorrectly", function()
	local converter = GHI_BBCodeConverter();

	local bbCode = "Some[obj arg1=A]Text[/obj]after";

	local html = converter.ToSimpleHtml(bbCode);
	GHTest.Equals('<HTML><BODY><P>Some\124T:0:0:<OBJ arg1="A">Text</OBJ>\124tafter</P></BODY></HTML>', html);

	local bbCode2 = converter.ToMockup(html);
	GHTest.Equals(bbCode, bbCode2);
end);
