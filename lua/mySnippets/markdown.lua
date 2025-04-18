local M = {}

local cond_obj = require("luasnip.extras.conditions")

local MATH_NODES = {
    displayed_equation = true,
    inline_formula = true,
    math_environment = true,
    latex_block = true,
}

---Check if cursor is in treesitter node of 'math'
---@return boolean
local function in_math()
    local cursor = vim.api.nvim_win_get_cursor(0)
    local row, col = cursor[1], cursor[2]
    if col > 1 then
        local dollars_around_cursor = vim.api.nvim_buf_get_text(0, row - 1, col - 2, row - 1, col + 1, {})
        if string.sub(dollars_around_cursor[1], 1, 1) == "$" and string.sub(dollars_around_cursor[1], 3, 3) == "$" then
            return true
        end
    end
    local node = vim.treesitter.get_node({ ignore_injections = false })
    while node do
        if node:type() == "text_mode" then
            return false
        elseif MATH_NODES[node:type()] then
            return true
        end
        node = node:parent()
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

---Check if cursor is in treesitter node of 'text'
---@return boolean
local function in_text()
    return not M.in_math()
end

M.in_math = cond_obj.make_condition(in_math)
M.in_text = cond_obj.make_condition(in_text)
M.in_text_math = cond_obj.make_condition(in_text_math)

return M
