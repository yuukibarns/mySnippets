local tex = require("mySnippets.tex").conds

local conds_expand = require("luasnip.extras.conditions.expand")
local opts = { condition = tex.in_math * conds_expand.trigger_not_preceded_by("[%w_\\]"), show_condition = tex.in_math }

local brackets = {
    a = { "\\langle ", "\\rangle" },
    b = { "[ ", "]" },
    B = { "\\{", "\\}" },
    c = { "\\lceil ", "\\rceil" },
    f = { "\\lfloor ", "\\rfloor" },
    m = { "|", "|" },
    n = { "\\|", "\\|" },
    p = { "(", ")" },
    g = { "\\[", "\\)" },
    h = { "\\(", "\\]" },
    v = { ".", "|" },
    s = { "\\{", "." },
}

local function get_visual(_, parent)
    if #parent.snippet.env.SELECT_RAW > 0 then
        return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
    else
        return sn(nil, i(1))
    end
end

local snips = {
    s(
        {
            trig = "lr([abBcfmnpghvs])",
            name = "left right",
            desc = "left right delimiters",
            regTrig = true,
            wordTrig = true,
            hidden = false,
        },
        fmta([[\left<> <> \right<><>]], {
            f(function(_, snip)
                local cap = snip.captures and snip.captures[1] or "p"
                return brackets[cap] and brackets[cap][1] or brackets["p"][1]
            end),
            d(1, get_visual),
            f(function(_, snip)
                local cap = snip.captures and snip.captures[1] or "p"
                return brackets[cap] and brackets[cap][2] or brackets["p"][2]
            end),
            i(0),
        }),
        opts
    ),
}

return snips, nil
