    return {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
        config = function ()
            require("config.telescope")
        end
    }
