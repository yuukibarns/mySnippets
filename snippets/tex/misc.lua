local autosnips = {}

local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.latex")

autosnips = {
	s({
		trig = "mk",
		name = "inline math",
		desc = "Insert inline Math Environment.",
		hidden = true,
		condition = tex.in_text,
	}, fmt([[\({}\){}]], { i(1), i(0) })),
	s(
		{
			trig = "dm",
			name = "dispaly math",
			desc = "Insert display Math Environment.",
			hidden = true,
			condition = tex.in_text * conds_expand.line_begin,
		},
		fmt(
			[[
			\[{}\]
			]],
			{ i(0) }
		)
	),
}

return nil, autosnips
