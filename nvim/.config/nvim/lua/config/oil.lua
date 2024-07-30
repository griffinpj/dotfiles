require("oil").setup({
    view_options = {
        show_hidden = true,
    }
})

vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = 'Show directory' })
