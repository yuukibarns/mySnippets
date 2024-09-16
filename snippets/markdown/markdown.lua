local snips, autosnips = {}, {}

local conds_expand = require("luasnip.extras.conditions.expand")
local pos = require("mySnippets.position")
local tex = require("mySnippets.markdown")

local opts = { condition = conds_expand.line_begin, show_condition = pos.line_begin }
local opts2 = { condition = tex.in_text, show_condition = tex.in_text }
snips = {
	s(
		{ trig = "meta", name = "Markdown front matter (YAML format)" },
		fmt(
			[[
			---
			title: {}
			date: {}
			tags: ["{}"]
			categories: ["{}"]
			series: ["{}"]
			---
			{}
			]],
			{ i(1), p(os.date, "%Y-%m-%dT%H:%M:%S+0800"), i(2), i(3), i(4), i(0) }
		),
		{
			condition = pos.on_top * conds_expand.line_begin,
			show_condition = pos.on_top * pos.line_begin,
		}
	),
	s(
		{ trig = "fig", name = "Markdown figure", desc = "Add an image." },
		fmt([[![{}]({} "{}")]], { i(1, "Figure"), i(2, "url"), i(3, "title") }),
		opts
	),

	s(
		{ trig = "figure", name = "Markdown figure with caption", desc = "Add an image with caption" },
		fmt(
			[[
		| ![{}]({}) |
		| :--: |
		| *{}* |
		]],
			{ i(1, "Figure"), i(2, "URL"), i(3, "Caption") }
		),
		opts
	),
}

autosnips = {
	s({ trig = "*", name = "italic&bold" }, fmt("*{}*", { i(1) }), opts2),
	s({ trig = "~~", name = "strikethrough" }, fmt("~~{}~~", { i(1) }), opts2),
}

return snips, autosnips
