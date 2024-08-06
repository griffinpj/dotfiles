
local ufo = require('ufo')

ufo.setup({})

vim.keymap.set('n', '<leader>zO', ufo.openAllFolds, { desc = 'Open all folds' })
vim.keymap.set('n', '<leader>zC', ufo.closeAllFolds, { desc = 'Close all folds' })

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({buffer = bufnr})
end)

lsp_zero.set_server_config({
    capabilities = {
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }
        }
    }
})


