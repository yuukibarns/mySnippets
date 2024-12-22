local autosnips = {}

local tex = require("mySnippets.markdown")

local brackets = {
	a = { "\\langle ", "\\rangle" },
	b = { "\\lbrack ", "\\rbrack" },
	B = { "\\{", "\\}" },
	c = { "\\lceil ", "\\rceil" },
	f = { "\\lfloor ", "\\rfloor" },
	m = { "|", "|" },
	n = { "\\|", "\\|" },
	p = { "(", ")" },
	v = { ".", "|" },
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
			trig = "lr([abBcfmnpv])",
			name = "left right",
			desc = "left right delimiters",
			regTrig = true,
			wordTrig = true,
			condition = tex.in_math,
			hidden = true,
		},
		fmta([[\left<> <> \right<><>]], {
			f(function(_, snip)
					local cap = snip.captures[1] or "p"
					return brackets[cap][1]
			end),
			d(1, get_visual),
			f(function(_, snip)
					local cap = snip.captures[1] or "p"
					return brackets[cap][2]
			end),
			i(0),
		})
	),
	s(
		{
			trig = ";o",
			name = "parentheses",
			desc = "parenthese delimiter",
			wordTrig = false,
			hidden = true,
			condition = tex.in_math,
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
			trig = "abs",
			name = "norm",
			desc = "norm delimiter",
			wordTrig = true,
			hidden = false,
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
			trig = "norm",
			name = "Norm",
			desc = "Norm delimiter",
			wordTrig = true,
			hidden = false,
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
