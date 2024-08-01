local autosnips = {}

-- local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.latex")

local brackets = {
	a = { "\\langle", "\\rangle" },
	--	A = { "Angle", "Angle" },
	b = { "[", "]" },
	--	B = { "Brack", "Brack" },
	c = { "\\{", "\\}" },
	m = { "|", "|" },
	n = { "\\|", "\\|" },
	p = { "(", ")" },
	g = { "[", ")" },
	h = { "(", "]" },
}

local function get_visual(_, parent)
	if #parent.snippet.env.SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
	else
		return sn(nil, i(1))
	end
end

autosnips = {
	s(
		{
			trig = "([l.])([r.])([abcmnpgh])",
			name = "left right",
			desc = "left right delimiters",
			regTrig = true,
			hidden = true,
			wordTrig = false,
			condition = tex.in_math,
			show_condition = tex.in_math,
		},
		fmta([[\left<> <> \right<><>]], {
			f(function(_, snip)
				if snip.captures[1] == "." then
					return "."
				else
					local cap = snip.captures[3] or "p"
					return brackets[cap][1]
				end
			end),
			d(1, get_visual),
			f(function(_, snip)
				if snip.captures[2] == "." then
					return "."
				else
					local cap = snip.captures[3] or "p"
					return brackets[cap][2]
				end
			end),
			i(0),
		})
	),
	s(
		{
			trig = ";o",
			name = "parentheses",
			desc = "parenthese delimiter",
			regTrig = true,
			wordTrig = false,
			condition = tex.in_math,
			show_condition = tex.in_math,
		},
		fmta(
			[[
			(<>)<>
			]],
			{ i(1), i(0) }
		)
	),
	s(
		{
			trig = ";9",
			name = "brackets",
			desc = "bracket delimiter",
			regTrig = true,
			wordTrig = false,
			condition = tex.in_math,
			show_condition = tex.in_math,
		},
		fmta(
			[[
			[<>]<>
			]],
			{ i(1), i(0) }
		)
	),
	s(
		{
			trig = ";,",
			name = "angles",
			desc = "angle delimiter",
			regTrig = true,
			wordTrig = false,
			condition = tex.in_math,
			show_condition = tex.in_math,
		},
		fmta(
			[[
			\langle <> \rangle <>
			]],
			{ i(1), i(0) }
		)
	),
	s(
		{
			trig = ";\\",
			name = "norm",
			desc = "norm delimiter",
			regTrig = true,
			wordTrig = false,
			condition = tex.in_math,
			show_condition = tex.in_math,
		},
		fmta(
			[[
			|<>|<>
			]],
			{ i(1), i(0) }
		)
	),
	s(
		{
			trig = ";|",
			name = "Norm",
			desc = "Norm delimiter",
			regTrig = true,
			wordTrig = false,
			condition = tex.in_math,
			show_condition = tex.in_math,
		},
		fmta(
			[[
			\|<>\|<>
			]],
			{ i(1), i(0) }
		)
	),
	-- s(
	-- 	{
	-- 		trig = "cvec",
	-- 		name = "column vector",
	-- 		hidden = true,
	-- 		condition = conds_expand.line_begin * tex.in_math,
	-- 	},
	-- 	fmta(
	-- 		[[
	-- 		\begin{pmatrix}
	-- 			<>_<> \\
	-- 			\vdots \\
	-- 			<>_<>
	-- 		\end{pmatrix}
	-- 		]],
	-- 		{ i(1, "x"), i(2, "1"), rep(1), i(3, "n") }
	-- 	)
	-- ),
}

return nil, autosnips
