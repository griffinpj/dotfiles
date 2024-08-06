local vim = vim
local preCog = require("precognition")
local timer = vim.loop.new_timer()

local DELAY = 3000
local function delayCb ()
    if timer then
        timer:stop()
    end

    timer = vim.loop.new_timer()
    timer:start(DELAY, 0, function ()
        vim.schedule(preCog.peek)
    end)
end

-- peek vim motions when complacency > 3s
-- vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
--     pattern = '*',
--     callback = delayCb
-- })

