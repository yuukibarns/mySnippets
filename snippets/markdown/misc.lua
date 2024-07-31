local autosnips = {}

local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.markdown")

local opts = { condition = tex.in_text }
local opts2 = { condition = tex.in_text * conds_expand.line_begin }

-- local function appended_space_after_insert()
-- 	vim.api.nvim_create_autocmd("InsertCharPre", {
-- 		callback = function()
-- 			if string.find(vim.v.char, "%a") then
-- 				vim.v.char = " " .. vim.v.char
-- 			end
-- 		end,
-- 		buffer = 0,
-- 		once = true,
-- 		desc = "Auto Add a Space after Inline Math",
-- 	})
-- end

autosnips = {
	-- s({
	-- 	trig = "(%s)([b-zB-HJ-Z0-9])([,;.%-%)]?)%s+",
	-- 	name = "single-letter variable",
	-- 	wordTrig = false,
	-- 	regTrig = true,
	-- 	hidden = true,
	-- }, {
	-- 	f(function(_, snip)
	-- 		return snip.captures[1] .. "$" .. snip.captures[2] .. "$" .. snip.captures[3]
	-- 	end, {}),
	-- }, opts),

	s({
		trig = "mk",
		name = "inline math",
		desc = "Insert inline Math Environment.",
		hidden = true,
	}, fmt([[${}${}]], { i(1), i(0) }), opts),

	s(
		{
			trig = "dm",
			name = "dispaly math",
			desc = "Insert display Math Environment.",
			hidden = true,
		},
		fmt(
			[[
			$$
			{}
			$$
			]],
			{ i(0) }
		),
		opts2
	),
}

return nil, autosnips
