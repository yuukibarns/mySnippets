local snips, autosnips = {}, {}

local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.latex")
local pos = require("mySnippets.position")

local opts = {
	condition = conds_expand.line_begin * tex.in_text,
	show_condition = pos.line_begin * tex.in_text,
	hidden = true,
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
			show_condition = tex.in_math,
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
}

autosnips = {

	s(
		{
			trig = "beg",
			name = "begin/end",
			desc = "begin/end environment (generic)",
			hidden = true,
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
			hidden = true,
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
			]],
			{ i(1), i(0), l(l._1:gsub("[^%w]+", "_"):gsub("_$", ""):lower(), 0) }
		)
	),
	s(
		{ trig = "lproof", name = "Titled Proof", desc = "Create a titled proof environment." },
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
		{ trig = "(%d+)cases", name = "cases(math)", desc = "cases(math)", regTrig = true },
		fmta(
			[[
			\begin{cases}
				<>
			\end{cases}
			]],
			{ d(1, generate_cases) }
		),
		{
			hidden = true,
			condition = tex.in_math,
			show_condition = tex.in_math,
		}
	),
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
				c(1, { t(" (1)"), t(" (i)"), t(" (A)"), t(" (I)"), t(" (a)") }),
				i(0),
			}
		),
		opts
	),
	s(
		{
			trig = "--",
			hidden = true,
			condition = conds_expand.line_begin * tex.in_bullets,
			show_condition = pos.line_begin * tex.in_bullets,
		},
		fmta(
			[[
			\item <>
			]],
			{ i(0) }
		)
	),
	s(
		{
			trig = "bal",
			name = "align(|*|ed)",
			desc = "align math",
			hidden = true,
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
			trig = "beq",
			name = "begin labeled_equation",
			desc = "labeled_equation",
			hidden = true,
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
			hidden = true,
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
