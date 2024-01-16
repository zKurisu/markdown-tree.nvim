# A Markdown Title Explorer for Neovim Written In Lua
Target:

    ✅️ Basic title list with line number
    ✅️ Basic list highlight
    ✅️ Basic jump
       Title editting
       Real time update
       Custom color setting
       Custom keybinding

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
For now, it's bind to `mh` to show titles.

# Screenshots
Waiting for finish.
