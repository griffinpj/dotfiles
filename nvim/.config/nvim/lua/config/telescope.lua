require('telescope').setup({
    pickers = {
        live_grep = {
            additional_args = function()
                return { '--fixed-strings' }
            end,
            layout_config = {
                horizontal = {
                    width = 0.95,
                    preview_width = 0.6
                }
            }
        },
        find_files = {
            additional_args = function()
                return { '--fixed-strings' }
            end,
            layout_config = {
                horizontal = {
                    width = 0.95,
                    preview_width = 0.6
                }
            }
        },
        git_files = {
            additional_args = function()
                return { '--fixed-strings' }
            end,
            layout_config = {
                horizontal = {
                    width = 0.95,
                    preview_width = 0.6
                }
            }
        }
    },
    extensions = {
        themes = {
            layout_config = {
                horizontal = {
                    width = 0.8,
                    height = 0.6
                }
            },
            enable_previewer = true,
            enable_live_preview = true,
        }
    }
})


local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Search files' })
vim.keymap.set('n', '<leader>pc', builtin.commands, { desc = 'Search commands' })
vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = 'Search buffers' })
vim.keymap.set('n', '<leader>pc', builtin.commands, { desc = 'Search commands' })
vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = 'Search in files' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Search git files' })


