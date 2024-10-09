local autosnips = {}

local tex = require("mySnippets.markdown")

local brackets = {
	a = { "\\langle ", "\\rangle" },
	b = { "\\lbrack ", "\\rbrack" },
	c = { "\\{", "\\}" },
	e = { "\\lceil ", "\\rceil" },
	m = { "|", "|" },
	n = { "\\|", "\\|" },
	p = { "(", ")" },
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
			trig = "([l.])([r.])([abcemnp])",
			name = "left right",
			desc = "left right delimiters",
			regTrig = true,
			wordTrig = true,
			condition = tex.in_math,
			show_condition = tex.in_math,
			hidden = true,
		},
		fmta([[\left<><>\right<><>]], {
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
			trig = ";(",
			name = "parentheses",
			desc = "parenthese delimiter",
			wordTrig = false,
			hidden = true,
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
			trig = ";[",
			name = "brackets",
			desc = "bracket delimiter",
			wordTrig = false,
			hidden = true,
			condition = tex.in_math,
			show_condition = tex.in_math,
		},
		fmta(
			[[
			\lbrack <> \rbrack<>
			]],
			{ i(1), i(0) }
		)
	),
	s(
		{
			trig = ";{",
			name = "braces",
			desc = "brace delimiter",
			wordTrig = false,
			hidden = true,
			condition = tex.in_math,
			show_condition = tex.in_math,
		},
		fmta(
			[[
			\{<>\}<>
			]],
			{ i(1), i(0) }
		)
	),
	s(
		{
			trig = ";|",
			name = "norm",
			desc = "norm delimiter",
			wordTrig = false,
			hidden = true,
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
			trig = ";\\|",
			name = "Norm",
			desc = "Norm delimiter",
			wordTrig = false,
			hidden = true,
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
	s(
		{
			trig = "lrg",
			name = "half closed half open interval",
			wordTrig = true,
			hidden = true,
			condition = tex.in_math,
			show_condition = tex.in_math,
		},
		fmta(
			[[
			\lbrack <> \rparen<>
			]],
			{ i(1), i(0) }
		)
	),
	s(
		{
			trig = "lrh",
			name = "half open half closed interval",
			wordTrig = false,
			hidden = true,
			condition = tex.in_math,
			show_condition = tex.in_math,
		},
		fmta(
			[[
			\lparen <> \rbrack<>
			]],
			{ i(1), i(0) }
		)
	),
}

return nil, autosnips
