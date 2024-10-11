local autosnips = {}
local snips = {}
local tex = require("mySnippets.markdown")

local opts = { condition = tex.in_math }
local opts_show = { condition = tex.in_math, show_condition = tex.in_math }

local function symbol_snippet(context, cmd)
	context.desc = cmd
	context.name = context.name or cmd:gsub([[\]], "")
	context.docstring = cmd .. [[{0}]]
	context.wordTrig = false
	context.hidden = true
	return s(context, t(cmd), opts_show)
end

local function symbol_snippet_wordtrig_true(context, cmd)
	context.desc = cmd
	context.name = context.name or cmd:gsub([[\]], "")
	context.docstring = cmd .. [[{0}]]
	context.wordTrig = true
	context.hidden = false
	return s(context, t(cmd), opts)
end

local function single_command_snippet(context, cmd, ext)
	context.desc = context.desc or cmd
	context.name = context.name or context.desc
	context.hidden = false
	local docstring, offset, cnode, lnode
	if ext.choice == true then
		docstring = "[" .. [[(<1>)?]] .. "]" .. [[{]] .. [[<2>]] .. [[}]] .. [[<0>]]
		offset = 1
		cnode = c(1, { t(""), sn(nil, { t("["), i(1, "opt"), t("]") }) })
	else
		docstring = [[{]] .. [[<1>]] .. [[}]] .. [[<0>]]
	end
	context.docstring = context.docstring or (cmd .. docstring)
	return s(
		context,
		fmta(cmd .. [[<>{<>}<><>]], { cnode or t(""), i(1 + (offset or 0)), (lnode or t("")), i(0) }),
		opts
	)
end

autosnips = {
	s(
		{ trig = '"', name = "auto supscript", wordTrig = false, hidden = true },
		fmta([[^{<>}<>]], { i(1), i(0) }),
		opts_show
	),
	s(
		{ trig = "_", name = "auto subscript", wordTrig = false, hidden = true },
		fmta([[_{<>}<>]], { i(1), i(0) }),
		opts_show
	),
}

local single_command_math_specs = {
	text = {
		context = { name = "text (math)", desc = "text in math mode" },
		cmd = [[\text]],
	},
	mathbb = {
		context = { name = "mathbb", desc = "mathbb text" },
		cmd = [[\mathbb]],
	},
	mathcal = {
		context = { name = "mathcal", desc = "mathcal text" },
		cmd = [[\mathcal]],
	},
	mathscr = {
		context = { name = "mathscr", desc = "mathscr text" },
		cmd = [[\mathscr]],
	},
	mathfrak = {
		context = { name = "mathfrak", desc = "mathfrak text" },
		cmd = [[\mathfrak]],
	},
	bm = {
		context = { name = "bm", desc = "bold math text" },
		cmd = [[\bm]],
	},
	mathrm = {
		context = { name = "mathrm", desc = "mathrm text" },
		cmd = [[\mathrm]],
	},
	boxed = {
		context = { name = "boxed", desc = "boxed" },
		cmd = [[\boxed]],
	},
	sqrt = {
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
	vec = {
		context = { name = "vector", desc = "vector" },
		cmd = [[\vec]],
	},
	tilde = {
		context = { name = "tilde", desc = "wide tilde" },
		cmd = [[\widetilde]],
	},
	ring = {
		context = { name = "mathring", desc = "mathring" },
		cmd = [[\mathring]],
	},
	substack = {
		context = { name = "substack", desc = "substack for sums/products" },
		cmd = [[\substack]],
	},
	xrightarrow = {
		context = { name = "xrightarrow", desc = "xrightarrow" },
		cmd = [[\xrightarrow]],
	},
	xleftarrow = {
		context = { name = "xleftarrow", desc = "xleftarrow" },
		cmd = [[\xleftarrow]],
	},
	tag = {
		context = { name = "tag", desc = "add tag" },
		cmd = [[\tag]],
	},
	dot = {
		context = { name = "dot derivatives", desc = "physical derivatives" },
		cmd = [[\dot]],
	},
	ddot = {
		context = { name = "dot derivatives", desc = "physical derivatives" },
		cmd = [[\ddot]],
	},
	dddot = {
		context = { name = "dot derivatives", desc = "physical derivatives" },
		cmd = [[\dddot]],
	},
}

local symbol_specs_wordtrig_true = {
	-- not
	["not"] = { context = { name = "not" }, cmd = [[\not]] },
	-- sets
	AA = { context = { name = "𝔸" }, cmd = [[\mathbb{A}]] },
	CC = { context = { name = "ℂ" }, cmd = [[\mathbb{C}]] },
	DD = { context = { name = "𝔻" }, cmd = [[\mathbb{D}]] },
	FF = { context = { name = "𝔽" }, cmd = [[\mathbb{F}]] },
	GG = { context = { name = "𝔾" }, cmd = [[\mathbb{G}]] },
	HH = { context = { name = "ℍ" }, cmd = [[\mathbb{H}]] },
	NN = { context = { name = "ℕ" }, cmd = [[\mathbb{N}]] },
	PP = { context = { name = "ℙ" }, cmd = [[\mathbb{P}]] },
	QQ = { context = { name = "ℚ" }, cmd = [[\mathbb{Q}]] },
	RR = { context = { name = "ℝ" }, cmd = [[\mathbb{R}]] },
	ZZ = { context = { name = "ℤ" }, cmd = [[\mathbb{Z}]] },
	-- operators
	times = { context = { name = "×" }, cmd = [[\times]] },
	oplus = { context = { name = "⊕" }, cmd = [[\oplus]] },
	otimes = { context = { name = "⊗" }, cmd = [[\otimes]] },
	circ = { context = { name = "o" }, cmd = [[\circ]] },
	wedge = { context = { name = "w" }, cmd = [[\wedge]] },
	vee = { context = { name = "v" }, cmd = [[\vee]] },
	nabla = { context = { name = "∇" }, cmd = [[\nabla]] },
	subset = { context = { name = "⊂" }, cmd = [[\subset]] },
	supset = { context = { name = "⊃" }, cmd = [[\supset]] },
	cap = { context = { name = "∩" }, cmd = [[\cap]] },
	cup = { context = { name = "∪" }, cmd = [[\cup]] },
	sqcap = { context = { name = "⊓" }, cmd = [[\sqcap]] },
	sqcup = { context = { name = "⊔" }, cmd = [[\sqcup]] },
	dagger = { context = { name = "†" }, cmd = [[\dagger]] },
	bot = { context = { name = "⊥" }, cmd = [[\bot]] },
	wp = { context = { name = "℘" }, cmd = [[\wp]] },
	hbar = { context = { name = "ℏ" }, cmd = [[\hbar]] },
	ell = { context = { name = "ℓ" }, cmd = [[\ell]] },
	star = { context = { name = "✫" }, cmd = [[\star]] },
	ast = { context = { name = "∗" }, cmd = [[\ast]] },
	mid = { context = { name = "∗" }, cmd = [[\mid]] },
	nmid = { context = { name = "!|" }, cmd = [[\nmid]] },
	partial = { context = { name = "∂" }, cmd = [[\partial]] },
	infty = { context = { name = "∞" }, cmd = [[\infty]] },
	--var symbols
	vartheta = { context = { name = "vartheta" }, cmd = [[\vartheta]] },
	varphi = { context = { name = "varphi" }, cmd = [[\varphi]] },
	-- equality
	leq = { context = { name = "≤" }, cmd = [[\leq]] },
	geq = { context = { name = "≥" }, cmd = [[\geq]] },
	neq = { context = { name = "≠" }, cmd = [[\neq]] },
	coloneqq = { context = { name = "≔" }, cmd = [[\coloneqq]] },
	cong = { context = { name = "≅" }, cmd = [[\cong]] },
	equiv = { context = { name = "≡" }, cmd = [[\equiv]] },
	sim = { context = { name = "~" }, cmd = [[\sim]] },
	-- arrows
	uparrow = { context = { name = "↑" }, cmd = [[\uparrow]] },
	downarrow = { context = { name = "↓" }, cmd = [[\downarrow]] },
	nearrow = { context = { name = "↗" }, cmd = [[\nearrow]] },
	searrow = { context = { name = "↘" }, cmd = [[\searrow]] },
	hookrightarrow = { context = { name = "↪" }, cmd = [[\hookrightarrow]] },
	iff = { context = { name = "⟺" }, cmd = [[\iff]] },
	implies = { context = { name = "⇒" }, cmd = [[\implies]] },
	impliedby = { context = { name = "⇐" }, cmd = [[\impliedby]] },
	to = { context = { name = "→" }, cmd = [[\to]] },
	leftarrow = { context = { name = "←" }, cmd = [[\leftarrow]] },
	longleftrightarrow = { context = { name = "↔" }, cmd = [[\longleftrightarrow]] },
	longrightarrow = { context = { name = "⟶" }, cmd = [[\longrightarrow]] },
	rightrightarrows = { context = { name = "⇉" }, cmd = [[\rightrightarrows]] },
	mapsto = { context = { name = "↦" }, cmd = [[\mapsto]] },
	longmapsto = { context = { name = "↦" }, cmd = [[\longmapsto]] },
	-- numbers
	one = { context = { name = "1" }, cmd = [[1]] },
	two = { context = { name = "2" }, cmd = [[2]] },
	three = { context = { name = "3" }, cmd = [[3]] },
	four = { context = { name = "4" }, cmd = [[4]] },
	five = { context = { name = "5" }, cmd = [[5]] },
	six = { context = { name = "6" }, cmd = [[6]] },
	seven = { context = { name = "7" }, cmd = [[7]] },
	eight = { context = { name = "8" }, cmd = [[8]] },
	nine = { context = { name = "9" }, cmd = [[9]] },
	zero = { context = { name = "0" }, cmd = [[0]] },
	-- basic symbols
	amper = { context = { name = "&" }, cmd = [[&]] },
	pound = { context = { name = "#" }, cmd = [[\#]] },
	pipe = { context = { name = "|" }, cmd = [[|]] },
	eqq = { context = { name = "=" }, cmd = [[=]] },
	add = { context = { name = "+" }, cmd = [[+]] },
	-- spaces
	quad = { context = { name = "  " }, cmd = [[\quad]] },
	qquad = { context = { name = "   " }, cmd = [[\qquad]] },
}

local symbol_specs = {
	-- logic
	[";I"] = { context = { name = "∈" }, cmd = [[\in]] },
	[";A"] = { context = { name = "∀" }, cmd = [[\forall]] },
	[";E"] = { context = { name = "∃" }, cmd = [[\exists]] },
	-- operators
	["<<"] = { context = { name = "<<" }, cmd = [[\ll]] },
	[">>"] = { context = { name = ">>" }, cmd = [[\gg]] },
	["::"] = { context = { name = ":" }, cmd = [[\colon]] },
	["..."] = { context = { name = "…" }, cmd = [[\dots]] },
	[";."] = { context = { name = "·" }, cmd = [[\cdot]] },
	[";<"] = { context = { name = "⟨" }, cmd = [[\langle]] },
	[";>"] = { context = { name = "⟩" }, cmd = [[\rangle]] },
	[";-"] = { context = { name = "⧵" }, cmd = [[\setminus]] },
	-- sets
	[";0"] = { context = { name = "Ø" }, cmd = [[\emptyset]] },
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
	[";Y"] = { context = { name = "Psi" }, cmd = [[\Psi]] },
	[";W"] = { context = { name = "Omega" }, cmd = [[\Omega]] },
}

local symbol_snippets = {}
local symbol_snippets_manual = {}
for k, v in pairs(single_command_math_specs) do
	table.insert(
		symbol_snippets,
		single_command_snippet(vim.tbl_deep_extend("keep", { trig = k }, v.context), v.cmd, v.ext or {})
	)
end

for k, v in pairs(symbol_specs_wordtrig_true) do
	table.insert(
		symbol_snippets,
		symbol_snippet_wordtrig_true(vim.tbl_deep_extend("keep", { trig = k }, v.context), v.cmd)
	)
end

for k, v in pairs(symbol_specs) do
	table.insert(symbol_snippets, symbol_snippet(vim.tbl_deep_extend("keep", { trig = k }, v.context), v.cmd))
end

vim.list_extend(autosnips, symbol_snippets)
vim.list_extend(snips, symbol_snippets_manual)

return snips, autosnips
