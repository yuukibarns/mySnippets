local snips = {}

local tex = require("mySnippets.tex")
local opts = { condition = tex.in_math, show_condition = tex.in_math }

-- Generating function for LaTeX environments like matrix and cases
local function generate_env(rows, cols, default_cols)
    cols = cols or default_cols
    local nodes = {}
    local ins_indx = 1
    for j = 1, rows do
        table.insert(nodes, t("    "))
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
    local nodes = snip.captures and generate_env(tonumber(snip.captures[2]), tonumber(snip.captures[3])) or generate_env(2, 2)
    -- fix last node.
    table.remove(nodes, #nodes)
    table.insert(nodes, t("\\\\"))
    return sn(nil, nodes)
end

local generate_cases = function(_, snip)
    local nodes = snip.captures and generate_env(tonumber(snip.captures[1]), 2) or generate_env(2, 2)
    -- fix last node.
    table.remove(nodes, #nodes)
    table.insert(nodes, t("\\\\"))
    return sn(nil, nodes)
end

snips = {
    s(
        {
            trig = "([bBpvVa]?)mat([1-9])x([1-9])",
            name = "matrix",
            desc = "matrices",
            docTrig = "matrix",
            regTrig = true,
            hidden = false,
        },
        fmta(
            [[
            \begin{<>}<>
            <>
            \end{<>}
            ]],
            {
                f(function(_, snip)
                    if snip.captures then
                        if snip.captures[1] == "a" then
                            return "array"
                        end
                        if snip.captures[1] == "" then
                            return "pmatrix"
                        end
                        return snip.captures[1] .. "matrix"
                    else
                        return "pmatrix"
                    end
                end),
                f(function(_, snip)
                    if snip.captures and snip.captures[1] == "a" then
                        local out = string.rep("c", tonumber(snip.captures[3]) - 1)
                        return "{" .. out .. "c}"
                    end
                    return ""
                end),
                d(1, generate_matrix),
                f(function(_, snip)
                    if snip.captures then
                        if snip.captures[1] == "a" then
                            return "array"
                        end
                        if snip.captures[1] == "" then
                            return "pmatrix"
                        end
                        return snip.captures[1] .. "matrix"
                    else
                        return "pmatrix"
                    end
                end),
            }
        ),
        opts
    ),
    s(
        { trig = "(%d+)cases", name = "some cases", docTrig = "some cases", desc = "cases(math)", regTrig = true, hidden = false },
        fmta(
            [[
            \begin{cases}
            <>
            \end{cases}
            ]],
            { d(1, generate_cases) }
        ),
        opts
    ),
    s(
        { trig = "cases", name = "cases(math)", desc = "cases(math)", hidden = false },
        fmta(
            [[
            \begin{cases}
              <> \\
            \end{cases}
            ]],
            { i(0) }
        ),
        opts
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
              <> \\
            \end{aligned}
            ]],
            { i(0) }
        ),
        opts
    ),
}

return snips, nil
