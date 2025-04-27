return {
    {'nvim-treesitter/nvim-treesitter' },
    {'nvim-treesitter/nvim-treesitter-context'},
    {'tree-sitter/tree-sitter-embedded-template'},
    {'nvim-treesitter/playground'},
    lazy = false,
    config = function ()
        vim.cmd("TSUpdate")
        require('config.treesitter')
    end
}
