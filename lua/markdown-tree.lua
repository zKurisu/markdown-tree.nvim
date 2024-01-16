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
local conf = require("markdown-tree.conf")

local api = vim.api
local list_width = 40
local BUF_NAME = conf.get_buf_name()
color.init_colors()

vim.keymap.set("n", "mh", "<cmd>lua MarkdownTree()<CR>")

local function get_meta()
  local regex = "^#" -- Begin with '#' is a title line, and not in code block
  local f_content = utils.read_file()

  local without_code_block = f_content.content:gsub("```(.-)```", "")
  local titles = {}
  for line in without_code_block:gmatch("[^\r\n]+") do
    if line:match(regex) then
      table.insert(titles, {title = line, len = line:len()})
    end
  end

  return { titles = utils.line_num_finder(titles), file = f_content.file }
end

local function list_title() -- list all title
  local meta = get_meta()
  local titles = meta.titles
  local file = meta.file

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

  return {buf = buf, titles = titles, file = file}
end

local function fold_title() -- Fold the title under cursor

end

local function edit_title() -- Edit the title

end

local function buf_close()

end

function Jump2Title(file) -- Jump to the title under cursor
  local line = vim.api.nvim_get_current_line()
  local line_nr = line:gsub("(.-)%-%- ", "")
  local regex = '.*'..utils.escape_special_char(file)..'$'

  for _, win in pairs(vim.api.nvim_list_wins()) do
    local buf_name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    if string.match(buf_name, regex) then
      vim.api.nvim_win_set_cursor(win, {tonumber(line_nr), 0})
      vim.api.nvim_set_current_win(win)
      break
    end
  end
end

function MarkdownTree()
  local tree = list_title()
  highlight.highlight(tree.buf, tree.titles)
  vim.api.nvim_buf_set_keymap(tree.buf, "n", "<CR>", "<cmd>lua Jump2Title('"..tree.file.."')<CR>", {})
end
