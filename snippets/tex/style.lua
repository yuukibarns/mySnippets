local snips, autosnips = {}, {}

local tex = require("mySnippets.latex")

local opts = { condition = tex.in_text, show_condition = tex.in_text }

autosnips = {
	s({ trig = "**", name = "bold", desc = "Insert bold text." }, { t("\\textbf{"), i(1), t("}") }, opts),
	s({ trig = "__", name = "italic", desc = "Insert italic text." }, { t("\\textit{"), i(1), t("}") }, opts),
}
return snips, autosnips
