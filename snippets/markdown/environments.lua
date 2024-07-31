local snips, autosnips = {}, {}

local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.markdown")
local pos = require("mySnippets.position")

local opts = {
	condition = conds_expand.line_begin * tex.in_math,
	show_condition = pos.line_begin * tex.in_math,
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

snips = {
	s(
		{
			trig = "([bBpvVa])mat_(%d+)x_(%d+)",
			name = "[bBpvVa]matrix",
			desc = "matrices",
			regTrig = true,
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

	s(
		{
			trig = "bal",
			name = "aligned",
			desc = "align math",
		},
		fmta(
			[[
			\begin{aligned}
			<>
			\end{aligned}
			]],
			{ i(0) }
		),
		opts
	),

	s(
		{
			trig = "bfu",
			name = "function",
		},
		fmta(
			[[
			\begin{aligned}
			<>
			\end{aligned}
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
		),
		opts
	),
}

return snips, autosnips
