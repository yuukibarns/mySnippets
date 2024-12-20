local snips = {}

local tex = require("mySnippets.markdown")

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
	table.remove(nodes, #nodes)
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
			trig = "([bBpvVa]?)mat(%d+)x(%d+)",
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
					if snip.captures[1] == "" then
						return "pmatrix"
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
					if snip.captures[1] == "" then
						return "pmatrix"
					end
					return snip.captures[1] .. "matrix"
				end),
			}
		)
	),
	s(
		{ trig = "(%d+)cases", name = "cases(math)", desc = "cases(math)", regTrig = true, hidden = false },
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
		{ trig = "cases", name = "cases(math)", desc = "cases(math)", hidden = false },
		fmta(
			[[
			\begin{cases}
			<>
			\end{cases}
			]],
			{ i(0) }
		),
		{
			condition = tex.in_math,
			show_condition = tex.in_math,
		}
	),
	s(
		{
			trig = "bbal",
			name = "bbal",
			desc = "brace aligned",
			hidden = false,
		},
		fmta(
			[[
			\left\lbrace\begin{aligned}
			<>
			\end{aligned}\right.
			]],
			{ i(0) }
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
			hidden = false,
		},
		fmta(
			[[
			\begin{aligned}
			<>
			\end{aligned}
			]],
			{ i(0) }
		),
		{
			condition = tex.in_math,
			show_condition = tex.in_math,
		}
	),
	s(
		{
			trig = "matrix",
			name = "matrix",
			desc = "matrix",
			hidden = false,
		},
		fmta(
			[[
			\begin{pmatrix}
			<>
			\end{pmatrix}
			]],
			{ i(0) }
		),
		{
			condition = tex.in_math,
			show_condition = tex.in_math,
		}
	),
}

return snips, nil
