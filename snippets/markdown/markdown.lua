local snips = {}

local conds_expand = require("luasnip.extras.conditions.expand")
local pos = require("mySnippets.position")
local tex = require("mySnippets.tex")

local opts = { condition = conds_expand.line_begin, show_condition = pos.line_begin }
local opts2 = { condition = tex.in_text, show_condition = tex.in_text }

-- Generating function for LaTeX environments like matrix and cases
local function generate_env(rows, cols, default_cols)
    cols = cols or default_cols
    local nodes = {}
    local ins_indx = 1
    for j = 1, rows do
        if j == 1 then
            table.insert(nodes, t("| "))
            table.insert(nodes, i(ins_indx, "x" .. tostring(j) .. "1"))
            ins_indx = ins_indx + 1
            for k = 2, cols do
                table.insert(nodes, t(" | "))
                table.insert(nodes, i(ins_indx, "x" .. tostring(j) .. tostring(k)))
                ins_indx = ins_indx + 1
            end
            table.insert(nodes, t({ " |", "" }))
            table.insert(nodes, t("| "))
            table.insert(nodes, t("---"))
            for _ = 2, cols do
                table.insert(nodes, t(" | "))
                table.insert(nodes, t("---"))
            end
            table.insert(nodes, t({ " |", "" }))
        else
            table.insert(nodes, t("| "))
            table.insert(nodes, i(ins_indx, "x" .. tostring(j) .. "1"))
            ins_indx = ins_indx + 1
            for k = 2, cols do
                table.insert(nodes, t(" | "))
                table.insert(nodes, i(ins_indx, "x" .. tostring(j) .. tostring(k)))
                ins_indx = ins_indx + 1
            end
            table.insert(nodes, t({ " |", "" }))
        end
    end
    return nodes
end

local generate_table = function(_, snip)
    local nodes = snip.captures and generate_env(tonumber(snip.captures[1]), tonumber(snip.captures[2])) or generate_env(2, 2)
    -- fix last node.
    table.remove(nodes, #nodes)
    table.insert(nodes, t(" |"))
    return sn(nil, nodes)
end

snips = {
    s({ trig = "bo", name = "Bold text", desc = "Bold text" }, fmt([[**{}**{}]], { i(1), i(0) }), opts2),
    s({ trig = "io", name = "Italic text", desc = "Italic text" }, fmt([[*{}*{}]], { i(1), i(0) }), opts2),
    s({ trig = "bio", name = "Bold Italic text", desc = "Bold Italic text" }, fmt([[_**{}**_{}]], { i(1), i(0) }), opts2),
    s({ trig = "mark", name = "Highlighted text", desc = "Highlighted text" }, fmt([[<mark>{}</mark>{}]], { i(1), i(0) }), opts2),
    s({ trig = "lo", name = "Link text", desc = "Link text" }, fmt("[{}]({})", { i(1), i(0) }), opts2),
    s({ trig = "uo", name = "URL", desc = "URL" }, fmt("<{}>{}", { i(1), i(0) }), opts2),
    s({ trig = "foo", name = "Footnote", desc = "Footnote" }, fmt("[^{}]{}", { i(1), i(0) }), opts2),
    s({ trig = "imo", name = "Image", desc = "Image" }, fmt("![{}]({})", { i(1), i(0) }), opts2),
    s({ trig = "co", name = "Code text", desc = "Code text" }, fmt([[`{}`{}]], { i(1), i(0) }), opts2),
    s(
        { trig = "blo", name = "Code block", desc = "Code block" },
        fmt(
            [[
        ```{}
        {}
        ```
        ]],
            { i(1), i(0) }
        ),
        opts
    ),
    s(
        { trig = "def", name = "Definition", desc = "Definition" },
        t("**Definition.**"),
        opts
    ),
    s(
        { trig = "Def", name = "Definition", desc = "Definition" },
        fmt("**Definition ({}).**{}", { i(1), i(0) }),
        opts
    ),
    s(
        { trig = "thm", name = "Theorem", desc = "Theorem" },
        t("**Theorem.**"),
        opts
    ),
    s(
        { trig = "Thm", name = "Theorem", desc = "Theorem" },
        fmt("**Theorem ({}).**{}", { i(1), i(0) }),
        opts
    ),
    s(
        { trig = "lem", name = "Lemma", desc = "Lemma" },
        t("**Lemma.**"),
        opts
    ),
    s(
        { trig = "Lem", name = "Lemma", desc = "Lemma" },
        fmt("**Lemma ({}).**{}", { i(1), i(0) }),
        opts
    ),
    s(
        { trig = "cor", name = "Corollary", desc = "Corollary" },
        t("**Corollary.**"),
        opts
    ),
    s(
        { trig = "Cor", name = "Corollary", desc = "Corollary" },
        fmt("**Corollary ({}).**{}", { i(1), i(0) }),
        opts
    ),
    s(
        { trig = "prop", name = "Proposition", desc = "Proposition" },
        t("**Proposition.**"),
        opts
    ),
    s(
        { trig = "Prop", name = "Proposition", desc = "Proposition" },
        fmt("**Proposition ({}).**{}", { i(1), i(0) }),
        opts
    ),
    s(
        { trig = "claim", name = "Claim", desc = "Claim" },
        t("**Claim.**"),
        opts
    ),
    s(
        { trig = "Claim", name = "Claim", desc = "Claim" },
        fmt("**Claim ({}).**{}", { i(1), i(0) }),
        opts
    ),
    s(
        { trig = "example", name = "Example", desc = "Example" },
        t("**Example.**"),
        opts
    ),
    s(
        { trig = "Example", name = "Example", desc = "Example" },
        fmt("**Example ({}).**{}", { i(1), i(0) }),
        opts
    ),
    s(
        { trig = "prob", name = "Problem", desc = "Problem" },
        t("**Problem.**"),
        opts
    ),
    s(
        { trig = "Prob", name = "Problem", desc = "Problem" },
        fmt("**Problem ({}).**{}", { i(1), i(0) }),
        opts
    ),
    s(
        { trig = "note", name = "Note", desc = "Note" },
        t("[!NOTE]"),
        opts2
    ),
    s(
        { trig = "tip", name = "Tip", desc = "Tip" },
        t("[!TIP]"),
        opts2
    ),
    s(
        { trig = "important", name = "Important", desc = "Important" },
        t("[!IMPORTANT]"),
        opts2
    ),
    s(
        { trig = "warning", name = "Warning", desc = "Warning" },
        t("[!WARNING]"),
        opts2
    ),
    s(
        { trig = "caution", name = "Caution", desc = "Caution" },
        t("[!CAUTION]"),
        opts2
    ),
    s(
        { trig = "toc", name = "TOC", desc = "Table Of Contents" },
        t("[[toc]]"),
        opts2
    ),
    s(
        { trig = "deno-fmt-ignore", name = "deno-fmt-ignore", desc = "Deno Format Ignore" },
        t("<!-- deno-fmt-ignore -->"),
        opts
    ),
    s(
        { trig = "deno-fmt-ignore-start", name = "deno-fmt-ignore", desc = "Deno Format Ignore" },
        t("<!-- deno-fmt-ignore-start -->"),
        opts
    ),
    s(
        { trig = "deno-fmt-ignore-end", name = "deno-fmt-ignore", desc = "Deno Format Ignore" },
        t("<!-- deno-fmt-ignore-end -->"),
        opts
    ),
    s(
        {
            trig = "table(%d+)x(%d+)",
            name = "table",
            docTrig = "table",
            desc = "table",
            regTrig = true,
            hidden = false,
        },
        fmta(
            [[
            <>
            ]],
            {
                d(1, generate_table),
            }
        ),
        opts
    ),
}

return snips, nil
