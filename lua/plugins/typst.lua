return {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    build = "cargo fetch --locked",
    opts = {
        open_cmd = "firefox %s",
    },
    init = function()
        vim.filetype.add({
            extension = { typ = "typst" },
        })
    end,
}
