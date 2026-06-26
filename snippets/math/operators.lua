local autosnips = {}
local snips = {}

local tex = require("mySnippets.tex").conds

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
	s({ trig = "binom", name = "binomial", desc = "binomial", hidden = false },
		fmta([[\binom{<>}{<>}<>]], { i(1), i(2), i(0) }), opts),
}

local operator_specs = {
	-- === Large Operators & Integrals ===
	"sum", "prod", "coprod", "bigcap", "bigcup", "bigsqcap", "bigsqcup", "bigotimes",
	"bigoplus", "bigwedge", "bigvee", "bigodot", "biguplus",
	"int", "iint", "iiint", "oint", "oiint", "oiiint", "idotsint",

	-- === Trigonometric & Hyperbolic Functions ===
	"sin", "cos", "tan", "cot", "sec", "csc",
	"arcsin", "arccos", "arctan",
	"sinh", "cosh", "tanh", "coth", "sech", "csch",
	"arcsinh", "arccosh", "arctanh",

	-- === Calculus, Limits & Analysis ===
	"lim", "liminf", "limsup", "varinjlim", "varprojlim", "injlim", "projlim",
	"inf", "sup", "max", "min", "maximize", "minimize", "argmax", "argmin",
	"log", "ln", "lg", "exp", "deg", "det", "dim", "ker", "coker",
	"grad", "curl", "div", "Hess", "diff", "partial", "nabla",

	-- === Algebra, Logic & Set Theory Operators ===
	"arg", "gcd", "lcm", "ord", "sgn", "Pr", "Var", "Cov", "diam", "Vol", "rank", "tr", "Tr",
	"Spec", "Proj", "Res", "Hom", "hom", "Tor", "Ext", "End", "Aut", "Inn", "Out",
	"GL", "SL", "SU", "SO", "Sp", "diag", "span", "supp", "codim", "coim", "im", "dom", "ran", "char",
	"Gal", "Mor", "Ann", "Ass", "Obj", "card", "id", "identity",
	"II", "empty", "emptyset", "varnothing", "aleph", "ell",

	-- === Arrows & Maps ===
	"to", "gets", "iff", "implies", "impliedby",
	"leftarrow", "rightarrow", "leftrightarrow", "longleftrightarrow", "longleftarrow", "longrightarrow",
	"Leftarrow", "Rightarrow", "Leftrightarrow", "Longerrightarrow", "Longleftarrow", "Longleftrightarrow",
	"rightrightarrows", "leftleftarrows", "twoheadrightarrow", "twoheadleftarrow",
	"hookrightarrow", "hookleftarrow", "mapsto", "longmapsto",
	"uparrow", "downarrow", "updownarrow", "Updownarrow",
	"searrow", "nearrow", "swarrow", "nwarrow",

	-- === Binary Operators & Relations ===
	"pm", "mp", "times", "div", "cdot", "circ", "ast", "star", "bullet",
	"oplus", "otimes", "odot", "ominus", "uplus", "cap", "cup", "sqcap", "sqcup", "setminus",
	"flat", "sharp", "smile", "frown", "dagger", "parallel", "perp", "bot", "wp", "hbar",
	"prec", "succ", "neq", "leq", "geq", "leqslant", "geqslant", "cong", "equiv", "ll", "gg",
	"approx", "simeq", "sim", "propto", "asymp", "nmid", "mid", "vee", "wedge", "land", "lor",
	"in", "notin", "ni", "subset", "supset", "subseteq", "supseteq", "Subset", "Supset",
	"sqsubset", "sqsupset", "sqsubseteq", "sqsupseteq", "square", "blacksquare",

	-- === Logic & Formatting / Spacing ===
	"forall", "exists", "neg", "quad", "qquad", "mod", "pmod"
}

for _, v in ipairs(operator_specs) do
	table.insert(snips, operator_snippet(v))
end

return snips, autosnips
