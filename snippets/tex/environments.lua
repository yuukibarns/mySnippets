local snips, autosnips = {}, {}

local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.latex")
local pos = require("mySnippets.position")

local opts = {
	condition = conds_expand.line_begin * tex.in_text,
	show_condition = pos.line_begin * tex.in_text,
}

-- Generating function for LaTeX environments like matrix and cases
local function generate_env(rows, cols, default_cols)
	cols = cols or default_cols
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ "\\\\", "" }))
	end
	return nodes
end

local generate_matrix = function(_, snip)
	local nodes = generate_env(tonumber(snip.captures[2]), tonumber(snip.captures[3]))
	-- fix last node.
	nodes[#nodes] = t("\\\\")
	return sn(nil, nodes)
end

local generate_cases = function(_, snip)
	local nodes = generate_env(tonumber(snip.captures[1]), 2)
	-- fix last node.
	table.remove(nodes, #nodes)
	return sn(nil, nodes)
end

local function env_snippet(trig, env)
	local context = {
		trig = trig,
		name = trig,
		desc = trig .. " Environment",
	}
	return s(
		context,
		fmta(
			[[
			\begin{<>}
				<>
			\end{<>}
			]],
			{ t(env), i(0), t(env) }
		),
		opts
	)
end

local function named_env_snippet(trig, env)
	local context = {
		trig = "n" .. trig,
		name = trig,
		desc = "Labeled" .. trig .. " Environment",
	}
	return s(
		context,
		fmta(
			[[
			\begin{<>}[<>]
				<>
			\end{<>}
			]],
			{ t(env), i(1), i(0), t(env) }
		),
		opts
	)
end

local function labeled_env_snippet(trig, env)
	local context = {
		trig = "l" .. trig,
		name = trig,
		desc = "Labeled" .. trig .. " Environment",
	}
	return s(
		context,
		fmta(
			[[
			\begin{<>}[<>]\label{<>:<>}
				<>
			\end{<>}
			]],
			{ t(env), i(0), t(trig), l(l._1:gsub("[^%w]+", "_"):gsub("_$", ""):lower(), 1), i(2), t(env) }
		),
		opts
	)
end

snips = {
	s(
		{
			trig = "([bBpvVa])mat_(%d+)x_(%d+)",
			name = "[bBpvVa]matrix",
			desc = "matrices",
			regTrig = true,
			hidden = true,
			condition = tex.in_math,
		},
		fmta(
			[[
			\begin{<>}<>
				<>
			\end{<>}
			]],
			{
				f(function(_, snip)
					if snip.captures[1] == "a" then
						return "array"
					end
					return snip.captures[1] .. "matrix"
				end),
				f(function(_, snip)
					if snip.captures[1] == "a" then
						local out = string.rep("c", tonumber(snip.captures[3]) - 1)
						return "{" .. out .. "c}"
					end
					return ""
				end),
				d(1, generate_matrix),
				f(function(_, snip)
					if snip.captures[1] == "a" then
						return "array"
					end
					return snip.captures[1] .. "matrix"
				end),
			}
		)
	),
	-- s(
	-- 	{
	-- 		trig = "(%d+)eqs",
	-- 		name = "equations(text)",
	-- 		desc = "equations(text)",
	-- 		regTrig = true,
	-- 		hidden = true,
	-- 		condition = tex.in_math,
	-- 	},
	-- 	fmta(
	-- 		[[
	-- 		\begin{aligned}
	-- 			<>
	-- 		\end{aligned}
	-- 		]],
	-- 		{ d(1, generate_eq) }
	-- 	)
	-- ),
	-- s(
	-- 	{
	-- 		trig = "tkmat_(%d+)x_(%d+)",
	-- 		name = "tikzcd Environment",
	-- 		desc = "Create a tikzcd environment.",
	-- 		regTrig = true,
	-- 		hidden = true,
	-- 		condition = tex.in_math,
	-- 	},
	-- 	fmta(
	-- 		[[
	-- 		\begin{tikzcd}
	-- 			<>
	-- 		\end{tikzcd}
	-- 		]],
	-- 		{ d(1, generate_xymatrix) }
	-- 	)
	-- ),
	-- s(
	-- 	{
	-- 		trig = "([d]?)([isb]?)([lrop]?)ar([s]?)",
	-- 		name = "normal arrow in tikzcd",
	-- 		desc = "normal arrow in tikzcd",
	-- 		regTrig = true,
	-- 		hidden = true,
	-- 		condition = tex.in_math,
	-- 	},
	-- 	fmta([[\ar[<>,<>,<>]{<>}[<>]{<>}]], {
	-- 		f(function(_, snip)
	-- 			if snip.captures[1] == "" then
	-- 				return ""
	-- 			end
	-- 			return tk_style[snip.captures[1]]
	-- 		end),
	-- 		f(function(_, snip)
	-- 			if snip.captures[2] == "" then
	-- 				return ""
	-- 			end
	-- 			return tk_arrow[snip.captures[2]]
	-- 		end),
	-- 		f(function(_, snip)
	-- 			if snip.captures[3] == "" then
	-- 				return ""
	-- 			end
	-- 			return tk_curve[snip.captures[3]]
	-- 		end),
	-- 		i(1),
	-- 		f(function(_, snip)
	-- 			if snip.captures[4] == "" then
	-- 				return ""
	-- 			end
	-- 			return tk_swap[snip.captures[4]]
	-- 		end),
	-- 		i(2),
	-- 	})
	-- ),
}

autosnips = {

	s(
		{
			trig = "beg",
			name = "begin/end",
			desc = "begin/end environment (generic)",
			condition = conds_expand.line_begin,
			show_condition = pos.line_begin,
		},
		fmta(
			[[
			\begin{<>}
				<>
			\end{<>}
			]],
			{ i(1), i(0), rep(1) }
		)
	),
	s(
		{
			trig = "fig",
			name = "figure/end",
			desc = "figure/end environment (generic)",
			condition = conds_expand.line_begin,
			show_condition = pos.line_begin,
		},
		fmta(
			[[
				\begin{figure}[h]
				\centering
				\includegraphics[width=0.8\textwidth]{./<>}
				\caption{<>}
				\label{fig:<>}
				\end{figure}
				\FloatBarrier
				<>
			]],
			{ i(1), i(2), l(l._1:gsub("[^%w]+", "_"):gsub("_$", ""):lower(), 2), i(0) }
		)
	),
	s(
		{ trig = "lprf", name = "Titled Proof", desc = "Create a titled proof environment." },
		fmta(
			[[
			\begin{proof}[Proof of <>]
				<>
			\end{proof}
			]],
			{ i(1), i(0) }
		),
		opts
	),

	s(
		{ trig = "(%d+)cases", name = "cases(math)", desc = "cases(math)", regTrig = true, hidden = true },
		fmta(
			[[
			\begin{cases}
				<>
			\end{cases}
			]],
			{ d(1, generate_cases) }
		),
		{
			condition = tex.in_math,
			show_condition = tex.in_math,
		}
	),

	-- s(
	-- 	{ trig = "(%d+)cases", name = "cases(text)", desc = "cases(text)", regTrig = true, hidden = true },
	-- 	fmta(
	-- 		[[
	-- 		<>
	-- 		]],
	-- 		{ d(1, generate_cases2) }
	-- 	),
	-- 	opts
	-- ),
	-- s(
	-- 	{ trig = "(%d+)eqs", name = "equations(text)", desc = "equations(text)", regTrig = true, hidden = true },
	-- 	fmta(
	-- 		[[
	-- 		\begin{align*}
	-- 			<>
	-- 		\end{align*}
	-- 		]],
	-- 		{ d(1, generate_eq) }
	-- 	),
	-- 	opts
	-- ),
	-- s(
	-- 	{
	-- 		trig = "(%d+)leqs",
	-- 		name = "labeled equations(text)",
	-- 		desc = "labeled equations(text)",
	-- 		regTrig = true,
	-- 		hidden = true,
	-- 	},
	-- 	fmta(
	-- 		[[
	-- 		\begin{align}
	-- 			<>
	-- 		\end{align}
	-- 		]],
	-- 		{ d(1, generate_eq) }
	-- 	),
	-- 	opts
	-- ),
	-- s(
	-- 	{
	-- 		trig = "xymat(%d+)x(%d+)",
	-- 		name = "xymatrix Environment",
	-- 		desc = "Create a xymatrix environment.",
	-- 		regTrig = true,
	-- 		hidden = true,
	-- 	},
	-- 	fmta(
	-- 		[[
	-- 		\[
	-- 			\xymatrix{
	-- 				<>
	-- 			}
	-- 		\]
	-- 		]],
	-- 		{ d(1, generate_xymatrix) }
	-- 	),
	-- 	opts
	-- ),
	-- s(
	-- 	{
	-- 		trig = "tkmat(%d+)x(%d+)",
	-- 		name = "tikzcd Environment",
	-- 		desc = "Create a tikzcd environment.",
	-- 		regTrig = true,
	-- 		hidden = true,
	-- 	},
	-- 	fmta(
	-- 		[[
	-- 		\[
	-- 			\begin{tikzcd}
	-- 				<>
	-- 			\end{tikzcd}
	-- 		\]
	-- 		]],
	-- 		{ d(1, generate_xymatrix) }
	-- 	),
	-- 	opts
	-- ),
	s(
		{ trig = "bit", name = "itemize", desc = "bullet points (itemize)" },
		fmta(
			[[
			\begin{itemize}
				<>
			\end{itemize}
			]],
			{ i(0) }
		),
		opts
	),
	s(
		{ trig = "ben", name = "enumerate", desc = "numbered list (enumerate)" },
		fmta(
			[[
			\begin{enumerate}[<>]
				<>
			\end{enumerate}
			]],
			{
				c(1, { t(" (1) "), t(" (i) "), t(" (A) "), t(" (I) "), t(" (a) ") }),
				i(0),
			}
		),
		opts
	),

	-- generate new bullet points
	s(
		{
			trig = "--",
			hidden = true,
			condition = conds_expand.line_begin * tex.in_bullets,
			show_condition = pos.line_begin * tex.in_bullets,
		},
		fmta(
			[[
			\item 
				  <>
			<>
			]],
			{ i(1), i(0) }
		)
	),

	-- s({
	-- 	trig = "!-",
	-- 	name = "bullet point",
	-- 	desc = "bullet point with custom text",
	-- 	condition = conds_expand.line_begin * tex.in_bullets,
	-- 	show_condition = pos.line_begin * tex.in_bullets,
	-- }, fmta([[\item [<>]<>]], { i(1), i(0) })),

	s(
		{
			trig = "bal",
			name = "align(|*|ed)",
			desc = "align math",
			condition = conds_expand.line_begin,
			show_condition = pos.line_begin,
		},
		fmta(
			[[
			\begin{align<>}
				<>
			\end{align<>}
			]],
			{ c(1, { t("*"), t(""), t("ed") }), i(0), rep(1) }
		)
	),

	s(
		{
			trig = "bfu",
			name = "function",
			condition = conds_expand.line_begin,
			show_condition = pos.line_begin,
		},
		fmta(
			[[
		\begin{align*}
			<>
		\end{align*}
		]],
			{
				c(1, {
					fmta(
						[[
						<> \colon <> & \longrightarrow <>\\
						<> & \longmapsto <>
						]],
						{ i(1), i(2), i(3), i(4), i(5) }
					),
					fmta(
						[[
						<> & \longrightarrow <>\\
						<> & \longmapsto <>	
						]],
						{ i(1), i(2), i(3), i(4) }
					),
					fmta(
						[[
						<> & \leftrightarrow <>\\
						<> & \leftrightarrow <>
						]],
						{ i(1), i(2), i(3), i(4) }
					),
				}),
			}
		)
	),

	--	s(
	--		{
	--			trig = "bsq",
	--			name = "equation*",
	--			condition = conds_expand.line_begin,
	--			show_condition = pos.line_begin,
	--		},
	--		fmta(
	--			[[
	--			\[ <> \]<>
	--			]],
	--			{ i(1), i(0) }
	--		)
	--	),

	s(
		{
			trig = "beq",
			name = "begin labeled_equation",
			desc = "labeled_equation",
			condition = conds_expand.line_begin,
			show_condition = pos.line_begin,
		},
		fmta(
			[[
			\begin{equation}
				<>
			\end{equation}		
			]],
			{ i(0) }
		)
	),
	s(
		{
			trig = "bleq",
			name = "begin labeled_equation",
			desc = "labeled_equation",
			condition = conds_expand.line_begin,
			show_condition = pos.line_begin,
		},
		fmta(
			[[
			\begin{equation}\label{eq:<>}
				<>
			\end{equation}		
			]],
			{ i(1), i(0) }
		)
	),
}

local env_specs = {
	--beq = "equation",
	--bseq = "equation*",
	proof = "proof",
}

local labeled_env_specs = {
	thm = "theorem",
	lem = "lemma",
	def = "definition",
	prop = "proposition",
	cor = "corollary",
	rem = "remark",
	conj = "conjecture",
	exa = "example",
	exer = "exercise",
	prob = "problem",
}

env_specs = vim.tbl_extend("keep", env_specs, labeled_env_specs)

local env_snippets = {}

for k, v in pairs(env_specs) do
	table.insert(env_snippets, env_snippet(k, v))
end

for k, v in pairs(labeled_env_specs) do
	table.insert(env_snippets, named_env_snippet(k, v))
end

for k, v in pairs(labeled_env_specs) do
	table.insert(env_snippets, labeled_env_snippet(k, v))
end

vim.list_extend(autosnips, env_snippets)

return snips, autosnips
