local snips = {}

local conds_expand = require("luasnip.extras.conditions.expand")
local pos = require("mySnippets.position")
local tex = require("mySnippets.markdown")

local opts = { condition = conds_expand.line_begin, show_condition = pos.line_begin, hidden = false }
local opts2 = { condition = tex.in_text, show_condition = tex.in_text, hidden = true }

snips = {
	s(
		{ trig = "fig", name = "Markdown figure", desc = "Add an image." },
		fmt([[![{}]({} "{}")]], { i(1, "Figure"), i(2, "url"), i(3, "title") }),
		opts
	),
	s({ trig = "bold", name = "Bold text", desc = "Bold text" }, fmt([[**{}**{}]], { i(1), i(0) }), opts2),
	s({ trig = "italic", name = "Italic text", desc = "Italic text" }, fmt([[_{}_{}]], { i(1), i(0) }), opts2),
	s({ trig = "link", name = "Link text", desc = "Link text" }, fmt("[{}]({})", { i(1), i(0) }), opts2),
	s({ trig = "vault_dir", name = "VAULT_DIR", desc = "Vault Directory" }, fmt("{}", { t("$VAULT_DIR") }), opts2),
	s({ trig = "code", name = "Code text", desc = "Code text" }, fmt([[`{}`{}]], { i(1), i(0) }), opts2),
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

return snips, nil
