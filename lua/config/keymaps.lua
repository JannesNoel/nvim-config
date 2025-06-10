-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set({ "i", "s" }, "<C-l>", function()
    local ls = require("luasnip")
    if ls.choice_active() then
        ls.change_choice(1)
    end
end, { silent = true, noremap = true })
