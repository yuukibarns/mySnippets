local snips = {}

local conds_expand = require("luasnip.extras.conditions.expand")
local pos = require("mySnippets.position")
local opts = { condition = conds_expand.line_begin, show_condition = pos.line_begin }

snips = {
    s(
        { trig = "env", name = "python3 environment", desc = "Declare py3 environment", hidden = false },
        { t({ "#!/usr/bin/env python3", "" }) },
        {
            condition = pos.on_top * conds_expand.line_begin,
            show_condition = pos.on_top * pos.line_begin,
        }
    ),
    s(
        { trig = "###", name = "Separator", desc = "Separator", hidden = true },
        { t("################################################################################") },
        opts
    ),
    -- s(
    --     { trig = "markdown", name = "markdown cell", desc = "markdown cell", hidden = false },
    --     fmt([=[
    --     # %% [markdown]
    --     r"""
    --     {}
    --     """]=],
    --         { i(0) }
    --     ),
    --     opts
    -- ),
    -- s(
    --     { trig = "python", name = "python cell", desc = "python cell", hidden = false },
    --     fmt([[
    --     # %%
    --     {}]],
    --         { i(0) }
    --     ),
    --     opts
    -- ),
}

return snips
