local snips, autosnips = {}, {}

local tex = require("mySnippets.latex")

local opts = { condition = tex.in_math, show_condition = tex.in_math }

local function operator_snippet(trig)
	return s({ trig = trig, name = trig }, t([[\]] .. trig), opts)
end

local function sequence_snippet(trig, cmd, desc)
	return s(
		{ trig = trig, name = desc, desc = desc },
		fmta([[\<><><>]], {
			t(cmd),
			c(1, { fmta([[_{<>}^{<>}]], { i(1, "i=0"), i(2, "\\infty") }), t("") }),
			i(0),
		}),
		opts
	)
end

snips = {
	-- s({
	-- 	trig = "/",
	-- 	name = "fraction",
	-- 	desc = "Insert a fraction notation.",
	-- 	wordTrig = false,
	-- 	hidden = true,
	-- }, fmta([[\frac{<>}{<>}<>]], { i(1), i(2), i(0) }), opts),
}

autosnips = {
	s(
		{ trig = "dint", name = "integral", desc = "Insert integral notation." },
		fmta([[\int_{<>}^{<>}<>]], { i(1, "-\\infty"), i(2, "\\infty"), i(0) }),
		opts
	),
	-- s(
	-- 	{ trig = "dfu", name = "deffunction", desc = "def+function.", hidden = true },
	-- 	fmta([[\colon <>]], {
	-- 		c(1, {
	-- 			fmta([[<> \to <>]], { i(1), i(0) }),
	-- 			fmta([[<> \longrightarrow <>]], { i(1), i(0) }),
	-- 		}),
	-- 	}),
	-- 	opts
	-- ),
	s(
		{ trig = "xra", name = "xrightarrow", desc = "xrightarrow." },
		fmta([[\xrightarrow{<>}<>]], { i(1), i(0) }),
		opts
	),
	s({ trig = "xla", name = "xleftarrow", desc = "xleftarrow." }, fmta([[\xleftarrow{<>}<>]], { i(1), i(0) }), opts),
	s(
		{ trig = "dyd", name = "dy/dx", desc = "dy/dx." },
		fmta([[\frac{\mathrm{d}<>}{\mathrm{d}<>}<>]], { i(1), i(2), i(0) }),
		opts
	),
	s(
		{ trig = "dyp", name = "py/px", desc = "py/px." },
		fmta([[\frac{\partial<>}{\partial<>}<>]], { i(1), i(2), i(0) }),
		opts
	),
	s(
		{ trig = "\\|Ln", name = "L norms", desc = "L norms.", wordTrig = false },
		fmta([[\|_{L^{<>}}<>]], { i(1), i(0) }),
		opts
	),
	s({ trig = "mod", name = "modula", desc = "= (mod I)." }, fmta([[\ (\mathrm{mod}\ <>)]], { i(1) }), opts),
	-- fractions
	s(
		{ trig = "//", name = "fraction", desc = "fraction (general)" },
		fmta([[\frac{<>}{<>}<>]], { i(1), i(2), i(0) }),
		opts
	),
	s(
		{ trig = "(%w)//", name = "fraction", desc = "auto fraction", regTrig = true },
		fmta([[\frac{<>}{<>}<>]], { f(function(_, snip)
			return snip.captures[1]
		end), i(1), i(0) }),
		opts
	),

	-- s(
	-- 	{ trig = "lim", name = "lim(sup|inf)", desc = "lim(sup|inf)" },
	-- 	fmta([[\lim<><><>]], {
	-- 		c(1, { t(""), t("sup"), t("inf") }),
	-- 		c(2, { t(""), fmta([[_{<> \to <>}]], { i(1, "n"), i(2, "\\infty") }) }),
	-- 		i(0),
	-- 	}),
	-- 	opts
	-- ),
	--	s(
	--		{ trig = "set", name = "set", desc = "set" },
	--		fmta([[\{<>\}<>]], { c(1, { r(1, ""), sn(nil, { r(1, ""), t(" \\mid "), i(2) }) }), i(0) }),
	--		opts
	--	),
	s(
		{ trig = "bnc", name = "binomial", desc = "binomial (nCR)" },
		fmta([[\binom{<>}{<>}<>]], { i(1), i(2), i(0) }),
		opts
	),

	s({ trig = "tag", name = "\\tag", desc = "add tag manually" }, fmta([[\tag{<>}]], { i(1) }), opts),
}

local sequence_specs = {
	sum = { "sum", "summation" },
	prod = { "prod", "product" },
	cprod = { "coprod", "coproduct" },
	hH = { "bigcap", "intersection" },
	uU = { "bigcup", "union" },
	Ox = { "bigotimes", "BigOTimes" },
	["O+"] = { "bigoplus", "BigOTimes" },
	wW = { "bigwedge", "BigWedge" },
	vV = { "bigvee", "BigVee" },
}

local operator_specs = {
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
	--"ast",
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
}

for k, v in pairs(sequence_specs) do
	table.insert(autosnips, sequence_snippet(k, v[1], v[2]))
end

for _, v in ipairs(operator_specs) do
	table.insert(autosnips, operator_snippet(v))
end

return snips, autosnips
