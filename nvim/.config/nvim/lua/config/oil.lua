require("oil").setup({
    default_file_explorer = true,
    view_options = {
        show_hidden = true,
        natural_order = true,
    },
    win_options = {
        signcolumn = 'auto',
    },
    preview_win = {
        update_on_cursor_moved = false,
        preview_method = 'load',
        disable_preview = function (filename)
            return true
        end,
        win_options = {},
    },
    keymaps = {
        ['yp'] = {
            desc = 'Copy filepath to system clipboard',
            callback = function ()
                require('oil.actions').copy_entry_path.callback()
                vim.fn.setreg("+", vim.fn.getreg(vim.v.register))
            end,
        },
    },
})

vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = 'Show directory' })
