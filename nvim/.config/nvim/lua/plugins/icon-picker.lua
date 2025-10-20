return {
    "ziontee113/icon-picker.nvim",
    config = function()
        require("icon-picker").setup({ disable_legacy_commands = true })

        vim.keymap.set("n", "<Leader>sp", "<cmd>IconPickerNormal<cr>", { noremap = true, silent = true, desc = 'Pick Icon' })
        vim.keymap.set("n", "<Leader>sy", "<cmd>IconPickerYank<cr>", { noremap = true, silent = true, desc = 'Yank Icon' }) --> Yank the selected icon into register
        vim.keymap.set("i", "<C-i>", "<cmd>IconPickerInsert<cr>", { noremap = true, silent = true, desc = 'Insert Icon' })
   end
}


