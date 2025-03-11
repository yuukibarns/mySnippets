local snips = {}

local tex = require("mySnippets.latex")

local opts = { condition = tex.in_text, show_condition = tex.in_text }

snips = {
    s({ trig = "bold", name = "bold", desc = "Insert bold text." }, { t("\\textbf{"), i(1), t("}") }, opts),
    s({ trig = "italic", name = "italic", desc = "Insert italic text." }, { t("\\textit{"), i(1), t("}") }, opts),
}
return snips, nil
