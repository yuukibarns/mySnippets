local username = "yuukibarns"
local comment = require("mySnippets.context")

local function todo_snippet_nodes(alias)
    -- format them into the actual snippet
    local comment_node = fmt("{}{}: {}", {
        t(alias),                                  -- [name-of-comment]
        t("(" .. username .. ")"), -- [comment-mark]
        i(0),
    })
    return comment_node
end

--- Generate a TODO comment snippet with an automatic description and docstring
---@param trig string
---@param alias string
local function todo_snippet(trig, alias)
    local context = {
        trig = trig,
        name = alias .. " comment",
        desc = alias .. " comment with a signature-mark",
    }
    local comment_node = todo_snippet_nodes(alias)

    return s(
        context,
        comment_node,
        {
            condition = comment.in_comments,
            show_condition = comment.in_comments,
            hidden = false,
        }
    )
end

local base_specs = {
    todo = "TODO",
    fix = "FIX",
    hack = "HACK",
    warn = "WARN",
    perf = "PERF",
    note = "NOTE",
}

local todo_comment_snippets = {}

for k, v in pairs(base_specs) do
    table.insert(todo_comment_snippets, todo_snippet(k, v))
end

return todo_comment_snippets
