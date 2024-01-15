#! /usr/bin/lua
--
-- colors.lua
-- Init the colorscheme
-- 2024-01-14
--
--

local cmd = vim.api.nvim_command -- Run vim command

local colors = {
  red = vim.g.terminal_color_1 or 'red',
  green = vim.g.terminal_color_2 or 'green',
  yellow = vim.g.terminal_color_3 or 'yellow',
  blue = vim.g.terminal_color_4 or 'blue',
  purple = vim.g.terminal_color_5 or 'purple',
  cyan = vim.g.terminal_color_6 or 'cyan',
  orange = vim.g.terminal_color_11 or 'orange',
  dark_red = vim.g.terminal_color_9 or 'dark red',
  lua = '#2947b1'
}

local HIGHLIGHTS = {
  FirstLevel = { gui = 'bold', fg = colors.red },
  SecondLevel = { fg = colors.orange },
  ThirdLevel = { gui = 'bold', fg = colors.green },
  FourthLevel = { fg = colors.purple },
  FifthLevel = { fg = colors.yellow },
  SixthLevel = { fg = colors.cyan },
  SeventhLevel = { fg = colors.blue },
  EighthLevel = { fg = colors.dark_red },
  NinthLevel = { fg = colors.lua }
}

local function init_colors()
  for hgname, hgargs in pairs(HIGHLIGHTS) do
    local gui = hgargs.gui or 'NONE'
    cmd('highlight MarkdownTitle'..hgname..' gui='..gui..' guifg='..hgargs.fg)
  end
end

return {
  init_colors = init_colors
}
