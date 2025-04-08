
require('grug-far').setup({
    -- options, see Configuration section below
    -- there are no required options atm
    -- engine = 'ripgrep' is default, but 'astgrep' or 'astgrep-rules' can
    -- be specified
    vim.keymap.set("n", "<leader>pr", ':GrugFar<CR>', { desc = "Search and replace all"});
    vim.keymap.set("v", "<leader>r", ':GrugFarWithin<CR>', { desc = "Search and replace in selection"});
});
