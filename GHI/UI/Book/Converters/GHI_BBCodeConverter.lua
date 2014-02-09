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

	local MinimumTags;

	local OPEN_REGEX = "%[([%a%d]+)%]";
	local CLOSE_REGEX = function(tag) return "%[/"..tag.."%]"; end


	local HtmlToTable;
	HtmlToTable = function(html)

	end

	class.ToMockup = function(simpleHtml)
		return simpleHtml;
	end

	local BuildOpenTag = function(meta, first)
		if meta.tag == "left" or meta.tag == "right" or meta.tag == "center" then
			local actualTag = meta.parent;
			if MinimumTags[actualTag] then
				actualTag = MinimumTags[actualTag];
				return string.format('<%s align="%s">', actualTag, meta.tag);
			elseif first then
				return string.format('<%s align="%s">', actualTag, meta.tag), true;
			else
				return string.format('</%s><%s align="%s">', actualTag, actualTag, meta.tag);
			end
		end
		return "<"..meta.tag..">";
	end

	local BuildCloseTag = function(meta, last)
		if meta.tag == "left" or meta.tag == "right" or meta.tag == "center" then
			local actualTag = meta.parent;
			if MinimumTags[actualTag] then
				actualTag = MinimumTags[actualTag];
				return string.format("</%s>", actualTag, actualTag);
			elseif last then
				return string.format("</%s>", actualTag, actualTag), true;
			else
				return string.format("</%s><%s>", actualTag, actualTag);
			end
		end
		return "</"..meta.tag..">";
	end

	local ConvertBlocksToText
	ConvertBlocksToText = function(blocks, first, last)
		if type(blocks) == "string" then
			return blocks;
		end
		local openTag, closeTag = "", "";
		local skipFirst, skipLast;
		if blocks.meta then
			openTag, skipFirst = BuildOpenTag(blocks.meta, first);
			closeTag, skipLast = BuildCloseTag(blocks.meta, last);
		end

		local body = "";
		for i=1,#(blocks) do
			local blockBody, skip = ConvertBlocksToText(blocks[i], i==1, i==#(blocks));
			body = body .. blockBody;

			if skip then
				if i == 1 then
					openTag = "";
				elseif i==#(blocks) then
					closeTag = "";
				end
			end
		end

		return openTag..body..closeTag,
		(first and skipFirst) or (last and skipLast);
	end

	MinimumTags = {
		body = "p",
	};

	local ConvertTagsToBlocks;
	ConvertTagsToBlocks = function(text, i, j, meta, parentTag)
		local blocks = {
			meta = meta,
		};
		local subMeta;
		if MinimumTags[parentTag] then
			subMeta = {
				tag = MinimumTags[parentTag],
				parent = parentTag,
			};
		end
		while (i) do
			local tagOpenStart, tagOpenEnd, tag = string.find(text, OPEN_REGEX, i);
			if not(tagOpenStart) then
				if i < (j or string.len(text))+1 then
					table.insert(blocks, {
						string.sub(text, i, j),
						meta = subMeta,
					});
				end
				break;
			else
				if i < tagOpenStart then
					table.insert(blocks, {
						string.sub(text, i, tagOpenStart - 1),
						meta = subMeta,
					});
				end

				local tagCloseStart, tagCloseEnd = string.find(text, CLOSE_REGEX(tag), tagOpenEnd);

				if not(tagCloseStart) then
					table.insert(blocks, ConvertTagsToBlocks(text, tagOpenEnd, j));
					break;
				else
					table.insert(blocks, ConvertTagsToBlocks(text, tagOpenEnd+1, tagCloseStart-1, {
						tag = tag,
						parent = parentTag,
					}, tag))
					i = tagCloseEnd+1;
				end
			end
		end
		return blocks;
	end

	local AppendHtmlAndBodyTags = function(text)
		return "<html><body>"..text.."</body></html>";
	end

	class.ToSimpleHtml = function(mockup)
		local blocks = ConvertTagsToBlocks(mockup, 0, nil, nil, "body")

		return AppendHtmlAndBodyTags(ConvertBlocksToText(blocks, true));
	end

	return class;
end

-- Unit tests



