return {
    "arsham/arshamiser.nvim",
    dependencies = {
        "arsham/arshlib.nvim",
        "famiu/feline.nvim",
        "rebelot/heirline.nvim",
        "kyazdani42/nvim-web-devicons",
        "lewis6991/gitsigns.nvim",
    },
    config = function ()
        require('config.status-line')
    end,
}
