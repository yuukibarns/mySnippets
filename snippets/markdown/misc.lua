local autosnips = {}

local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.markdown")

local opts = { condition = tex.in_text_math }
local opts2 = { condition = tex.in_text }
local opts3 = { condition = tex.in_text * conds_expand.line_begin }

autosnips = {
    s({
        trig = "mk",
        name = "inline math",
        desc = "Insert inline Math Environment.",
        hidden = true,
    }, fmt([[\({}\){}]], { i(1), i(0) }), opts),

    s({
        trig = "mk",
        name = "inline math",
        desc = "Insert inline Math Environment.",
        hidden = true,
    }, fmt([[${}${}]], { i(1), i(0) }), opts2),

    s({
        trig = "dm",
        name = "dispaly math",
        desc = "Insert display Math Environment.",
        hidden = true,
    }, fmt([[$$ {} $$]], { i(0) }), opts3),
}

return nil, autosnips
