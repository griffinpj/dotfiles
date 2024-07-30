return {
    'willothy/veil.nvim',
    dependencies = {
        -- All optional, only required for the default setup.
        -- If you customize your config, these aren't necessary.
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim"
    },
    config = function ()
        require('config.veil')
    end,
}
