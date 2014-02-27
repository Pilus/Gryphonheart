local name = "GHI_HtmlDeserializer";

GHTest.AddTest(name.."ShouldHandleSingleTagsWithoutArguments", function()
	local html2Table = GHI_HtmlDeserializer();

	local r = html2Table.HtmlToTable("<br/>");
	GHTest.Equals(1, #(r));
	GHTest.Equals("br", r[1].tag);
end);

GHTest.AddTest(name.."ShouldHandleSingleTagsWithArguments", function()
	local html2Table = GHI_HtmlDeserializer();

	local r = html2Table.HtmlToTable('<map x="14.23" text="abc"/>');
	GHTest.Equals(1, #(r));
	GHTest.Equals("map", r[1].tag);
	GHTest.Equals("table", type(r[1].args));

	GHTest.Equals(14.23, r[1].args.x);
	GHTest.Equals("abc", r[1].args.text);
end);

GHTest.AddTest(name.."ShouldHandleNestedSimpleTags", function()
	local html2Table = GHI_HtmlDeserializer();

	local r = html2Table.HtmlToTable("<something><br/></something>");
	GHTest.Equals(1, #(r));
	GHTest.Equals("something", r[1].tag);
	GHTest.Equals(1, #(r[1]));
	GHTest.Equals("br", r[1][1].tag);
end);

GHTest.AddTest(name.."ShouldHandleNestedTagsWithArgs", function()
	local html2Table = GHI_HtmlDeserializer();

	local r = html2Table.HtmlToTable('<something a="b"><sub c="d"></sub><test/></something>');
	GHTest.Equals(1, #(r));
	GHTest.Equals("something", r[1].tag);
	GHTest.Equals("b", r[1].args["a"]);
	GHTest.Equals(2, #(r[1]));
	GHTest.Equals("sub", r[1][1].tag);
	GHTest.Equals("d", r[1][1].args["c"]);
	GHTest.Equals("test", r[1][2].tag);
end);


GHTest.AddTest(name.."ShouldHandleTextInsideTags", function()
	local html2Table = GHI_HtmlDeserializer();

	local r = html2Table.HtmlToTable("<h1>Testing text</h1>");
	GHTest.Equals(1, #(r));
	GHTest.Equals("h1", r[1].tag);
	GHTest.Equals("Testing text", r[1][1]);
end);

GHTest.AddTest(name.."ShouldHandleTextInsideTagsMixedWithTags", function()
	local html2Table = GHI_HtmlDeserializer();

	local r = html2Table.HtmlToTable("<h1>Testing <br/>text<p>Of something</p>doom</h1>");
	GHTest.Equals(1, #(r));
	GHTest.Equals("h1", r[1].tag);
	GHTest.Equals(5, #(r[1]));
	GHTest.Equals("Testing ", r[1][1]);
	GHTest.Equals("br", r[1][2].tag);
	GHTest.Equals("text", r[1][3]);
	GHTest.Equals("p", r[1][4].tag);
	GHTest.Equals("Of something", r[1][4][1]);
	GHTest.Equals("doom", r[1][5]);
end);

GHTest.AddTest(name.."ShouldHandleMultipleObjects", function()
	local html2Table = GHI_HtmlDeserializer();

	local r = html2Table.HtmlToTable("Before<h1>Testing text</h1>After<br/>Last");
	GHTest.Equals(5, #(r));
	GHTest.Equals("Before", r[1]);
	GHTest.Equals("h1", r[2].tag);
	GHTest.Equals("Testing text", r[2][1]);
	GHTest.Equals("After", r[3]);
	GHTest.Equals("br", r[4].tag);
	GHTest.Equals("Last", r[5]);
end);

GHTest.AddTest(name.."ShouldHandlePlainText", function()
	local html2Table = GHI_HtmlDeserializer();

	local r = html2Table.HtmlToTable("Testing");
	GHTest.Equals(1, #(r));
	GHTest.Equals("Testing", r[1]);
end);

GHTest.AddTest(name.."Should turn t into img.", function()
	local html2Table = GHI_HtmlDeserializer();

	local r = html2Table.HtmlToTable("Before\124TInterface\\Icons\\INV_Misc_Coin_01:16:20\124tafter");
	GHTest.Equals(3, #(r));
	GHTest.Equals("Before", r[1]);
	GHTest.Equals("img", r[2].tag);
	GHTest.Equals("Interface\\Icons\\INV_Misc_Coin_01", r[2].args.texture);
	GHTest.Equals(16, r[2].args.w);
	GHTest.Equals(20, r[2].args.h);
	GHTest.Equals("after", r[3]);
end);
