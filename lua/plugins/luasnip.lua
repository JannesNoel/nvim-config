return {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp", -- optional, safe to leave here
    config = function()
        local ls = require("luasnip")

        require("luasnip.loaders.from_lua").lazy_load({
            paths = { vim.fn.expand("~/.config/nvim/snippets") },
        })

        vim.keymap.set({ "i", "s" }, "<C-l>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end, { silent = true, noremap = true })
    end,
}
