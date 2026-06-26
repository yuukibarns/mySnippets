local autosnips = {}
local snips = {}
local tex = require("mySnippets.tex").conds

local conds_expand = require("luasnip.extras.conditions.expand")

-- Basic math context option
local opts = { condition = tex.in_math, show_condition = tex.in_math }

-- Option for empty prefix modifiers ('~, 'c, 't, 'b, etc.)
-- It only triggers if NOT preceded by a letter, digit, or backslash.
local prefix_opts = {
    condition = tex.in_math * conds_expand.trigger_not_preceded_by("[%w\\]"),
    show_condition = tex.in_math
}

-- Option for single delimiters so they don't trigger when preceded by `'`
local autopair_opts = {
    condition = tex.in_math * conds_expand.trigger_not_preceded_by("'"),
    show_condition = tex.in_math
}

local semicolon_opts = {
    condition = tex.in_math * conds_expand.trigger_not_preceded_by(";"),
    show_condition = tex.in_math
}


-- Default superscripts & subscripts
autosnips = {
    s(
        { trig = '^', name = "auto supscript", wordTrig = false, hidden = true },
        fmta([[^{<>}<>]], { i(1), i(0) }),
        opts
    ),
    s(
        { trig = "_", name = "auto subscript", wordTrig = false, hidden = true },
        fmta([[_{<>}<>]], { i(1), i(0) }),
        opts
    ),
}

-------------------------------------------------------------------------------
-- 1. Math-Mode Auto-Pairing for Delimiters (Guarded from `'` conflict)
-------------------------------------------------------------------------------
table.insert(autosnips, s(
    { trig = "(", name = "auto pair (", wordTrig = false, hidden = true },
    fmta("(<>)", { i(1) }),
    autopair_opts
))
table.insert(autosnips, s(
    { trig = "[", name = "auto pair [", wordTrig = false, hidden = true },
    fmta("[<>]", { i(1) }),
    autopair_opts
))
table.insert(autosnips, s(
    { trig = "{", name = "auto pair {", wordTrig = false, hidden = true },
    fmta("{<>}", { i(1) }),
    autopair_opts
))

-------------------------------------------------------------------------------
-- 2. Modifiers configuration (Accents, Fonts, & Left-Right Pairs)
-------------------------------------------------------------------------------
local modifiers = {
    -- Accents (standard commands)
    ["~"] = { cmd = [[\tilde]] },
    ["T"] = { cmd = [[\widetilde]] },
    ["^"] = { cmd = [[\hat]] },
    ["H"] = { cmd = [[\widehat]] },
    ["-"] = { cmd = [[\bar]] },
    ["O"] = { cmd = [[\overline]] },
    ["."] = { cmd = [[\dot]] },
    [":"] = { cmd = [[\ddot]] },
    ["_"] = { cmd = [[\underline]] },
    ["v"] = { cmd = [[\vec]] },
    ["}"] = { cmd = [[\underbrace]] },
    ["]"] = { cmd = [[\boxed]] },
    ["o"] = { cmd = [[\mathring]] },
    -- Fonts (standard commands)
    ["c"] = { cmd = [[\mathcal]] },
    ["b"] = { cmd = [[\mathbf]] },
    ["r"] = { cmd = [[\mathrm]] },
    ["t"] = { cmd = [[\text]] },
    ["s"] = { cmd = [[\mathscr]] },
    ["a"] = { cmd = [[\mathbb]] },
    ["f"] = { cmd = [[\mathfrak]] },
    ["m"] = { cmd = [[\bm]] },
}

local modifier_pairs = {
    ["("] = { left = [[\left(]], right = [[\right)]] },
    ["["] = { left = [=[\left[]=], right = [=[\right]]=] },
    ["{"] = { left = [[\left\{]], right = [[\right\}]] },
    ["<"] = { left = [[\left\langle]], right = [[\right\rangle]] },
    ["|"] = { left = [[\left|]], right = [[\right|]] },
    ["\\|"] = { left = [[\left\|]], right = [[\right\|]] },
}

-- Helper to safely build regex character classes
local function escape_pattern(text)
    -- Parentheses around gsub force it to return only 1 value
    return (text:gsub("([^%w])", "%%%1"))
end

-- Build the character class pattern dynamically from the modifier keys
local mod_keys = {}
for k, _ in pairs(modifiers) do
    table.insert(mod_keys, escape_pattern(k))
end
local mod_pattern = "[" .. table.concat(mod_keys) .. "]"

-- Regex trigger pattern for postfix modifications (e.g. x'~ -> \tilde{x}, x'[ -> \left[ x \right])
local modifier_trig = "([%w\\]+)'(" .. mod_pattern .. ")"

table.insert(autosnips, s(
    {
        trig = modifier_trig,
        regTrig = true,
        wordTrig = false,
        hidden = true,
        condition = tex.in_math,
        show_condition = tex.in_math,
    },
    {
        f(function(_, snip)
            local target = snip.captures[1]
            local mod = snip.captures[2]
            local data = modifiers[mod]
            return data.cmd .. "{" .. target .. "}"
        end)
    }
))

for mod, data in pairs(modifiers) do
    table.insert(autosnips, s(
        { trig = "'" .. mod, name = data.cmd, wordTrig = false, hidden = true },
        fmta(data.cmd .. [[{<>}<>]], { i(1), i(0) }),
        prefix_opts
    ))
end

for mod, data in pairs(modifier_pairs) do
    table.insert(autosnips, s(
        { trig = "'" .. mod, name = data.left .. " ... " .. data.right, wordTrig = false, hidden = true },
        fmta(data.left .. [[ <> ]] .. data.right .. [[<>]], { i(1), i(0) }),
        prefix_opts
    ))
end

-------------------------------------------------------------------------------
-- 3. CDLaTeX Multi-Level Semicolon Symbols
-------------------------------------------------------------------------------
local math_symbol_alist = {
    a = { [[\alpha]] },
    b = { [[\beta]] },
    d = { [[\delta]], [[\partial]] },
    e = { [[\epsilon]], [[\varepsilon]] },
    f = { [[\phi]], [[\varphi]] },
    g = { [[\gamma]] },
    h = { [[\eta]], [[\hbar]] },
    i = { [[\iota]], [[\imath]] },
    k = { [[\kappa]] },
    l = { [[\lambda]], [[\ell]] },
    m = { [[\mu]] },
    n = { [[\nu]], [[\nabla]] },
    o = { [[\omega]] },
    w = { [[\omega]] },
    p = { [[\pi]], [[\varpi]] },
    q = { [[\theta]], [[\vartheta]] },
    r = { [[\rho]], [[\varrho]] },
    s = { [[\sigma]], [[\varsigma]] },
    t = { [[\tau]] },
    u = { [[\upsilon]] },
    v = { [[\vee]] },
    x = { [[\xi]] },
    c = { [[\chi]] },
    y = { [[\psi]] },
    z = { [[\zeta]] },

    A = { [[\forall]] },
    I = { [[\in]] },
    D = { [[\Delta]] },
    E = { [[\exists]] },
    F = { [[\Phi]] },
    G = { [[\Gamma]] },
    L = { [[\Lambda]] },
    O = { [[\Omega]] },
    W = { [[\Omega]] },
    P = { [[\Pi]] },
    Q = { [[\Theta]] },
    S = { [[\Sigma]] },
    U = { [[\Upsilon]] },
    X = { [[\Xi]] },
    Y = { [[\Psi]] },

    ["0"] = { [[\emptyset]] },
    ["8"] = { [[\infty]] },
    ["!"] = { [[\neg]] },
    ["^"] = { [[\uparrow]] },
    ["&"] = { [[\wedge]] },
    ["~"] = { [[\approx]], [[\simeq]] },
    ["_"] = { [[\downarrow]] },
    ["+"] = { [[\cup]] },
    ["-"] = { [[\leftrightarrow]], [[\longleftrightarrow]] },
    ["*"] = { [[\times]] },
    ["/"] = { [[\not]] },
    ["|"] = { [[\mapsto]], [[\longmapsto]] },
    ["\\"] = { [[\setminus]] },
    ["="] = { [[\Leftrightarrow]], [[\Longleftrightarrow]] },
    ["("] = { [[\langle]] },
    [")"] = { [[\rangle]] },
    ["["] = { [[\Leftarrow]], [[\Longleftarrow]] },
    ["]"] = { [[\Rightarrow]], [[\Longrightarrow]] },
    ["{"] = { [[\subset]] },
    ["}"] = { [[\supset]] },
    ["<"] = { [[\langle]] },
    [">"] = { [[\rangle]] },
    ["'"] = { [[\prime]] },
    ["."] = { [[\cdot]] },
}

-- Helpers
local function symbol_snippet(context, cmd)
    context.desc = cmd
    -- Parentheses around gsub force it to return only 1 value
    local clean_name = (cmd:gsub([[\]], ""))
    context.name = context.name or clean_name
    context.docstring = cmd .. [[{0}]]
    context.wordTrig = false
    context.hidden = true
    return s(context, t(cmd), semicolon_opts)
end

-- Process levels dynamically
local symbol_snippets = {}
for k, list in pairs(math_symbol_alist) do
    for level, cmd in ipairs(list) do
        if cmd ~= "" then
            -- Generates ";" for level 1, ";;" for level 2, ";;;" for level 3, etc.
            local prefix = string.rep(";", level)
            local trig = prefix .. k
            table.insert(
                symbol_snippets,
                symbol_snippet({ trig = trig }, cmd)
            )
        end
    end
end

-- Distribute into LuaSnip tables
vim.list_extend(autosnips, symbol_snippets)

return snips, autosnips
