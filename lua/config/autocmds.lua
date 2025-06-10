-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Reload snippets when changed
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.lua" },
    callback = function()
        local snippet_path = vim.fn.expand("%:p")
        if snippet_path:match("/snippets/") then
            -- Reload Lua snippets
            require("luasnip.loaders.from_lua").lazy_load()
            vim.notify("Reloaded LuaSnip snippets!", vim.log.levels.INFO)
        end
    end,
})
