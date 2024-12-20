local snips = {}
local tex = require("mySnippets.markdown")
local opts = { condition = tex.in_text, show_condition = tex.in_text, hidden = false }

snips = {
	s({ trig = "ふり", name = "振り仮名", desc = "振り仮名" }, fmt([[<ruby>{}<rt>{}</rt></ruby>{}]], { i(1), i(2), i(0) }), opts),
}

return snips, nil
