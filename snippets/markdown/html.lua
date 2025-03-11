local snips = {}

local conds_expand = require("luasnip.extras.conditions.expand")
local pos = require("mySnippets.position")
local tex = require("mySnippets.markdown")

local opts = { condition = conds_expand.line_begin, show_condition = pos.line_begin, hidden = false }
local opts2 = { condition = tex.in_text, show_condition = tex.in_text, hidden = false }

snips = {
	s(
		{ trig = "figure", name = "Markdown figure with caption", desc = "Add an image with caption" },
		fmt(
			[[
			<div align="center">
			<figure>
			  <img src="{}" alt="{}" width="{}">
			  <figcaption>{}</figcaption>
			</figure>
			</div>
			]],
			{ i(1), i(2, "image"), i(3, "400"), i(0) }
		),
		opts
	),
	s(
		{ trig = "align", name = "Alignment", desc = "Aligned text" },
		fmt(
			[[
			<div align="{}">
			{}
			</div>
			]],
			{ i(1, "center"), i(0) }
		),
		opts
	),
	s(
		{ trig = "kbd", name = "KeyBoarD", desc = "KeyBoarD" },
		fmt(
			[[
			<kbd>{}</kbd>{}
			]],
			{ i(1), i(0) }
		),
		opts2
	),
	s(
		{ trig = "img", name = "Image", desc = "Image" },
		fmt(
			[[
			<img src="{}" alt="{}" width="{}">
			]],
			{ i(1), i(2), i(0) }
		),
		opts2
	),
	s(
		{ trig = "details", name = "Details", desc = "Details" },
		fmt(
			[[
			<details><summary>{}</summary>

			{}

			</details>
			]],
			{ i(1, "Click to Expand"), i(0) }
		),
		opts
	),
}

return snips, nil
