local autosnips = {}

local tex = require("mySnippets.markdown")

local opts = { condition = tex.in_math }

local function operator_snippet(trig)
	return s({ trig = trig, name = trig, hidden = false }, t([[\]] .. trig), opts)
end

autosnips = {
	s(
		{ trig = "frac", name = "fraction", desc = "fraction (general)", hidden = false },
		fmta([[\frac{<>}{<>}<>]], { i(1), i(2), i(0) }),
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
