local telescope = require('telescope')
local open_with_trouble = require("trouble.sources.telescope").open

telescope.setup({
    pickers = {
        live_grep = {
            additional_args = function()
                return { '--fixed-strings' }
            end,
            layout_strategy = "vertical",
            layout_config = {
                vertical = {
                    width = 0.95,
                    height = 0.95,
                    preview_height = 0.6
                }
            }
        },
        find_files = {
            additional_args = function()
                return { '--fixed-strings' }
            end,
            layout_strategy = "vertical",
            layout_config = {
                vertical = {
                    width = 0.95,
                    height = 0.95,
                    preview_height = 0.6
                }
            }
        },
        git_files = {
            additional_args = function()
                return { '--fixed-strings' }
            end,
            layout_strategy = "vertical",
            layout_config = {
                vertical = {
                    width = 0.95,
                    height = 0.95,
                    preview_height = 0.6
                }
            }
        }
    },
    extensions = {
        themes = {
            layout_strategy = "vertical",
            layout_config = {
                vertical = {
                    width = 0.8,
                    height = 0.95,
                    preview_height = 0.6
                }
            },
            enable_previewer = true,
            enable_live_preview = true,
        }
    },
    defaults = {
        mappings = {
            i = { ["<c-t>"] = open_with_trouble },
            n = { ["<c-t>"] = open_with_trouble },
        },
    },
})

local builtin = require('telescope.builtin')
local entry_display = require('telescope.pickers.entry_display')
local from_entry = require('telescope.from_entry')

-- Cache for YAML titles to avoid re-parsing files
local title_cache = {}

-- Parse YAML frontmatter to extract title
local function extract_yaml_title(filepath)
    -- Check cache first
    if title_cache[filepath] then
        return title_cache[filepath]
    end

    local file = io.open(filepath, 'r')
    if not file then
        return nil
    end

    local in_frontmatter = false
    local title = nil
    local line_count = 0

    for line in file:lines() do
        line_count = line_count + 1

        -- Only check first 50 lines for performance
        if line_count > 50 then
            break
        end

        if line_count == 1 and line:match('^---$') then
            in_frontmatter = true
        elseif in_frontmatter and line:match('^---$') then
            break
        elseif in_frontmatter then
            -- Match title: "value" or title: value
            local match = line:match('^title:%s*["\']?(.+)["\']?$')
            if match then
                title = match:gsub('["\']$', '') -- Remove trailing quotes
                break
            end
        end
    end

    file:close()

    -- Cache the result
    title_cache[filepath] = title
    return title
end

-- Helper function to detect if current buffer is in a zk vault
local function get_vault_root()
    local current_file = vim.fn.expand('%:p')
    if current_file == '' then
        return nil
    end

    local ok, zk_util = pcall(require, 'zk.util')
    if not ok then
        return nil
    end

    return zk_util.notebook_root(current_file)
end

-- Custom entry maker for find_files that shows YAML titles
local function make_entry_with_title(opts)
    local make_entry = require('telescope.make_entry')
    local default_maker = make_entry.gen_from_file(opts)

    return function(line)
        local entry = default_maker(line)
        if not entry then
            return nil
        end

        local title = extract_yaml_title(entry.path)

        if title then
            local displayer = entry_display.create({
                separator = ' ',
                items = {
                    { width = 50 },
                    { remaining = true },
                },
            })

            entry.display = function(ent)
                return displayer({
                    title,
                    { ent.filename, 'TelescopeResultsComment' },
                })
            end

            entry.ordinal = title .. ' ' .. entry.filename
        end

        return entry
    end
end

-- Custom entry maker for live_grep that shows YAML titles
local function make_grep_entry_with_title(opts)
    local make_entry = require('telescope.make_entry')
    local default_maker = make_entry.gen_from_vimgrep(opts)

    return function(line)
        local entry = default_maker(line)
        if not entry then
            return nil
        end

        -- Convert relative filename to absolute path for title extraction
        local cwd = opts.cwd or vim.loop.cwd()
        local absolute_path = entry.filename
        if not vim.startswith(absolute_path, '/') then
            absolute_path = cwd .. '/' .. entry.filename
        end

        local title = extract_yaml_title(absolute_path)

        if title then
            local display_filename = title
            local displayer = entry_display.create({
                separator = ' ',
                items = {
                    { width = 40 },
                    { width = 6 },
                    { remaining = true },
                },
            })

            entry.display = function(ent)
                return displayer({
                    display_filename,
                    { ent.lnum .. ':' .. ent.col, 'TelescopeResultsLineNr' },
                    ent.text,
                })
            end

            entry.ordinal = title .. ' ' .. entry.text
        end

        return entry
    end
end

-- Vault-aware wrapper for find_files
local function vault_aware_find_files()
    local vault_root = get_vault_root()
    local opts = {}

    if vault_root then
        opts.cwd = vault_root
        opts.prompt_title = 'Find Files [vault]'
        opts.entry_maker = make_entry_with_title(opts)
    end

    builtin.find_files(opts)
end

-- Vault-aware wrapper for live_grep
local function vault_aware_live_grep()
    local vault_root = get_vault_root()
    local opts = {}

    if vault_root then
        opts.cwd = vault_root
        opts.prompt_title = 'Live Grep [vault]'
        opts.entry_maker = make_grep_entry_with_title(opts)
    end

    builtin.live_grep(opts)
end

-- Vault-aware wrapper for git_files
local function vault_aware_git_files()
    local vault_root = get_vault_root()
    local opts = {}

    if vault_root then
        opts.cwd = vault_root
        opts.prompt_title = 'Git Files [vault]'
    end

    builtin.git_files(opts)
end

-- Vault-aware wrapper for buffers
local function vault_aware_buffers()
    local vault_root = get_vault_root()
    local opts = {}

    if vault_root then
        opts.cwd = vault_root
        opts.prompt_title = 'Buffers [vault]'
    end

    builtin.buffers(opts)
end
-- Vault-aware keymaps (auto-scope to vault when buffer is in vault)
vim.keymap.set('n', '<leader>pf', vault_aware_find_files, { desc = 'Search files' })
vim.keymap.set('n', '<leader>pc', builtin.commands, { desc = 'Search commands' })
vim.keymap.set('n', '<leader>pb', vault_aware_buffers, { desc = 'Search buffers' })
vim.keymap.set('n', '<leader>ps', vault_aware_live_grep, { desc = 'Search in files' })
vim.keymap.set('n', '<C-p>', vault_aware_git_files, { desc = 'Search git files' })

-- Export functions for use in other configs (like zk.lua)
return {
    make_entry_with_title = make_entry_with_title,
    make_grep_entry_with_title = make_grep_entry_with_title,
    extract_yaml_title = extract_yaml_title,
}
