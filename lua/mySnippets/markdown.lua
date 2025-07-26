local M = {}

local cond_obj = require("luasnip.extras.conditions")
local get_node_text = vim.treesitter.get_node_text

local MATH_NODES = {
    displayed_equation = true,
    inline_formula = true,
    math_environment = true,
    latex_block = true,
}

local MATH_STYLE = {
    mathrm = true,
    mathit = true,
    bm = false,
    mathbf = false,
}

---Check if cursor is in treesitter node of 'math'
---@return boolean
local function in_math()
    local node = vim.treesitter.get_node({ ignore_injections = false })
    while node do
        if node:type() == "text_mode" then
            return false
        elseif node:type() == "generic_command" then
            local command = node:field("command")

            if command and command[1] and MATH_STYLE[get_node_text(command[1], 0):gsub("^\\", "")] then
                return false
            end
        elseif MATH_NODES[node:type()] then
            return true
        end
        node = node:parent()
    end
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row, col = cursor[1], cursor[2]
    if col > 1 then
        local dollars_around_cursor = vim.api.nvim_buf_get_text(0, row - 1, col - 2, row - 1, col + 1, {})
        if string.sub(dollars_around_cursor[1], 1, 1) == "$" and string.sub(dollars_around_cursor[1], 3, 3) == "$" then
            return true
        end
    end
    return false
end

---Check if cursor is in \text{} inside latex block
---@return boolean
local function in_text_math()
    local node = vim.treesitter.get_node({ ignore_injections = false })
    local text = false
    while node do
        if node:type() == "text_mode" then
            text = true
        elseif MATH_NODES[node:type()] then
            if not text then
                return false
            else
                return true
            end
        end
        node = node:parent()
    end
    return false
end

M.in_math = cond_obj.make_condition(in_math)
M.in_text = -M.in_math
M.in_text_math = cond_obj.make_condition(in_text_math)

return M
