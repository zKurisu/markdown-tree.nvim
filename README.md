# A Markdown Title Explorer for Neovim Written In Lua
Target:

    ✅️ Basic title list with line number
    ✅️ Basic list highlight
    ✅️ Basic jump
       Title editting
       Real time update
       Custom color setting
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

# Screenshots
Waiting for finish.
