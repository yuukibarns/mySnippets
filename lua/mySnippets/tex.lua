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

local pending = {}

---@param bufnr? integer
---@return integer, integer
local function current_pos(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if bufnr ~= vim.api.nvim_get_current_buf() then
        return 0, 0
    end
    local cursor = vim.api.nvim_win_get_cursor(0)
    return cursor[1], cursor[2]
end

---Check if cursor is in treesitter node of 'math'
---@param node TSNode
---@param bufnr integer
---@return boolean
local function in_math_impl(node, bufnr)
    while node do
        if node:type() == "text_mode" then
            return false
        elseif node:type() == "generic_command" then
            local command = node:field("command")

            if command and command[1] and MATH_STYLE[get_node_text(command[1], bufnr):gsub("^\\", "")] then
                return false
            end
        elseif MATH_NODES[node:type()] then
            return true
        end
        node = node:parent()
    end

    return false
end

---Check if cursor is in \text{} inside latex block
---@param node TSNode
---@param bufnr integer
---@return boolean
local function in_text_math_impl(node, bufnr)
    local text = false
    while node do
        if node:type() == "text_mode" then
            text = true
        elseif MATH_NODES[node:type()] then
            return text
        end
        node = node:parent()
    end
    return false
end

---Check if cursor is in treesitter node of 'math_environment': 'align'
---@param node TSNode
---@param bufnr integer
---@return boolean
local function in_align_impl(node, bufnr)
    while node do
        if node:type() == "math_environment" then
            local begin = node:child(0)
            local names = begin and begin:field("name")

            if names and names[1] and ALIGN_ENVS[get_node_text(names[1], bufnr):gsub("{(%w+)%s*%*?}", "%1")] then
                return true
            end
        end
        node = node:parent()
    end
    return false
end

---@param node TSNode
---@param bufnr integer
---@return boolean
local function in_bullets_impl(node, bufnr)
    while node do
        if node:type() == "generic_environment" then
            local begin = node:child(0)
            local names = begin and begin:field("name")

            if names and names[1] and BULLET_ENVS[get_node_text(names[1], bufnr):gsub("{(%w+)}", "%1")] then
                return true
            end
        end
        node = node:parent()
    end
    return false
end

---@param node TSNode
---@param bufnr integer
---@return boolean
local function in_code_impl(node, bufnr)
    while node do
        if node:type() == "code_fence_content" then
            return true
        end
        node = node:parent()
    end
    return false
end

---@param bufnr? integer
function M.update(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    if not vim.api.nvim_buf_is_valid(bufnr) then
        return
    end
    local row, col = current_pos(bufnr)
    local node = get_node({
        bufnr = bufnr,
        pos = { row - 1, col },
        ignore_injections = false,
    })
    local node2 = get_node({
        bufnr = bufnr,
        pos = { row - 1, col },
        ignore_injections = true,
    })

    if not node then return end
    if not node2 then return end

    vim.b[bufnr].tex_in_math = in_math_impl(node, bufnr)
    vim.b[bufnr].tex_in_text_math = in_text_math_impl(node, bufnr)
    vim.b[bufnr].tex_in_align = in_align_impl(node, bufnr)
    vim.b[bufnr].tex_in_bullets = in_bullets_impl(node, bufnr)
    vim.b[bufnr].tex_in_code = in_code_impl(node2, bufnr)

    if col > 0 then
        local dollars_around_cursor = vim.api.nvim_buf_get_text(bufnr, row - 1, col - 1, row - 1, col + 1, {})
        local s = dollars_around_cursor[1]
        if s and s:sub(1, 1) == "$" and s:sub(2, 2) == "$" then
            vim.b[bufnr].tex_in_math = true
        end
    end
end

---@param bufnr? integer
---@param delay? integer
function M.schedule_update(bufnr, delay)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    delay = delay or 30

    pending[bufnr] = (pending[bufnr] or 0) + 1
    local ticket = pending[bufnr]

    vim.defer_fn(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then
            return
        end
        if pending[bufnr] ~= ticket then
            return
        end
        pcall(M.update, bufnr)
    end, delay)
end

---@param bufnr? integer
---@return boolean
function M.in_math(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    return vim.b[bufnr].tex_in_math == true
end

---@param bufnr? integer
---@return boolean
function M.in_text_math(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    return vim.b[bufnr].tex_in_text_math == true
end

---@param bufnr? integer
---@return boolean
function M.in_align(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    return vim.b[bufnr].tex_in_align == true
end

---@param bufnr? integer
---@return boolean
function M.in_bullets(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    return vim.b[bufnr].tex_in_bullets == true
end

---@param bufnr? integer
---@return boolean
function M.in_code(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    return vim.b[bufnr].tex_in_code == true
end

M.conds = {
    in_math = cond_obj.make_condition(function()
        return M.in_math() and not M.in_code()
    end),
    in_text = cond_obj.make_condition(function()
        return not M.in_math() and not M.in_code()
    end),
    in_text_math = cond_obj.make_condition(function()
        return M.in_text_math() and not M.in_code()
    end),
    in_align = cond_obj.make_condition(function()
        return M.in_align() and not M.in_code()
    end),
    in_bullets = cond_obj.make_condition(function()
        return M.in_bullets() and not M.in_code()
    end),
}

return M
