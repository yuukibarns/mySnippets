local M = {}

local get_node_text = vim.treesitter.get_node_text
local get_node = vim.treesitter.get_node
local cond_obj = require("luasnip.extras.conditions")

local MATH_NODES = {
    displayed_equation = true,
    inline_formula = true,
    math_environment = true,
}

local MATH_STYLE = {
    mathrm = true,
    mathit = true,
    mathbf = true,
    bm = true,
}

local ALIGN_ENVS = {
    multline = true,
    eqnarray = true,
    align = true,
    aligned = true,
    array = true,
    split = true,
    alignat = true,
    gather = true,
    flalign = true,
}

local BULLET_ENVS = {
    itemize = true,
    enumerate = true,
}

---Check if cursor is in treesitter node of 'math'
---@return boolean
local function in_math()
    local node = get_node({ ignore_injections = false })
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
        if string.sub(dollars_around_cursor[1], 1, 1) == "$"
            and string.sub(dollars_around_cursor[1], 3, 3) == "$"
        then
            return true
        end
    end

    return false
end

---Check if cursor is in \text{} inside latex block
---@return boolean
local function in_text_math()
    local node = get_node({ ignore_injections = false })
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

---Check if cursor is in treesitter node of 'math_environment': 'align'
---@return boolean
local function in_align()
    local node = get_node({ ignore_injections = false })
    while node do
        if node:type() == "math_environment" then
            local begin = node:child(0)
            local names = begin and begin:field("name")

            if names and names[1] and ALIGN_ENVS[get_node_text(names[1], 0):gsub("{(%w+)%s*%*?}", "%1")] then
                return true
            end
        end
        node = node:parent()
    end
    return false
end

local function in_bullets()
    local node = get_node({ ignore_injections = false })
    while node do
        if node:type() == "generic_environment" then
            local begin = node:child(0)
            local names = begin and begin:field("name")

            if names and names[1] and BULLET_ENVS[get_node_text(names[1], 0):gsub("{(%w+)}", "%1")] then
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

M.in_align = cond_obj.make_condition(in_align)
M.in_bullets = cond_obj.make_condition(in_bullets)

return M
