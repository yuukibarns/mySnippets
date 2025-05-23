local autosnips = {}

local tex = require("mySnippets.latex")

local opts = { condition = tex.in_math, show_condition = tex.in_math }

local function operator_snippet(trig)
    return s({ trig = trig, name = trig, hidden = false }, t([[\]] .. trig), opts)
end

autosnips = {
    s(
        { trig = "over", name = "fraction", desc = "fraction (general)", hidden = false },
        fmta([[\frac{<>}{<>}<>]], { i(1), i(2), i(0) }),
        opts
    ),
    s(
        { trig = "(%w)over", name = "over", desc = "auto fraction", hidden = true, regTrig = true },
        fmta([[\frac{<>}{<>}<>]], { f(function(_, snip)
            return snip.captures[1]
        end), i(1), i(0) }),
        opts
    ),
    s({ trig = "binom", name = "binomial", desc = "binomial", hidden = false }, fmta([[\binom{<>}{<>}<>]], { i(1), i(2), i(0) }), opts),
}

local operator_specs = {
    "sum",
    "prod",
    "cprod",
    "bigcap",
    "bigcup",
    "bigsqcap",
    "bigsqcup",
    "bigotimes",
    "bigoplus",
    "bigwedge",
    "bigvee",
    "bigodot",
    "int",
    "arcsin",
    "sin",
    "arccos",
    "cos",
    "arctan",
    "tan",
    "cot",
    "csc",
    "sec",
    "log",
    "deg",
    "det",
    "dim",
    "exp",
    "hom",
    "inf",
    "sup",
    "ker",
    "max",
    "min",
    "lim",
    "Re",
    "Im",
    "arg",
}

for _, v in ipairs(operator_specs) do
    table.insert(autosnips, operator_snippet(v))
end

return nil, autosnips
