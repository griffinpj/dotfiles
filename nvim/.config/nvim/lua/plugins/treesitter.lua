return {
    {
        'nvim-treesitter/nvim-treesitter',
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            'nvim-treesitter/nvim-treesitter-context',
            'tree-sitter/tree-sitter-embedded-template',
        },
        build = ":TSUpdate",
        config = function()
            require('config.treesitter')
        end
    },
    {
        'nvim-treesitter/playground',
        cmd = "TSPlaygroundToggle",
    }
}
