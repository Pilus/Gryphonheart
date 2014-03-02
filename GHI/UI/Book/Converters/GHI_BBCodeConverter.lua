--===================================================
--
--				GHI_BBCodeConverter
--  			GHI_BBCodeConverter.lua
--
--	A converter between simple HTML and the
--	BBCode mockup. Following the interface:
--		- ToMockup(simpleHtml)
--		- ToSimpleHtml(mockup)
--
-- 		(c)2014 The Gryphonheart Team
--			All rights reserved
--===================================================

local class;
function GHI_BBCodeConverter()
	if class then
		return class;
	end
	class = GHClass("GHI_BBCodeConverter");

	local htmlDeserial = GHI_HtmlDeserializer();
	local bbcodeDeserial = GHI_BBCodeDeserializer();

	local EntityEscapeString = function(str)
		str = gsub(str, "&", "&amp;")
		str = gsub(str, "<", "&lt;")
		str = gsub(str, ">", "&gt;")
		str = gsub(str, '"', "&quot;")
		str = gsub(str, "\n", "</br>")
		return str;
	end

	local RemoveEntityEscapeString = function(str)
		str = gsub(str, "&lt;", "<")
		str = gsub(str, "&gt;", ">")
		str = gsub(str, "&quot;", '"')
		str = gsub(str, "&amp;", "&")
		str = gsub(str, "</br>", "\n")
		return str;
	end


	local tableToMockup, tableToHtml;

	local ConvertAllWithEvtTag = function(t, tag)
		local s, close = "", "";
		if tag then
			s = "["..tag.."]";
			close = "[/"..tag.."]";
		end
		for i=1,#(t) do
			s = s..tableToMockup(t[i]);
		end
		return s..close;
	end

	tableToMockup = function(t)
		if type(t) == "string" then
			return t;
		end
		if t.tag == "html" then
			return tableToMockup(t[1] or "");
		elseif t.tag == "body" then
			return tableToMockup(t[1] or "");
		elseif t.tag == "p" then
			return ConvertAllWithEvtTag(t, t.args.align);
		elseif t.tag == "br" then
			return "/n";
		elseif t.tag == "h1" or t.tag == "h2" or t.tag == "h3" then
			return ConvertAllWithEvtTag(t, t.tag);
		elseif t.tag == "img" then
			return string.format("[img width=%s height=%]%s[/img]", t.args[2], t.args[3], t.args[1]);
		elseif t.tag == "a" then
			return string.format("[link=%s]%s[/link]", t.args.href, tableToMockup(t.args[1]))
		elseif t.tag == "color" then
			return string.format("[color=#%s]%s[/color]", t.args[1], tableToMockup(t[1]));
		elseif t.tag == "" then
			-- todo: more tags.
		elseif t.tag == nil and #(t) == 1 then
			return tableToMockup(t[1])
		else
			local s = string.format("[%s", t.tag);
			for i,v in pairs(t.args) do
				if string.find(v, " ") then
					s = string.format("%s %s=\"%s\"", s, i, v);
				else
					s = string.format("%s %s=%s", s, i, v);
				end
			end

			if #(t) > 0 then
				s = s .. "]";
				for i=1,#(t) do
					s = s..tableToHtml(t[i]);
				end
				s = s .. "[/" .. t.tag .. "]";
			else
				s = s .. "/]";
			end
			return s;
		end
	end

	class.ToMockup = function(simpleHtml)
		local t = htmlDeserial.HtmlToTable(simpleHtml);
		local mock = tableToMockup(t);
		return RemoveEntityEscapeString(mock);
	end

	local CheckCustomObjSize = function(t)
		if t.args.x and t.args.y then
			return t.args.x, t.args.y;
		end
		return 0, 0;
	end

	local ConvertAllWithEvtTag = function(t, tag)
		local open, close = "", "";
		if tag then
			open = "<"..tag..">";
			close = "</"..tag..">";
		end
		local s = "";

		for i=1,#(t) do
			local str, skipOpen, skipClose = tableToHtml(t[i],  t.tag, (t[i-1] or {tag="none"}).tag, (t[i+1] or {tag="none"}).tag);
			if skipOpen then open = ""; end
			if skipClose then close = ""; end
			s = s .. str;
		end
		return open..s..close;
	end

	tableToHtml = function(t, parentTag, prevTag, nextTag)
		if type(t) == "string" then
			return t;
		end

		if t.tag == "h1" or t.tag == "h2" or t.tag == "h3" then
			local before, after = "", "";
			if parentTag == "body" and prevTag == nil then before = "</p>"; end
			if parentTag == "body" and nextTag == nil then after = "<p>"; end
			return before..ConvertAllWithEvtTag(t, t.tag)..after;
		elseif t.tag == "body" then
			local s = "";
			if t[1] and t[1].tag == nil then
				s = "<p>";
			end
			for i= 1,#(t) do
				s = s..tableToHtml(t[i], t.tag, (t[i-1] or {tag="none"}).tag, (t[i+1] or {tag="none"}).tag);
			end
			if t[#(t)] and t[#(t)].tag == nil then
				s = s.."</p>";
			end
			return s;
		elseif t.tag == "left" or t.tag == "right" then
			local tag = parentTag == "body" and "p" or parentTag;
			local s;
			if prevTag == "none" then
				s = string.format("<%s align=\"%s\">", tag, t.tag);
			else
				s = string.format("</%s><%s align=\"%s\">", tag, tag, t.tag);
			end

			for i=1,#(t) do
				s = s..tableToHtml(t[i]);
			end

			if nextTag == "none" then
				s = s..string.format("</%s>", tag);
			else
				s = s..string.format("</%s><%s>", tag, tag);
			end
			return s, prevTag == "none", nextTag == "none";
		else
			local x, y = CheckCustomObjSize(t);
			local inner = string.format("<%s", t.tag);
			for i,v in pairs(t.args) do
				inner = string.format("%s %s=\"%s\"", inner, i, v);
			end

			if #(t) > 0 then
				inner = inner .. ">";
				for i=1,#(t) do
					inner = inner..tableToHtml(t[i]);
				end
				inner = inner .. "</" .. t.tag .. ">";
			else
				inner = inner .. "/>";
			end

			return string.format("\124T:%s:%s:%s\124t", x, y, inner);
		end
	end

	local AppendHtmlAndBodyTags = function(text)
		return "<html><body>"..text.."</body></html>";
	end

	class.ToSimpleHtml = function(mockup)
		local escaped = EntityEscapeString(mockup);
		local table = bbcodeDeserial.BBCodeToTable(escaped);
		table.tag = "body";
		local text = tableToHtml(table);
		--local blocks = ConvertTagsToBlocks(escaped, 0, nil, nil, "body")
		--local text = ConvertBlocksToText(blocks, true);
		return AppendHtmlAndBodyTags(text);
	end

	return class;
end

-- Unit tests



