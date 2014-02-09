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

	local OPEN_REGEX = "%[(%a+)%]";
	local CLOSE_REGEX = function(tag) return "%[/"..tag.."%]"; end

	class.ToMockup = function(simpleHtml)
		return simpleHtml;
	end

	local ConvertBlocksToText
	ConvertBlocksToText = function(blocks)
		if type(blocks) == "string" then
			return blocks;
		end
		local s = "";
		if blocks.meta then
			s = "<"..blocks.meta.tag..">";
		end

		for i=1,#(blocks) do
			s = s..ConvertBlocksToText(blocks[i]);
		end

		if blocks.meta then
			s = s.."</"..blocks.meta.tag..">";
		end

		return s;
	end

	local ConvertTagsToBlocks;
	ConvertTagsToBlocks = function(text, i, j, meta)
		local blocks = {
			meta = meta,
		};
		while (i) do
			local tagOpenStart, tagOpenEnd, tag = string.find(text, OPEN_REGEX, i);
			if not(tagOpenStart) then
				table.insert(blocks, string.sub(text, i, j));
				break;
			else
				table.insert(blocks, string.sub(text, i, tagOpenStart - 1));

				local tagCloseStart, tagCloseEnd = string.find(text, CLOSE_REGEX(tag), tagOpenEnd);

				if not(tagCloseStart) then
					table.insert(blocks, ConvertTagsToBlocks(text, tagOpenEnd, j));
					break;
				else
					table.insert(blocks, ConvertTagsToBlocks(text, tagOpenEnd+1, tagCloseStart-1, {tag = tag, }))
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
		local blocks = ConvertTagsToBlocks(mockup, 0)

		return AppendHtmlAndBodyTags(ConvertBlocksToText(blocks));
	end

	return class;
end

-- Unit tests



