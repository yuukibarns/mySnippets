local autosnips = {}

local tex = require("mySnippets.markdown")

local conds_expand = require("luasnip.extras.conditions.expand")
local opts = { condition = tex.in_math * conds_expand.trigger_not_preceded_by("[%w_\\]"), show_condition = tex.in_math }

local function operator_snippet(trig)
    return s({ trig = trig, name = trig, hidden = false }, t([[\]] .. trig), opts)
end

autosnips = {
    s(
        { trig = "//", name = "fraction", desc = "fraction (general)", hidden = true },
        fmta([[\frac{<>}{<>}<>]], { i(1), i(2), i(0) }),
        opts
    ),
    s(
        { trig = "(%w)//", name = "over", desc = "auto fraction", hidden = true, regTrig = true },
        fmta([[\frac{<>}{<>}<>]], { f(function(_, snip)
            return snip.captures[1]
        end), i(1), i(0) }),
        opts
    ),
    s(
        { trig = "dfrac", name = "display fraction", desc = "fraction (display mode)", hidden = false },
        fmta([[\dfrac{<>}{<>}<>]], { i(1), i(2), i(0) }),
        opts
    ),
    s({ trig = "binom", name = "binomial", desc = "binomial", hidden = false },
        fmta([[\binom{<>}{<>}<>]], { i(1), i(2), i(0) }), opts),
}

local operator_specs = {
    "sum",
    "prod",
    "coprod",
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
    "iint",
    "iiint",
    "oint",
    "oiint",
    "oiiint",
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
    "inf",
    "sup",
    "max",
    "maximize",
    "min",
    "mod",
    "pmod",
    "minimize",
    "lim",
    "varinjlim",
    "Re",
    "Im",
    "arg",
    "gcd",
    "Hom",
    "Tor",
    "Ext",
    "II",
    "End",
    "ker",
    "coker",
    "rank",
    "tr",
    "Spec",
    "Re",
    "Im",
    "Res",
    "sgn",
    "argmax",
    "argmin",
    "Var",
    "Cov",
    "diam",
    "Vol",
    "grad",
    "curl",
    "div",
    "Hess",
    "ord",
    "lcm",
}

for _, v in ipairs(operator_specs) do
    table.insert(autosnips, operator_snippet(v))
end

return nil, autosnips
