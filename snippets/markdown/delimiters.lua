local autosnips = {}

local tex = require("mySnippets.markdown")

local conds_expand = require("luasnip.extras.conditions.expand")
local opts = { condition = tex.in_math * conds_expand.trigger_not_preceded_by("[%w_\\]"), show_condition = tex.in_math }
local opts2 = { condition = tex.in_math, show_condition = tex.in_math }

local brackets = {
    a = { "\\langle ", "\\rangle" },
    b = { "[ ", "]" },
    B = { "\\{", "\\}" },
    c = { "\\lceil ", "\\rceil" },
    f = { "\\lfloor ", "\\rfloor" },
    m = { "|", "|" },
    n = { "\\|", "\\|" },
    p = { "(", ")" },
    g = { "\\lbrack", "\\rparen" },
    h = { "\\lparen", "\\rbrack" },
    v = { ".", "|" },
    s = { "\\lbrace", "." },
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

autosnips = {
    s(
        {
            trig = ";o",
            name = "parentheses",
            desc = "parenthese delimiter",
            wordTrig = false,
            hidden = true,
        },
        fmta(
            [[
            (<>)<>
            ]],
            { i(1), i(0) }
        ),
        opts2
    ),
    s(
        {
            trig = ";[",
            name = "brackets",
            desc = "bracket delimiter",
            wordTrig = false,
            hidden = true,
        },
        fmta(
            [[
            [<>]<>
            ]],
            { i(1), i(0) }
        ),
        opts2
    ),
    s(
        {
            trig = ";{",
            name = "braces",
            desc = "brace delimiter",
            wordTrig = false,
            hidden = true,
        },
        fmta(
            [[
            \{<>\}<>
            ]],
            { i(1), i(0) }
        ),
        opts2
    ),
    s(
        {
            trig = "{",
            name = "tensor",
            desc = "tensor",
            wordTrig = false,
            hidden = true,
        },
        t("{}"),
        opts2
    ),
    s(
        {
            trig = "abs",
            name = "norm",
            desc = "norm delimiter",
            wordTrig = true,
            hidden = false,
        },
        fmta(
            [[
            |<>|<>
            ]],
            { i(1), i(0) }
        ),
        opts
    ),
    s(
        {
            trig = "norm",
            name = "Norm",
            desc = "Norm delimiter",
            wordTrig = true,
            hidden = false,
        },
        fmta(
            [[
            \|<>\|<>
            ]],
            { i(1), i(0) }
        ),
        opts
    ),
}

return snips, autosnips
