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

local function list_title() -- list all title
  local meta = utils.get_meta()
  local titles = meta.titles
  local file = meta.file
  local pre_win = utils.get_win()

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
  if pre_win ~= nil then vim.api.nvim_win_close(pre_win, true) end
  api.nvim_buf_set_name(buf, BUF_NAME)

  for opt, val in pairs(options) do
    api.nvim_buf_set_option(buf, opt, val)
  end

  api.nvim_command('botright '..list_width..'vnew | set nonumber norelativenumber | set nowrap')
  api.nvim_win_set_buf(0, buf)
  api.nvim_buf_set_lines(buf, 0, -1, false, disp_titles)
  api.nvim_buf_set_option(buf, 'modifiable', false)

  return {buf = buf, titles = titles, file = file}
end

local function fold_title() -- Fold the title under cursor

end

function EditTitle(file) -- Edit the title
  -- Get the current line, split it to sentence and line number, sentence used as default value 
  -- of vim.ui.input(), line used to edit, both file and buf
  local line = vim.api.nvim_get_current_line()
  local title_content = string.gsub(line, " %-%- %d*$", "")
  local file_line_nr = string.gsub(line, "^(.-) %-%- ", "")
  local file_buf = utils.get_file_buf(file)

  local tree_buf = utils.get_buf()
  local tree_line_nr = vim.api.nvim_win_get_cursor(0)[1]

  vim.ui.input({
    prompt = "Edit the title",
    default = title_content
  }, function(input)
    local new_title = input.." -- "..file_line_nr
    local title = { title = new_title, len = input:len() }

    vim.api.nvim_buf_set_lines(file_buf, tonumber(file_line_nr)-1, tonumber(file_line_nr), false, { input })
    vim.api.nvim_buf_call(file_buf, function()
      vim.cmd("w")
    end)

    vim.api.nvim_buf_set_option(tree_buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(tree_buf, tree_line_nr-1, tree_line_nr, false, { title.title })
    highlight.highlight_one_title(tree_buf, tree_line_nr-1, title)
    vim.api.nvim_buf_set_option(tree_buf, 'modifiable', false)
  end)
end

function Jump2Title(file) -- Jump to the title under cursor
  local line = vim.api.nvim_get_current_line()
  local line_nr = line:gsub("(.-)%-%- ", "")
  local regex = '.*'..utils.escape_special_char(file)..'$'

  for _, win in pairs(vim.api.nvim_list_wins()) do
    local buf_name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    if string.match(buf_name, regex) then
      vim.api.nvim_set_current_win(win)
      vim.api.nvim_win_set_cursor(win, {tonumber(line_nr), 0})
      break
    end
  end
end

function UpdateLevel(level, titles)
  local buf = utils.get_buf()
  local selected_titles = {}
  local highlight_titles = {}
  local regex = "^#"
  if vim.bo.filetype == 'markdown' then
    regex = "^#"
  elseif vim.bo.filetype == 'typst' then
    regex = "^="
  end

  if level ~= 0 then
    for re, hg in pairs(highlight.HIGHLIGHT_GROUPS) do
      if hg.len == level then
        regex = re
      end
    end
  end

  for _, title in pairs(titles) do
    if title.title:match(regex) then
      table.insert(selected_titles, string.format("%s -- %s", title.title, title.line_nr))
      table.insert(highlight_titles, title)
    end
  end
  api.nvim_buf_set_option(buf, 'modifiable', true)
  api.nvim_buf_set_lines(buf, 0, -1, false, selected_titles)
  highlight.highlight(buf, highlight_titles)
end

function MarkdownTree()
  Markdowntree = list_title()
  highlight.highlight(Markdowntree.buf, Markdowntree.titles)
  vim.api.nvim_buf_set_keymap(Markdowntree.buf, "n", "<CR>", "<cmd>lua Jump2Title('"..Markdowntree.file.."')<CR>", {})
  vim.api.nvim_buf_set_keymap(Markdowntree.buf, "n", "e", "<cmd>lua EditTitle('"..Markdowntree.file.."')<CR>", {})

  vim.api.nvim_buf_set_keymap(Markdowntree.buf, "n", "0", "<cmd>lua UpdateLevel(0, Markdowntree.titles)<CR>", {})
  vim.api.nvim_buf_set_keymap(Markdowntree.buf, "n", "1", "<cmd>lua UpdateLevel(1, Markdowntree.titles)<CR>", {})
  vim.api.nvim_buf_set_keymap(Markdowntree.buf, "n", "2", "<cmd>lua UpdateLevel(2, Markdowntree.titles)<CR>", {})
  vim.api.nvim_buf_set_keymap(Markdowntree.buf, "n", "3", "<cmd>lua UpdateLevel(3, Markdowntree.titles)<CR>", {})
  vim.api.nvim_buf_set_keymap(Markdowntree.buf, "n", "4", "<cmd>lua UpdateLevel(4, Markdowntree.titles)<CR>", {})
  vim.api.nvim_buf_set_keymap(Markdowntree.buf, "n", "5", "<cmd>lua UpdateLevel(5, Markdowntree.titles)<CR>", {})
  vim.api.nvim_buf_set_keymap(Markdowntree.buf, "n", "6", "<cmd>lua UpdateLevel(6, Markdowntree.titles)<CR>", {})
  vim.api.nvim_buf_set_keymap(Markdowntree.buf, "n", "7", "<cmd>lua UpdateLevel(7, Markdowntree.titles)<CR>", {})
  vim.api.nvim_buf_set_keymap(Markdowntree.buf, "n", "8", "<cmd>lua UpdateLevel(8, Markdowntree.titles)<CR>", {})
  vim.api.nvim_buf_set_keymap(Markdowntree.buf, "n", "9", "<cmd>lua UpdateLevel(9, Markdowntree.titles)<CR>", {})
end
