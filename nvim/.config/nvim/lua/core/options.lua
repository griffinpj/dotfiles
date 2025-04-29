local vim = vim

vim.filetype.add({
    extension = {
        ejs = "html"
    }
})

vim.opt.guicursor = ""

-- relative line numbering
vim.opt.nu = true
vim.opt.relativenumber = true

-- spacing setup
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

-- preserve long history for undotree
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.g.sessions_root = vim.fn.stdpath("config") .. "/nvim/sessions"

vim.o.foldcolumn = '1'
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

-- set colorscheme
vim.cmd.colorscheme('kanagawa')
vim.cmd('highlight TelescopeBorder guibg=none')
vim.cmd('highlight TelescopeTitle guibg=none')


vim.cmd('TSEnable highlight')

