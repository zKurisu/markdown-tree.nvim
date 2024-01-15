#! /usr/bin/lua
--
-- markdown-tree.lua
-- function
-- 2024-01-13
--
--
local color = require("markdown-tree.colors")
local highlight = require("markdown-tree.format")
local utils = require("markdown-tree.utils")

local api = vim.api
local list_width = 40
local BUF_NAME = "Markdown Titles"
color.init_colors()

vim.keymap.set("n", "mh", "<cmd>lua MarkdownTree()<CR>")

local function get_titles()
  local regex = "^#" -- Begin with '#' is a title line, and not in code block
  local f_content = utils.read_file()

  local without_code_block = f_content:gsub("```(.-)```", "")
  local titles = {}
  for line in without_code_block:gmatch("[^\r\n]+") do
    if line:match(regex) then
      table.insert(titles, {title = line, len = line:len()})
    end
  end

  return utils.line_num_finder(titles)
end

local function list_title() -- list all title
  local titles = get_titles()
  local disp_titles = {}
  for _, title in pairs(titles) do
    table.insert(disp_titles, string.format("%s -- %s", title.title, title.line_nr))
  end

  local options = {
    bufhidden = 'wipe';
    buftype = 'nowrite';
    modifiable = true;
  }
  local buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_name(buf, BUF_NAME)

  for opt, val in pairs(options) do
    api.nvim_buf_set_option(buf, opt, val)
  end

  api.nvim_command('botright '..list_width..'vnew | set nonumber norelativenumber')
  api.nvim_win_set_buf(0, buf)
  api.nvim_buf_set_lines(buf, 0, -1, false, disp_titles)
  api.nvim_buf_set_option(buf, 'modifiable', false)

  return {buf = buf, titles = titles}
end

local function fold_title() -- Fold the title under cursor

end

local function jump2title() -- Jump to the title under cursor

end

local function edit_title() -- Edit the title

end

function MarkdownTree()
  local tree = list_title()
  highlight.highlight(tree.buf, tree.titles)
end
