local wk = require("which-key")

wk.add({
    { "<leader>f", group = "file" },
    { "<leader>z", group = "zettl" },
    { "<leader>p", group = "search" },
    { "<leader>m", group = "motions" },
    { "<leader>g", group = "git" },
    { "<leader>l", group = "lazy" },
    { "<leader>r", group = "replace" },
    { "<leader>u", desc = "View undotree" },
    { "<leader>s", desc = "icons" },
    { "<leader>c", desc = "claude & lsp" },

    -- { "<leader>fb", function() print("hello") end, desc = "Foobar" },
    -- { "<leader>fn", desc = "New File" },
    -- { "<leader>f1", hidden = true }, -- hide this keymap
    -- { "<leader>w", proxy = "<c-w>", group = "windows" }, -- proxy to window mappings

    -- Leader mappings
    { "<leader>ff", vim.lsp.buf.format, desc = 'Format file' },
    { "<leader>fx", "<cmd>!chmod +x %<CR>", desc = "Set file as executable" },
    { "<leader>q", "<cmd>q<cr>", desc = "Quit" }, -- no need to specify mode since it's inherited
    { "<leader>fw", "<cmd>w<cr>", desc = "Write" },
    { "<leader>rs", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc = 'Replace string' },
    {
        "<leader>b",
        group = "buffers",
        expand = function()
            return require("which-key.extras").expand.buf()
        end
    },
    {
        mode = { 'n', 'v' },
        { "<leader>k", "<cmd>lnext<CR>zz", desc = "Next quickfix line" },
        { "<leader>j", "<cmd>lprev<CR>zz", desc = "Previous quickfix line" },
        { "<leader>y", [["+y]], desc = "Copy selected text into system clipboard" },
        { "<leader>Y", [["+Y]], desc = "Copy selected lines into system clipboard" },
        { "<leader>P", [["_dP]], desc = "Paste over selection and keep clipboard" },

    }
})

