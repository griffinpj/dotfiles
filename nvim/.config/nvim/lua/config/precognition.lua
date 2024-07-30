local preCog = require("precognition")

preCog.setup({
    opts = {
        highlightColor = { link = "Comment" },
    }
})

preCog.toggle()

vim.keymap.set('n', '<leader>mt', preCog.toggle, { desc = 'Toggle motions preview' })
vim.keymap.set('n', '<leader>mp', preCog.peek, { desc = 'Peek motions preview' })
