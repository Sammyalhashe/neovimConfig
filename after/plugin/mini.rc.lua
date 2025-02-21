local utils = require "utils"

--> mini.pick
require("mini.pick").setup({
    mappings = {
        move_down = '<C-j>',
        move_up = '<C-k>',
        scroll_down = '<C-d>',
        scroll_up = '<C-f>',
        choose_marked = '<M-m>',
    },
    window = {
        prompt_prefix = " ",
    }
})
require("mini.extra").setup()

--> mini.files
require("mini.files").setup()

--> mini.surround
require("mini.surround").setup()

--> mini.visits
require("mini.visits").setup({

})


local setup_initializations = function()
    --> mini.pick
    local lua = "<cmd>lua "
    local pick = "<cmd>Pick "
    local mini_visits = "MiniVisits."
    local cr = "<cr>"

    -- Setup mappings (normal mode)
    utils.map_allbuf('n', '<leader>ff', pick .. "files" .. cr)
    utils.map_allbuf('n', '<leader>pf', pick .. " git_files" .. cr)
    utils.map_allbuf('n', '<leader>ag', pick .. " grep_live" .. cr)
    utils.map_allbuf('n', '<leader>b', pick .. " buffers" .. cr)
    utils.map_allbuf('n', '<leader>mr', pick .. " resume" .. cr)
    utils.map_allbuf('n', '<leader>mR', pick .. " resume" .. cr)

    --> mini.files
    local minifiles = "<cmd>lua MiniFiles"
    utils.map_allbuf('n', '<leader>c', minifiles .. ".open()" .. cr)

    --> mini.visits
    -- utils.map_allbuf('n', '<leader>mva', lua .. mini_visits .. "add_label()" .. cr, "Add label")
    -- utils.map_allbuf('n', '<leader>mvr', lua .. mini_visits .. "remove_label()" .. cr, "Remove label")
    -- utils.map_allbuf('n', '<leader>mvs', lua .. mini_visits .. "select_label('','')" .. cr, "Select label (all)")
    -- utils.map_allbuf('n', '<leader>mvc', lua .. mini_visits .. "select_label()" .. cr, "Select label (cwd)")

    local map_vis = function(keys, call, desc)
        local rhs = '<Cmd>lua MiniVisits.' .. call .. '<CR>'
        vim.keymap.set('n', '<Leader>' .. keys, rhs, { desc = desc })
    end

    map_vis('vv', 'add_label("core")', 'Add to core')
    map_vis('vV', 'remove_label("core")', 'Remove from core')
    map_vis('vc', 'select_path("", { filter = "core" })', 'Select core (all)')
    map_vis('vC', 'select_path(nil, { filter = "core" })', 'Select core (cwd)')

    -- Iterate based on recency
    local map_iterate_core = function(lhs, direction, desc)
        local opts = { filter = 'core', sort = sort_latest, wrap = true }
        local rhs = function()
            MiniVisits.iterate_paths(direction, vim.fn.getcwd(), opts)
        end
        vim.keymap.set('n', lhs, rhs, { desc = desc })
    end

    map_iterate_core('vl', 'last', 'Core label (earliest)')
    map_iterate_core('vn', 'forward', 'Core label (earlier)')
    map_iterate_core('vp', 'backward', 'Core label (later)')
    map_iterate_core('vf', 'first', 'Core label (latest)')
end


setup_initializations()
