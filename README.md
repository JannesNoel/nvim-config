# Introduction

This repo contains my config of NeoVim, which is currently derived from
the LazyVim distribution of Vim.

Any changes to the Base behaviour of vim can be found in [/lua/config](/lua/config).
New Plugins and their configuration can be found in [/lua/plugins](/lua/plugins).

## Custom Snippets

The defined snippets can be found in the [/snippets](/snippets) folder.
Where a filename specifies the language for which the snippet should be set up.

Note: Some of the snippets that were used for the ps_os_2025 test are changed and
converted versions of Matti Fischbachs snippets, which can be found in
following [repo](https://github.com/jqyDee/ps_os_25s/tree/main/snippets).

| Language/File type | Snippet File |
|:---------|:-----------:|
| C        | [c.lua](/snippets/c.lua)|
| Makefile | [make.lua](/snippets/make.lua)|


Amendment after the test:
I didn't manage to finish the Snippet files (as you can see).
Also in the test I forgot to remove the unnecessary time related macros.
