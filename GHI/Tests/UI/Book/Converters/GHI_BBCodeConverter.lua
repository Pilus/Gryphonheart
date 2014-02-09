local name = "GHI_BBCodeConverter_";

GHTest.AddTest(name.."ShouldImplementTheCorrectInterface", function()
	GHTest.Equals("function",type(GHI_BBCodeConverter),"GHI_BBCodeConverter should be a class")
	local converter = GHI_BBCodeConverter();

	GHTest.Equals("function",type(converter.ToMockup),"It should implement a .ToMockup function");
	GHTest.Equals("function",type(converter.ToSimpleHtml),"It should implement a .ToSimpleHtml function");
end);

GHTest.AddTest(name.."ShouldConvertPlainTextIntoPlainTextInBothWays", function()
	local converter = GHI_BBCodeConverter();
	local simpleHtml = "First text < 4 \\5 \\> f";
	local mockup = converter.ToMockup(simpleHtml);

	GHTest.Equals("<html><body><p>First text < 4 \\5 \\> f</p></body></html>", mockup)

	local simple2 = converter.ToSimpleHtml(mockup);
	GHTest.Equals(mockup, simple2);
end);

GHTest.AddTest(name.."ShouldConvertNestedTags", function()
	local converter = GHI_BBCodeConverter();

	GHTest.Equals('<html><body><p>t</p><a>x<b>y<c>z</c>æ</b>ø</a><p>å</p></body></html>',
		converter.ToSimpleHtml("t[a]x[b]y[c]z[/c]æ[/b]ø[/a]å"));

end);

GHTest.AddTest(name.."ShouldConvertHnCorrectlyIncludingAlignment", function()
	local converter = GHI_BBCodeConverter();

	GHTest.Equals('<html><body><p>Some</p><h1 align="c">Head line</h1><p>after</p></body></html>',
		converter.ToSimpleHtml("Some[h1]Head line[/h1]after"));
end);

