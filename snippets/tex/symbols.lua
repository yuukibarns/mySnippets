local autosnips = {}
local snips = {}
local tex = require("mySnippets.latex")

local opts = { condition = tex.in_math }

local function symbol_snippet(context, cmd)
	context.desc = cmd
	context.name = context.name or cmd:gsub([[\]], "")
	context.docstring = cmd .. [[{0}]]
	context.wordTrig = false
	context.hidden = true
	return s(context, t(cmd), opts)
end

local function symbol_snippet2(context, cmd)
	context.desc = cmd
	context.name = context.name or cmd:gsub([[\]], "")
	context.docstring = cmd .. [[{0}]]
	context.wordTrig = true
	context.hidden = true
	return s(context, fmta([[<><><>]], { t("\\("), t(cmd), t("\\)") }), { condition = tex.in_text })
end

local function symbol_snippet_w(context, cmd)
	context.desc = cmd
	context.name = context.name or cmd:gsub([[\]], "")
	context.docstring = cmd .. [[{0}]]
	context.wordTrig = true
	context.hidden = true
	return s(context, t(cmd), opts)
end

local function single_command_snippet(context, cmd, ext)
	context.desc = context.desc or cmd
	context.name = context.name or context.desc
	context.hidden = true
	local docstring, offset, cnode, lnode
	if ext.choice == true then
		docstring = "[" .. [[(<1>)?]] .. "]" .. [[{]] .. [[<2>]] .. [[}]] .. [[<0>]]
		offset = 1
		cnode = c(1, { t(""), sn(nil, { t("["), i(1, "opt"), t("]") }) })
	else
		docstring = [[{]] .. [[<1>]] .. [[}]] .. [[<0>]]
	end
	if ext.label == true then
		docstring = [[{]] .. [[<1>]] .. [[}]] .. [[\label{(]] .. ext.short .. [[:<2>)?}]] .. [[<0>]]
		ext.short = ext.short or cmd
		lnode = c(2 + (offset or 0), {
			t(""),
			sn(nil, fmta([[\label{<>:<>}]], { t(ext.short), i(1) })),
		})
	end
	context.docstring = context.docstring or (cmd .. docstring)
	-- stype = ext.stype or s
	return s(
		context,
		fmta(cmd .. [[<>{<>}<><>]], { cnode or t(""), i(1 + (offset or 0)), (lnode or t("")), i(0) }),
		opts
	)
end

autosnips = {
	-- s({ trig = "rmap", name = "rational map arrow", wordTrig = true, hidden = true }, {
	-- 	d(1, function()
	-- 		if tex.in_xymatrix() then
	-- 			return sn(nil, { t({ "\\ar@{-->}[" }), i(1), t({ "]" }) })
	-- 		else
	-- 			return sn(nil, { t("\\dashrightarrow ") })
	-- 		end
	-- 	end),
	-- }, opts),

	-- s({ trig = "emb", name = "embeddeing map arrow", wordTrig = true, hidden = true }, {
	-- 	d(1, function()
	-- 		if tex.in_xymatrix() then
	-- 			return sn(nil, { t({ "\\ar@{^{(}->}[" }), i(1), t({ "]" }) })
	-- 		else
	-- 			return sn(nil, { t("\\hookrightarrow ") })
	-- 		end
	-- 	end),
	-- }, opts),

	-- s({ trig = "\\varpii", name = "\\varpi_i", hidden = true }, { t("\\varpi_{i}") }, opts),
	-- s({ trig = "\\varphii", name = "\\varphi_i", hidden = true }, { t("\\varphi_{i}") }, opts),
	-- s(
	-- 	{ trig = "\\([xX])ii", name = "\\xi_{i}", regTrig = true, hidden = true },
	-- 	{ f(function(_, snip)
	-- 		return string.format("\\%si_{i}", snip.captures[1])
	-- 	end, {}) },
	-- 	opts
	-- ),
	-- s(
	-- 	{ trig = "\\([pP])ii", name = "\\pi_{i}", regTrig = true, hidden = true },
	-- 	{ f(function(_, snip)
	-- 		return string.format("\\%si_{i}", snip.captures[1])
	-- 	end, {}) },
	-- 	opts
	-- ),
	-- s(
	-- 	{ trig = "\\([pP])hii", name = "\\phi_{i}", regTrig = true, hidden = true },
	-- 	{ f(function(_, snip)
	-- 		return string.format("\\%shi_{i}", snip.captures[1])
	-- 	end, {}) },
	-- 	opts
	-- ),
	-- s(
	-- 	{ trig = "\\([cC])hii", name = "\\chi_{i}", regTrig = true, hidden = true },
	-- 	{ f(function(_, snip)
	-- 		return string.format("\\%shi_{i}", snip.captures[1])
	-- 	end, {}) },
	-- 	opts
	-- ),
	-- s(
	-- 	{ trig = "\\([pP])sii", name = "\\psi_{i}", regTrig = true, hidden = true },
	-- 	{ f(function(_, snip)
	-- 		return string.format("\\%ssi_{i}", snip.captures[1])
	-- 	end, {}) },
	-- 	opts
	-- ),

	--	s({
	--		trig = "O([A-NP-Za-z])",
	--		name = "local ring, structure sheaf",
	--		wordTrig = false,
	--		regTrig = true,
	--		hidden = true,
	--	}, {
	--		f(function(_, snip)
	--			return "\\mathcal{O}_{" .. snip.captures[1] .. "}"
	--		end, {}),
	--	}, opts),

	s({
		trig = "(%a)(%d)",
		name = "auto subscript 1",
		desc = "Subscript with a single number.",
		wordTrig = false,
		regTrig = true,
		hidden = true,
	}, {
		f(function(_, snip)
			return string.format("%s_%s", snip.captures[1], snip.captures[2])
		end, {}),
	}, opts),
	-- s({
	-- 	trig = "(})(%d)",
	-- 	name = "auto subscript 1",
	-- 	desc = "Subscript with a single number.",
	-- 	wordTrig = false,
	-- 	regTrig = true,
	-- 	hidden = true,
	-- }, {
	-- 	f(function(_, snip)
	-- 		return string.format("%s_%s", snip.captures[1], snip.captures[2])
	-- 	end, {}),
	-- }, opts),
	s({
		trig = "(%a)_(%d%d)",
		name = "auto subscript 2",
		desc = "Subscript with two numbers.",
		wordTrig = false,
		regTrig = true,
		hidden = true,
	}, {
		f(function(_, snip)
			return string.format("%s_{%s}", snip.captures[1], snip.captures[2])
		end, {}),
	}, opts),
	-- s({
	-- 	trig = "(})_(%d%d)",
	-- 	name = "auto subscript 2",
	-- 	desc = "Subscript with two numbers.",
	-- 	wordTrig = false,
	-- 	regTrig = true,
	-- 	hidden = true,
	-- }, {
	-- 	f(function(_, snip)
	-- 		return string.format("%s_{%s}", snip.captures[1], snip.captures[2])
	-- 	end, {}),
	-- }, opts),

	--s({ trig = "^-", name = "negative exponents", wordTrig = false, hidden = true }, fmta([[^{-<>}]], { i(1) }), opts),
	s(
		{ trig = "set", name = "set", desc = "set", hidden = true },
		fmta([[\{ <> \}<>]], { c(1, { r(1, ""), sn(nil, { r(1, ""), t(" \\mid "), i(2) }) }), i(0) }),
		opts
	),
	s(
		{ trig = "Set", name = "Set", desc = "big set", hidden = true },
		fmta([[\left\{ <> \right\}<>]], { c(1, { r(1, ""), sn(nil, { r(1, ""), t(" \\ \\bigg|\\ "), i(2) }) }), i(0) }),
		opts
	),
	--	s(
	--		{ trig = "abs", name = "absolute value", desc = "absolute value", hidden = true },
	--		fmta([[|<>|<>]], { i(1), i(0) }),
	--		opts
	--	),
	--	s({ trig = "nor", name = "norm", desc = "norm", hidden = true }, fmta([[||<>||<>]], { i(1), i(0) }), opts),
	--	s(
	--		{ trig = "nnn", name = "bigcap", desc = "bigcap", hidden = true },
	--		fmta([[\bigcap<> <>]], { c(1, { fmta([[_{<>}^{<>}]], { i(1, "i=0"), i(2, "\\infty") }), t("") }), i(0) }),
	--		opts
	--	),

	--	s(
	--		{ trig = "uuu", name = "bigcup", desc = "bigcup", hidden = true },
	--		fmta([[\bigcup<> <>]], { c(1, { fmta([[_{<>}^{<>}]], { i(1, "i=0"), i(2, "\\infty") }), t("") }), i(0) }),
	--		opts
	--	),
	s({ trig = "<|", name = "triangleleft <|", wordTrig = false, hidden = true }, { t("\\triangleleft ") }, opts),

	s({ trig = "|>", name = "triangleright |>", wordTrig = false, hidden = true }, { t("\\triangleright ") }, opts),

	--	s({ trig = "MK", name = "Mori-Kleiman cone", hidden = true }, { t("\\cNE("), i(1), t(")") }, opts),
	s(
		{ trig = "([QRNZ])P", name = "positive", wordTrig = true, regTrig = true, hidden = true },
		{ f(function(_, snip)
			return "\\mathbb{" .. snip.captures[1] .. "}^{+}"
		end, {}) },
		opts
	),

	s(
		{ trig = "([QRZ])N", name = "negative", wordTrig = true, regTrig = true, hidden = true },
		{ f(function(_, snip)
			return "\\mathbb{" .. snip.captures[1] .. "}^{-}"
		end, {}) },
		opts
	),

	-- s(
	-- 	{ trig = "([qr])le", name = "linearly equivalent", wordTrig = false, regTrig = true, hidden = true },
	-- 	{ f(function(_, snip)
	-- 		return "\\sim_{\\mathbb{" .. string.upper(snip.captures[1]) .. "}} "
	-- 	end, {}) },
	-- 	opts
	-- ),

	-- HACK: <Jia> do not use condition since it cannot be triggered
	s(
		{ trig = "^", name = "auto supscript", wordTrig = false, hidden = true },
		fmta([[^{<>}<>]], { i(1), i(0) }),
		opts
	),
	s(
		{ trig = "_", name = "auto subscript", wordTrig = false, hidden = true },
		fmta([[_{<>}<>]], { i(1), i(0) }),
		opts
	),

	s({ trig = "&&", name = "align", wordTrig = false, hidden = true }, { t("& \\ ") }, { condition = tex.in_math }),

	-- s(
	-- 	{ trig = "ar", name = "normal arrows", hidden = true },
	-- 	{ t("\\ar["), i(1), t("]") },
	-- 	{ condition = tex.in_xymatrix }
	-- ),
	s({ trig = "'([mnkij])", name = "mnkji derivatives", wordTrig = false, regTrig = true, hidden = true }, {
		f(function(_, snip)
			return "^{(" .. snip.captures[1] .. ")}"
		end, {}),
	}, opts),
	s({ trig = "'(%d)", name = "number derivatives", wordTrig = false, regTrig = true, hidden = true }, {
		f(function(_, snip)
			return "^{(" .. snip.captures[1] .. ")}"
		end, {}),
	}, opts),
	s({ trig = "(%a)ii", name = "alph i", wordTrig = true, regTrig = true, hidden = true }, {
		f(function(_, snip)
			return snip.captures[1] .. "_{i}"
		end, {}),
	}, opts),
	-- s({ trig = "(})ii", name = "{alpha} i", wordTrig = false, regTrig = true, hidden = true }, {
	-- 	f(function(_, snip)
	-- 		return snip.captures[1] .. "_{i}"
	-- 	end, {}),
	-- }, opts),
	s({ trig = "(%a)jj", name = "alph j", wordTrig = true, regTrig = true, hidden = true }, {
		f(function(_, snip)
			return snip.captures[1] .. "_{j}"
		end, {}),
	}, opts),
	-- s({ trig = "(})jj", name = "{alpha} j", wordTrig = false, regTrig = true, hidden = true }, {
	-- 	f(function(_, snip)
	-- 		return snip.captures[1] .. "_{j}"
	-- 	end, {}),
	-- }, opts),
	s({ trig = "(%a)kk", name = "alph k", wordTrig = true, regTrig = true, hidden = true }, {
		f(function(_, snip)
			return snip.captures[1] .. "_{k}"
		end, {}),
	}, opts),
	-- s({ trig = "(})kk", name = "{alpha} k", wordTrig = false, regTrig = true, hidden = true }, {
	-- 	f(function(_, snip)
	-- 		return snip.captures[1] .. "_{k}"
	-- 	end, {}),
	-- }, opts),
	s({ trig = "(%a)nn", name = "alph n", wordTrig = true, regTrig = true, hidden = true }, {
		f(function(_, snip)
			return snip.captures[1] .. "_{n}"
		end, {}),
	}, opts),
	-- s({ trig = "(})nn", name = "{alpha} n", wordTrig = false, regTrig = true, hidden = true }, {
	-- 	f(function(_, snip)
	-- 		return snip.captures[1] .. "_{n}"
	-- 	end, {}),
	-- }, opts),
	s({ trig = "(%a)mm", name = "alph m", wordTrig = true, regTrig = true, hidden = true }, {
		f(function(_, snip)
			return snip.captures[1] .. "_{m}"
		end, {}),
	}, opts),
	-- s({ trig = "(})mm", name = "{alpha} m", wordTrig = false, regTrig = true, hidden = true }, {
	-- 	f(function(_, snip)
	-- 		return snip.captures[1] .. "_{m}"
	-- 	end, {}),
	-- }, opts),
}

local single_command_math_specs = {
	tt = {
		context = { name = "text (math)", desc = "text in math mode" },
		cmd = [[\text]],
	},
	--sbf = {
	--	context = { name = "symbf", desc = "bold math text" },
	--		cmd = [[\symbf]],
	--	},
	--	syi = {
	--		context = { name = "symit", desc = "italic math text" },
	--		cmd = [[\symit]],
	--	},
	mbb = {
		context = { name = "mathbb", desc = "mathbb text" },
		cmd = [[\mathbb]],
	},
	mcl = {
		context = { name = "mathcal", desc = "mathcal text" },
		cmd = [[\mathcal]],
	},
	msr = {
		context = { name = "mathscr", desc = "mathscr text" },
		cmd = [[\mathscr]],
	},
	mfk = {
		context = { name = "mathfrak", desc = "mathfrak text" },
		cmd = [[\mathfrak]],
	},
	mrm = {
		context = { name = "mathrm", desc = "mathrm text" },
		cmd = [[\mathrm]],
	},
	bx = {
		context = { name = "boxed", desc = "boxed" },
		cmd = [[\boxed]],
	},
	sq = {
		context = { name = "sqrt", desc = "sqrt" },
		cmd = [[\sqrt]],
		ext = { choice = true },
	},
	hat = {
		context = { name = "hat", desc = "wide hat" },
		cmd = [[\widehat]],
	},
	bar = {
		context = { name = "overline", desc = "overline" },
		cmd = [[\overline]],
	},
	vcx = {
		context = { name = "vector", desc = "vector" },
		cmd = [[\vec]],
	},
	bm = {
		context = { name = "boldmath", desc = "boldmath" },
		cmd = [[\bm]],
	},
	td = {
		context = { name = "tilde", desc = "wide tilde" },
		cmd = [[\widetilde]],
	},
	mrg = {
		context = { name = "mathring", desc = "mathring" },
		cmd = [[\mathring]],
	},
	--abs = {
	--context = { name = "abs", desc = "absolute value" },
	--cmd = [[\abs]],
	--},
	--udd = {
	--	context = { name = "underline (math)", desc = "underlined text in math mode" },
	--	cmd = [[\underline]],
	--},
	sbt = {
		context = { name = "substack", desc = "substack for sums/products" },
		cmd = [[\substack]],
	},
	-- rup = {
	-- 	context = { name = "round up", desc = "auto round up", wordTrig = false },
	-- 	cmd = [[\rup]],
	-- },
	-- rdn = {
	-- 	context = { name = "round down", desc = "auto round down", wordTrig = false },
	-- 	cmd = [[\rdown]],
	-- },
}

local symbol_specs_w = {
	--sets
	AA = { context = { name = "𝔸" }, cmd = [[\mathbb{A}]] },
	CC = { context = { name = "ℂ" }, cmd = [[\mathbb{C}]] },
	DD = { context = { name = "𝔻" }, cmd = [[\mathbb{D}]] },
	FF = { context = { name = "𝔽" }, cmd = [[\mathbb{F}]] },
	GG = { context = { name = "𝔾" }, cmd = [[\mathbb{G}]] },
	HH = { context = { name = "ℍ" }, cmd = [[\mathbb{H}]] },
	NN = { context = { name = "ℕ" }, cmd = [[\mathbb{N}]] },
	OO = { context = { name = "O" }, cmd = [[\mathcal{O}]] },
	LL = { context = { name = "L" }, cmd = [[\mathcal{L}]] },
	PP = { context = { name = "ℙ" }, cmd = [[\mathbb{P}]] },
	QQ = { context = { name = "ℚ" }, cmd = [[\mathbb{Q}]] },
	RR = { context = { name = "ℝ" }, cmd = [[\mathbb{R}]] },
	ZZ = { context = { name = "ℤ" }, cmd = [[\mathbb{Z}]] },
	--operators
	xx = { context = { name = "×" }, cmd = [[\times]] },
	["o+"] = { context = { name = "⊕" }, cmd = [[\oplus]] },
	ox = { context = { name = "⊗" }, cmd = [[\otimes]] },
	oo = { context = { name = "o" }, cmd = [[\circ]] },
	ww = { context = { name = "w" }, cmd = [[\wedge]] },
	vv = { context = { name = "v" }, cmd = [[\vee]] },
	nabl = { context = { name = "∇" }, cmd = [[\nabla]] },
	dd = { context = { name = "diferential operator" }, cmd = [[\mathrm{d}]] },
	ill = { context = { name = "imaginary number" }, cmd = [[\mathrm{i}]] },
	cc = { context = { name = "⊆" }, cmd = [[\subseteq ]] },
	cq = { context = { name = "⊊" }, cmd = [[\subsetneq ]] },
	qq = { context = { name = "⊇" }, cmd = [[\supseteq ]] },
	qc = { context = { name = "⊋" }, cmd = [[\supsetneq ]] },
	hh = { context = { name = "∩" }, cmd = [[\cap ]] },
	uu = { context = { name = "∪" }, cmd = [[\cup ]] },
	iff = { context = { name = "⟺" }, cmd = [[\iff ]] },
	upar = { context = { name = "↑" }, cmd = [[\uparrow ]] },
	dnar = { context = { name = "↓" }, cmd = [[\downarrow ]] },
	dag = { context = { name = "†" }, cmd = [[\dagger]] },
	bot = { context = { name = "|_" }, cmd = [[\bot ]] },
	wp = { context = { name = "Weierstrass p function" }, cmd = [[\wp]] },
	lll = { context = { name = "ℓ" }, cmd = [[\ell]] },
	emb = { context = { name = "hookrightarrow" }, cmd = [[\hookrightarrow ]] },
}

local symbol_specs = {
	-- logic
	[";I"] = { context = { name = "∈" }, cmd = [[\in ]] },
	["!I"] = { context = { name = "∉" }, cmd = [[\notin ]] },
	[";A"] = { context = { name = "∀" }, cmd = [[\forall ]] },
	[";E"] = { context = { name = "∃" }, cmd = [[\exists ]] },
	["!E"] = { context = { name = "!∃" }, cmd = [[\nexists ]] },
	["!c"] = { context = { name = "⊈" }, cmd = [[\nsubseteq ]] },
	["!q"] = { context = { name = "⊉" }, cmd = [[\nsupseteq ]] },
	-- operators
	["!="] = { context = { name = "!=" }, cmd = [[\neq ]] },
	[";<"] = { context = { name = "<" }, cmd = [[ < ]] },
	[";>"] = { context = { name = ">" }, cmd = [[ > ]] },
	["<="] = { context = { name = "≤" }, cmd = [[\leq ]] },
	[">="] = { context = { name = "≥" }, cmd = [[\geq ]] },
	["<<"] = { context = { name = "<<" }, cmd = [[\ll ]] },
	[">>"] = { context = { name = ">>" }, cmd = [[\gg ]] },
	["~~"] = { context = { name = "~" }, cmd = [[\sim ]] },
	["~="] = { context = { name = "≃" }, cmd = [[\simeq ]] },
	["=~"] = { context = { name = "≅" }, cmd = [[\cong ]] },
	["::"] = { context = { name = ":" }, cmd = [[\colon ]] },
	[":="] = { context = { name = "≔" }, cmd = [[\coloneqq ]] },
	["**"] = { context = { name = "*" }, cmd = [[^{*}]] },
	["..."] = { context = { name = "·" }, cmd = [[\dots]] },
	["||"] = { context = { name = "|" }, cmd = [[\mid ]] },
	["!|"] = { context = { name = "!|" }, cmd = [[\nmid ]] },
	[";."] = { context = { name = "·" }, cmd = [[\cdot]] },
	[";v"] = { context = { name = "inverse" }, cmd = [[^{-1}]] },
	[";T"] = { context = { name = "ᵀ" }, cmd = [[^{\top}]] },
	[";6"] = { context = { name = "partial" }, cmd = [[\partial]] },
	[";8"] = { context = { name = "infinite" }, cmd = [[\infty]] },
	[";="] = { context = { name = "≡" }, cmd = [[\equiv ]] },
	[";-"] = { context = { name = "\\" }, cmd = [[\setminus ]] },
	-- sets
	[";0"] = { context = { name = "O/" }, cmd = [[\emptyset]] },
	-- arrows
	["=>"] = { context = { name = "⇒" }, cmd = [[\implies ]] },
	["=<"] = { context = { name = "⇐" }, cmd = [[\impliedby ]] },
	["->"] = { context = { name = "→", priority = 250 }, cmd = [[\to ]] },
	["<-"] = { context = { name = "<-", priority = 250 }, cmd = [[\leftarrow ]] },
	["!->"] = { context = { name = "→", priority = 300 }, cmd = [[\nrightarrow ]] },
	["!>"] = { context = { name = "↦" }, cmd = [[\mapsto ]] },
	["!!>"] = { context = { name = "↦" }, cmd = [[\longmapsto ]] },
	["-->"] = { context = { name = "⟶", priority = 500 }, cmd = [[\longrightarrow ]] },
	["<->"] = { context = { name = "↔", priority = 500 }, cmd = [[\longleftrightarrow ]] },
	--["<-->"] = { context = { name = "⟷", priority = 600 }, cmd = [[\longleftrightarrow ]] },
	["2>"] = { context = { name = "⇉", priority = 400 }, cmd = [[\rightrightarrows ]] },
	["/>"] = { context = { name = "/>" }, cmd = [[\nearrow ]] },
	["\\>"] = { context = { name = "\\>" }, cmd = [[\searrow ]] },
	-- greek alphabet
	[";a"] = { context = { name = "alpha" }, cmd = [[\alpha]] },
	[";b"] = { context = { name = "beta" }, cmd = [[\beta]] },
	[";g"] = { context = { name = "gamma" }, cmd = [[\gamma]] },
	[";d"] = { context = { name = "delta" }, cmd = [[\delta]] },
	[";e"] = { context = { name = "epsilon" }, cmd = [[\epsilon]] },
	[";z"] = { context = { name = "zeta" }, cmd = [[\zeta]] },
	[";h"] = { context = { name = "eta" }, cmd = [[\eta]] },
	[";q"] = { context = { name = "theta" }, cmd = [[\theta]] },
	[";i"] = { context = { name = "iota" }, cmd = [[\iota]] },
	[";k"] = { context = { name = "kappa" }, cmd = [[\kappa]] },
	[";l"] = { context = { name = "lambda" }, cmd = [[\lambda]] },
	[";m"] = { context = { name = "mu" }, cmd = [[\mu]] },
	[";n"] = { context = { name = "nu" }, cmd = [[\nu]] },
	[";x"] = { context = { name = "xi" }, cmd = [[\xi]] },
	[";p"] = { context = { name = "pi" }, cmd = [[\pi]] },
	[";r"] = { context = { name = "rho" }, cmd = [[\rho]] },
	[";s"] = { context = { name = "sigma" }, cmd = [[\sigma]] },
	[";t"] = { context = { name = "tau" }, cmd = [[\tau]] },
	[";u"] = { context = { name = "upsilon" }, cmd = [[\upsilon]] },
	[";f"] = { context = { name = "phi" }, cmd = [[\phi]] },
	[";c"] = { context = { name = "chi" }, cmd = [[\chi]] },
	[";y"] = { context = { name = "psi" }, cmd = [[\psi]] },
	[";w"] = { context = { name = "omega" }, cmd = [[\omega]] },
	--capital symbols
	[";G"] = { context = { name = "Gamma" }, cmd = [[\Gamma]] },
	[";D"] = { context = { name = "Delta" }, cmd = [[\Delta]] },
	[";Q"] = { context = { name = "Theta" }, cmd = [[\Theta]] },
	[";L"] = { context = { name = "Lambda" }, cmd = [[\Lambda]] },
	[";X"] = { context = { name = "Xi" }, cmd = [[\Xi]] },
	[";P"] = { context = { name = "Pi" }, cmd = [[\Pi]] },
	[";S"] = { context = { name = "Sigma" }, cmd = [[\Sigma]] },
	[";U"] = { context = { name = "Upsilon" }, cmd = [[\Upsilon]] },
	[";F"] = { context = { name = "Phi" }, cmd = [[\Phi]] },
	--	[";C"] = { context = { name = "Chi" }, cmd = [[\Chi]] },
	[";Y"] = { context = { name = "Psi" }, cmd = [[\Psi]] },
	[";W"] = { context = { name = "Omega" }, cmd = [[\Omega]] },
	--var symbols
	[";1"] = { context = { name = "vartheta" }, cmd = [[\vartheta]] },
	[";2"] = { context = { name = "varphi" }, cmd = [[\varphi]] },
	-- etc
	[";'"] = { context = { name = " " }, cmd = [[\ ]] },
	["\\  "] = { context = { name = "  " }, cmd = [[\quad ]] },
	["\\quad  "] = { context = { name = "   " }, cmd = [[\qquad ]] },
	[";3"] = { context = { name = "#" }, cmd = [[\#]] },
	-- xmm = { context = { name = "x_m" }, cmd = [[x_{m}]] },
	-- xnn = { context = { name = "x_n" }, cmd = [[x_{n}]] },
	-- ymm = { context = { name = "y_m" }, cmd = [[y_{m}]] },
	-- ynn = { context = { name = "y_n" }, cmd = [[y_{n}]] },
}
local symbol_specs2_w = {
	-- sets
	AA = { context = { name = "𝔸" }, cmd = [[\mathbb{A}]] },
	CC = { context = { name = "ℂ" }, cmd = [[\mathbb{C}]] },
	DD = { context = { name = "𝔻" }, cmd = [[\mathbb{D}]] },
	FF = { context = { name = "𝔽" }, cmd = [[\mathbb{F}]] },
	GG = { context = { name = "𝔾" }, cmd = [[\mathbb{G}]] },
	HH = { context = { name = "ℍ" }, cmd = [[\mathbb{H}]] },
	NN = { context = { name = "ℕ" }, cmd = [[\mathbb{N}]] },
	OO = { context = { name = "O" }, cmd = [[\mathcal{O}]] },
	LL = { context = { name = "L" }, cmd = [[\mathcal{L}]] },
	PP = { context = { name = "ℙ" }, cmd = [[\mathbb{P}]] },
	QQ = { context = { name = "ℚ" }, cmd = [[\mathbb{Q}]] },
	RR = { context = { name = "ℝ" }, cmd = [[\mathbb{R}]] },
	ZZ = { context = { name = "ℤ" }, cmd = [[\mathbb{Z}]] },
	iff = { context = { name = "<=>" }, cmd = [[\iff]] },
}
local symbol_specs2 = {
	-- greek alphabet
	[";a"] = { context = { name = "alpha" }, cmd = [[\alpha]] },
	[";b"] = { context = { name = "beta" }, cmd = [[\beta]] },
	[";g"] = { context = { name = "gamma" }, cmd = [[\gamma]] },
	[";d"] = { context = { name = "delta" }, cmd = [[\delta]] },
	[";e"] = { context = { name = "epsilon" }, cmd = [[\epsilon]] },
	[";z"] = { context = { name = "zeta" }, cmd = [[\zeta]] },
	[";h"] = { context = { name = "eta" }, cmd = [[\eta]] },
	[";q"] = { context = { name = "theta" }, cmd = [[\theta]] },
	[";i"] = { context = { name = "iota" }, cmd = [[\iota]] },
	[";k"] = { context = { name = "kappa" }, cmd = [[\kappa]] },
	[";l"] = { context = { name = "lambda" }, cmd = [[\lambda]] },
	[";m"] = { context = { name = "mu" }, cmd = [[\mu]] },
	[";n"] = { context = { name = "nu" }, cmd = [[\nu]] },
	[";x"] = { context = { name = "xi" }, cmd = [[\xi]] },
	[";p"] = { context = { name = "pi" }, cmd = [[\pi]] },
	[";r"] = { context = { name = "rho" }, cmd = [[\rho]] },
	[";s"] = { context = { name = "sigma" }, cmd = [[\sigma]] },
	[";t"] = { context = { name = "tau" }, cmd = [[\tau]] },
	[";u"] = { context = { name = "upsilon" }, cmd = [[\upsilon]] },
	[";f"] = { context = { name = "phi" }, cmd = [[\phi]] },
	[";c"] = { context = { name = "chi" }, cmd = [[\chi]] },
	[";y"] = { context = { name = "psi" }, cmd = [[\psi]] },
	[";w"] = { context = { name = "omega" }, cmd = [[\omega]] },
	--capital symbols
	[";G"] = { context = { name = "Gamma" }, cmd = [[\Gamma]] },
	[";D"] = { context = { name = "Delta" }, cmd = [[\Delta]] },
	[";Q"] = { context = { name = "Theta" }, cmd = [[\Theta]] },
	[";L"] = { context = { name = "Lambda" }, cmd = [[\Lambda]] },
	[";X"] = { context = { name = "Xi" }, cmd = [[\Xi]] },
	[";P"] = { context = { name = "Pi" }, cmd = [[\Pi]] },
	[";S"] = { context = { name = "Sigma" }, cmd = [[\Sigma]] },
	[";U"] = { context = { name = "Upsilon" }, cmd = [[\Upsilon]] },
	[";F"] = { context = { name = "Phi" }, cmd = [[\Phi]] },
	--	[";C"] = { context = { name = "Chi" }, cmd = [[\Chi]] },
	[";Y"] = { context = { name = "Psi" }, cmd = [[\Psi]] },
	[";W"] = { context = { name = "Omega" }, cmd = [[\Omega]] },
	--var symbols
	[";1"] = { context = { name = "vartheta" }, cmd = [[\vartheta]] },
	[";2"] = { context = { name = "varphi" }, cmd = [[\varphi]] },
	--arrows
	["=>"] = { context = { name = "⇒" }, cmd = [[\implies]] },
	["<=>"] = { context = { name = "⟺" }, cmd = [[\iff]] },
	["=<"] = { context = { name = "⇐" }, cmd = [[\impliedby]] },
}

local symbol_snippets = {}
local symbol_snippets2 = {}
for k, v in pairs(single_command_math_specs) do
	table.insert(
		symbol_snippets,
		single_command_snippet(vim.tbl_deep_extend("keep", { trig = k }, v.context), v.cmd, v.ext or {})
	)
end

for k, v in pairs(symbol_specs_w) do
	table.insert(symbol_snippets, symbol_snippet_w(vim.tbl_deep_extend("keep", { trig = k }, v.context), v.cmd))
end

for k, v in pairs(symbol_specs) do
	table.insert(symbol_snippets, symbol_snippet(vim.tbl_deep_extend("keep", { trig = k }, v.context), v.cmd))
end
for k, v in pairs(symbol_specs2_w) do
	table.insert(symbol_snippets2, symbol_snippet2(vim.tbl_deep_extend("keep", { trig = k }, v.context), v.cmd))
end
for k, v in pairs(symbol_specs2) do
	table.insert(symbol_snippets, symbol_snippet2(vim.tbl_deep_extend("keep", { trig = k }, v.context), v.cmd))
end

vim.list_extend(autosnips, symbol_snippets)
vim.list_extend(snips, symbol_snippets2)

return snips, autosnips
