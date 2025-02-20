local snips = {}

local conds_expand = require("luasnip.extras.conditions.expand")
local tex = require("mySnippets.latex")
local pos = require("mySnippets.position")

local opts = {
	hidden = true,
	condition = conds_expand.line_begin * tex.in_text,
	show_condition = pos.line_begin * tex.in_text,
}

local function sec_snippet(trig, env)
	local context = {
		trig = trig,
		name = trig,
		desc = trig .. " Environment",
	}
	return s(
		context,
		fmta(
			[[
			\<>{<>}
			]],
			{ t(env), i(0) }
		),
		opts
	)
end

local function labeled_sec_snippet(trig, env)
	local context = {
		trig = "l" .. trig,
		name = trig,
		desc = trig .. " Environment",
	}
	return s(
		context,
		fmta(
			[[
			\<>{<>}\label{<>:<>}
			]],
			{ t(env), i(0), t(trig), l(l._1:gsub("[^%w]+", "_"):gsub("_$", ""):lower(), 0) }
		),
		opts
	)
end

local sec_specs = {
	cha = "chapter",
	ccha = "chapter*",
	sec = "section",
	ssec = "section*",
	sub = "subsection",
	ssub = "subsection*",
}

for k, v in pairs(sec_specs) do
	table.insert(snips, sec_snippet(k, v))
end

for k, v in pairs(sec_specs) do
	table.insert(snips, labeled_sec_snippet(k, v))
end

return snips, nil
