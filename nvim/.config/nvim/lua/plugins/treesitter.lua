return {
    {'nvim-treesitter/nvim-treesitter' },
    {'nvim-treesitter/nvim-treesitter-context'},
    {'tree-sitter/tree-sitter-embedded-template'},
    {'nvim-treesitter/playground'},
    config = function ()
        vim.cmd("TSUpdate")
    end
}
