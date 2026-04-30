local snips = {}

-- local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.tex")

local opts = { condition = tex.in_text, show_condition = tex.in_text }

snips = {
    s({ trig = "bo", name = "Bold text", desc = "Bold text" }, fmta([[\textbf{<>}<>]], { i(1), i(0) }), opts),
    s({ trig = "io", name = "Italic text", desc = "Italic text" }, fmta([[\textit{<>}<>]], { i(1), i(0) }), opts),
    s({ trig = "emph", name = "Italic text", desc = "Emphasized text" }, fmta([[\emph{<>}<>]], { i(1), i(0) }), opts),
}

return snips, nil
