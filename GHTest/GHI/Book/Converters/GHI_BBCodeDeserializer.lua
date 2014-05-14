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