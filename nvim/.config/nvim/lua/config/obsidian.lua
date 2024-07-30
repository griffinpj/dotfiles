require('obsidian').setup({
    workspaces = {
        {
            name = "palace",
            path = "~/vaults/Palace",
        },
    },
    -- completion = {
    --     nvim_cmp = true,
    --     min_chars = 2
    -- },
    mappings = {
        -- Navigate through vault while on note link
        ["<leader>og"] = {
            action = function ()
                return require('obsidian').util.gf_passthrough()
            end,
            opts = { noremap = true, expr = true, buffer = true }
        },
    },
    picker = {
        name = "telescope.nvim",
        note_mappings = {
            -- Create a new note from your query.
            new = "<C-o>",
            -- Insert a link to the selected note.
            insert_link = "<C-l>",
        },
    },
    ui = {
        enable = true,
    },
    attachments = {
        img_folder = "assets/attachments",
    }
})
