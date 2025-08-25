return {
    'stevearc/oil.nvim',
    cmd = "Oil",
    keys = { { "-", "<cmd>Oil<cr>", desc = "Open Oil" } },
    event = "VimEnter",
    opts = {},
    -- Optional dependencies
    -- dependencies = { { "echasnovski/mini.icons", opts = {} } },
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    config = function ()
        require("config.oil")
    end,
}
