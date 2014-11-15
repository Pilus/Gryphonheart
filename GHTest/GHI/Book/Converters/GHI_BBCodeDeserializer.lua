local name = "GHI_BBCodeDeserializer";

GHTest.AddTest(name, "ShouldHandleSingleTagsWithoutArguments", function()
	local bbcode2Table = GHI_BBCodeDeserializer();

	local r = bbcode2Table.BBCodeToTable("[br/]");
	GHTest.Equals(1, #(r));
	GHTest.Equals(nil, r[1][1]);
	GHTest.Equals("br", r[1].tag);
end);

GHTest.AddTest(name, "ShouldHandleSingleTagsWithArgumentsInQuotes", function()
	local bbcode2Table = GHI_BBCodeDeserializer();

	local r = bbcode2Table.BBCodeToTable('[map x="14.23" text="abc"/]');
	GHTest.Equals(1, #(r));
	GHTest.Equals("map", r[1].tag);
	GHTest.Equals("table", type(r[1].args));

	GHTest.Equals(14.23, r[1].args.x);
	GHTest.Equals("abc", r[1].args.text);
end);

GHTest.AddTest(name, "ShouldHandleSingleTagsWithArgumentsWithoutQuotes", function()
	local bbcode2Table = GHI_BBCodeDeserializer();

	local r = bbcode2Table.BBCodeToTable('[map x=14.23 text=abc/]');
	GHTest.Equals(1, #(r));
	GHTest.Equals("map", r[1].tag);
	GHTest.Equals("table", type(r[1].args));

	GHTest.Equals(14.23, r[1].args.x);
	GHTest.Equals("abc", r[1].args.text);
end);

GHTest.AddTest(name, "ShouldHandleSingleCharStrings", function()
	local bbcode2Table = GHI_BBCodeDeserializer();

	local r = bbcode2Table.BBCodeToTable('x');
	GHTest.Equals(1, #(r));
	GHTest.Equals("x", r[1]);
end);

GHTest.AddTest(name, "ShouldHandleSlashesInText", function()
	local bbcode2Table = GHI_BBCodeDeserializer();

	local r = bbcode2Table.BBCodeToTable('a/b\\c');
	GHTest.Equals(1, #(r));
	GHTest.Equals("a/b\\c", r[1]);
end);

GHTest.AddTest(name, "ShouldHandleSymbolsInArgs", function()
	local bbcode2Table = GHI_BBCodeDeserializer();

	local r = bbcode2Table.BBCodeToTable('[map x=14.23 text="x<a>b/c-d{e}f\\g_h"/]');
	GHTest.Equals(1, #(r));
	GHTest.Equals("map", r[1].tag);
	GHTest.Equals("x<a>b/c-d{e}f\\g_h", r[1].args.text);
end);