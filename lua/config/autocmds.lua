-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Compile a typst file, when the .typ file is saved
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.typ",
    callback = function(args)
        local file = vim.fn.expand("%:p") -- absolute path to the file
        local dir = vim.fn.expand("%:p:h") -- directory of the file

        vim.fn.jobstart({ "typst", "compile", file }, {
            cwd = dir,
            on_exit = function(_, code)
                if code ~= 0 then
                    vim.notify("typst compile failed (exit " .. code .. ")", vim.log.levels.ERROR)
                end
            end,
        })
    end,
})
