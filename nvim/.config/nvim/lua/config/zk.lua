require('zk').setup({
    picker = 'telescope',
    telescope = require("telescope.themes").get_ivy(),
})

local opts = { noremap = true, silent = false }

-- ZK Plugin Command and Keymapping Support

-- Create a new note after asking for its title.
vim.api.nvim_set_keymap("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
    { noremap = true, silent = false, desc = 'Create new note w/ title', })

vim.api.nvim_set_keymap("n", "<leader>zd", "<Cmd>ZkNew { date = 'today', dir = 'daily' }<CR>",
    { noremap = true, silent = false, desc = 'Open daily note', })

-- Open notes.
vim.api.nvim_set_keymap("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
    { noremap = true, silent = false, desc = 'Open notes', })
-- Open notes associated with the selected tags.
vim.api.nvim_set_keymap("n", "<leader>zt", "<Cmd>ZkTags { sort = { 'name-' } }<CR>",
    { noremap = true, silent = false, desc = 'Open notes for tag', })

-- Search for the notes matching a given query.
vim.api.nvim_set_keymap("n", "<leader>zf",
    "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
    { noremap = true, silent = false, desc = 'Search notes', })

-- Telescope search and insert link for note
vim.api.nvim_set_keymap("n", "<leader>zi", "<Cmd>ZkInsertLink<CR>",
    { noremap = true, silent = false, desc = 'Search and insert link to note', })

-- Search for the notes matching the current visual selection.
vim.api.nvim_set_keymap("v", "<leader>zf", ":'<,'>ZkMatch<CR>",
    { noremap = true, silent = false, desc = 'Search for notes matching selection', })


-- Create new note for current visual selection.


-- Add the key mappings only for Markdown files in a zk notebook.
if require("zk.util").notebook_root(vim.fn.expand('%:p')) ~= nil then
    local function map(...) vim.api.nvim_buf_set_keymap(0, ...) end
    local opts = { noremap = true, silent = false }

    -- Open the link under the caret.
    -- map("n", "<CR>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)

    -- Create a new note after asking for its title.
    -- This overrides the global `<leader>zn` mapping to create the note in the same directory as the current buffer.
    map("n", "<leader>zn", "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", opts)

    -- Create a new note in the same directory as the current buffer, using the current selection for title.
    map("v", "<leader>znt", ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>", opts)

    -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
    map("v", "<leader>znc",
        ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", opts)

    -- Open notes linking to the current buffer.
    map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", opts)

    -- Alternative for backlinks using pure LSP and showing the source context.
    --map('n', '<leader>zb', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- Open notes linked by the current buffer.
    map("n", "<leader>zl", "<Cmd>ZkLinks<CR>", opts)

    -- Preview a linked note.
    map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    -- Open the code actions for a visual selection.
    map("v", "<leader>za", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", opts)
end

