-- See list of nvim lsp configs here
-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp

return {
    "mason-org/mason-lspconfig.nvim",
    opts = {
        ensure_installed = { 
            "lua_ls", 
            "rust_analyzer",
            "kotlin_lsp",
            "ts_ls",
            "html",
            "cssls",
            "tailwindcss",
            "graphql",
            "eslint",
        },
    },
    dependencies = {
        { "mason-org/mason.nvim", opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        } },
        "neovim/nvim-lspconfig",
    },
}
