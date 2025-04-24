-- ignore any parts you don't want to use
vim.opt.termguicolors = true
vim.cmd.colorscheme("arshamiser_light")
require("arshamiser.feliniser")
-- or:
-- require("arshamiser.heirliniser")

_G.custom_foldtext = require("arshamiser.folding").foldtext
vim.opt.foldtext = "v:lua.custom_foldtext()"
-- if you want to draw a tabline:
vim.api.nvim_set_option("tabline", [[%{%v:lua.require("arshamiser.tabline").draw()%}]])
