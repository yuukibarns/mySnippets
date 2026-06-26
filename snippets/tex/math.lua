local autosnips = {}

local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.tex").conds

autosnips = {
    s({
        trig = "mk",
        name = "inline math",
        desc = "Insert inline Math Environment.",
        hidden = true,
    }, fmt([[\({}\){}]], { i(1), i(0) }), { condition = tex.in_text }),

    s({
        trig = "dm",
        name = "display math",
        desc = "Insert display Math Environment.",
        hidden = true,
    }, fmt([=[\[ {} \]]=], { i(0) }), { condition = tex.in_text * conds_expand.line_begin }),
}

return nil, autosnips
