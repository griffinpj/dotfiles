local M = {}

-- Cache environment variables to avoid repeated OS API calls
M.home = os.getenv('HOME')
M.user = os.getenv('USER')

-- Helper function to build paths relative to home directory
function M.home_path(subpath)
    return M.home .. '/' .. subpath
end

-- Helper function to build paths relative to user directory
function M.user_path(subpath)
    return '/Users/' .. M.user .. '/' .. subpath
end

return M