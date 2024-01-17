#! /usr/bin/lua
--
-- colors.lua
-- Init the colorscheme
-- 2024-01-14
--
--

local cmd = vim.api.nvim_command -- Run vim command

local colors = {
  red = vim.g.terminal_color_1 or '#f7768e',
  green = vim.g.terminal_color_2 or '#9ece6a',
  yellow = vim.g.terminal_color_3 or '#e0af68',
  blue = vim.g.terminal_color_4 or '#7aa2f7',
  purple = vim.g.terminal_color_5 or 'bb9af7',
  cyan = vim.g.terminal_color_6 or '7dcfff',
  orange = vim.g.terminal_color_11 or '#e0af68',
  dark_red = vim.g.terminal_color_9 or '#f7768e',
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
