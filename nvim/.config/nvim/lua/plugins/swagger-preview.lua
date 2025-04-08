-- must install swagger-ui-watcher with npm
-- `npm i -g swagger-ui-watcher`
return {
    "vinnymeller/swagger-preview.nvim",
    config = function ()
        require("config.swagger")
    end
}
