--===================================================
--
--				GHI_DOC_TextureData
--  			GHI_DOC_TextureData.lua
--
--	          (description)
--
-- 	  (c)2013 The Gryphonheart Team
--			All rights reserved
--===================================================

--===================================================
--								Document Texture Data
--===================================================
-- Textures for document material and backgrounds

--[[ Glossary:
 - Material: The texture right behind the text. e.g. parchment
 - Background: The background behind the material. E.g. a wooden board or a Color
 - Template: A whole ghu_document set up for a specific purpose
 - Collection: A set of textures, forming a meterial or background

--]]


local textures = {};
local collections = {};

function GHI_DOC_GetCollectionCats()

end

function GHI_DOC_GetCollectionNames(cat)

end

function GHI_DOC_GetCollection(catagory,name) -- gives all texture objects in the collection
	for cat,cols in pairs(collections) do
		if cat == catagory then
			for _,col in pairs(cols) do
				if col.name == name then
					local t={};
					for i=1,#(col) do
						local path = col[i].path;
						if path then
							local width,height = 64,64;
							if textures[path] then
								width,height = textures[path][1] or 64,textures[path][2] or 64; -- 64x64 are standard
							end
							t[i] = GHI_DOC_Texture(path,width,height,col[i].type);
						end
					end
					return unpack(t);
				end
			end
		end
	end
end

local col = { --Requirement. All textures must be squared
	["material"] = {
		{	name="Parchment 1",
			{path="Interface\\Icons\\Spell_Holy_WordFortitude",type="topleft"},
			{path="Interface\\Icons\\Spell_Arcane_Arcane02",type="center"},
		},
		{	name="Parchment 2",
			{path="INTERFACE\\GLUES\\MODELS\\UI_BLOODELF\\bloodelf_mountains",type="center"},
		},
	},

	["background"] = {
		{	name="Green",
			{path="INTERFACE\\RAIDFRAME\\UI-RaidFrame-GroupBg",type="center"},
		},
	},

};
collections = col;

local tex = { -- this can be auto generated, but might give a large memory use
	["INTERFACE\\GLUES\\MODELS\\UI_BLOODELF\\bloodelf_mountain"]={256,256},
	["INTERFACE\\RAIDFRAME\\UI-RaidFrame-GroupBg"]={256,256},
};

textures = tex;