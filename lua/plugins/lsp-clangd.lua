return {
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            clangd = {
                cmd = {
                    "clangd",
                    "--clang-tidy",
                    "--completion-style=detailed",
                    "--header-insertion=never",
                },
                -- Optional: force capabilities, init options etc.
            },
        },
    },
}
