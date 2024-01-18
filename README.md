# A Markdown Title Explorer for Neovim Written In Lua
Target:

    ✅️ Basic title list with line number
    ✅️ Basic list highlight
    ✅️ Basic jump
       Title editting
       Real time update
    ✅️ Custom color setting
    ✅️ Custom keybinding

![](https://raw.githubusercontent.com/zkurisu/markdown-tree.nvim/master/.github/markdown-tree.png)
# Installation
## Plugin Managers
### packer
```lua
use {
    'zkurisu/markdown-tree.nvim',
}
```

### vim-plug
```vim
Plug 'zkurisu/markdown-tree.nvim'
```

### lazy
```lua
return {
  "zkurisu/markdown-tree.nvim",
  version = "*",
  lazy = false,
  config = function()
    require("markdown-tree")
  end,
}
```

# Basic usage
## Keymapping
You can run `:lua MarkdownTree()` or set a keybinding for it, `vim.keymap.set("n", "mh", "<cmd>lua MarkdownTree()<CR>")`, you can add it to `init.vim`/`init.lua`.

For lazy, you could add it to config:
```lua
return {
  "zkurisu/markdown-tree.nvim",
  version = "*",
  lazy = false,
  config = function()
    require("markdown-tree")
    vim.keymap.set("n", "mh", "<cmd>lua MarkdownTree()<CR>")
  end,
}
```

## Jump to line
Press `<CR>` (Enter) to jump.

## Custom highlighting
Nine highlight group is created in advanced:

    highlight MarkdownTitleFirstLevel   gui=bold guifg=#f7768e
    highlight MarkdownTitleSecondLevel  gui=bold guifg=#a9b1d6
    highlight MarkdownTitleThirdLevel   gui=bold guifg=#9ece6a
    highlight MarkdownTitleFourthLevel  gui=NONE guifg=#bb9af7
    highlight MarkdownTitleFifthLevel   gui=NONE guifg=#e0af68
    highlight MarkdownTitleSixthLevel   gui=NONE guifg=#7dcfff
    highlight MarkdownTitleSeventhLevel gui=NONE guifg=#7aa2f7
    highlight MarkdownTitleEighthLevel  gui=NONE guifg=#e0af68
    highlight MarkdownTitleNinthLevel   gui=NONE guifg=#2947b1

You could customize by redefine the highlight groups, adding:
```vim
highlight MarkdownTitlexxxxxLevel gui=xxx guifg=xxx
```
to `init.vim`.

Or adding:
```lua
vim.cmd("highlight MarkdownTitlexxxxxLevel gui=xxx guifg=xxx")
```
to `init.lua`.

Or change lazy config to:
```lua
return {
  "zkurisu/markdown-tree.nvim",
  version = "*",
  lazy = false,
  config = function()
    require("markdown-tree")
    vim.cmd("highlight MarkdownTitlexxxxxLevel gui=xxx guifg=xxx")
  end,
}
```


# Screenshots
Waiting for finish.
