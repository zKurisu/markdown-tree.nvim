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

  api.nvim_command('botright '..list_width..'vnew | set nonumber norelativenumber')
  api.nvim_win_set_buf(0, buf)
  api.nvim_buf_set_lines(buf, 0, -1, false, disp_titles)
  api.nvim_buf_set_option(buf, 'modifiable', false)

  return {buf = buf, titles = titles, file = file}
end

local function fold_title() -- Fold the title under cursor

end

local function update_view()
  local buf = utils.get_buf()
  vim.api.nvim_buf_delete(buf, {})
  local tree = list_title()
  highlight.highlight(tree.buf, tree.titles)
end

function EditTitle(file) -- Edit the title
  -- Get the current line, split it to sentence and line number, sentence used as default value 
  -- of vim.ui.input(), line used to edit, both file and buf
  local line = vim.api.nvim_get_current_line()
  local title_content = string.gsub(line, " %-%- %d*$", "")
  local file_line_nr = string.gsub(line, "^(.-) %-%- ", "")
  local file_buf = utils.get_file_buf(file)

  vim.ui.input({
    prompt = "Edit the title",
    default = title_content
  }, function(input)
    vim.api.nvim_buf_set_lines(file_buf, tonumber(file_line_nr)-1, tonumber(file_line_nr), false, { input })
    vim.api.nvim_buf_call(file_buf, function()
      vim.cmd("w")
    end)

    update_view()
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

function MarkdownTree()
  local tree = list_title()
  highlight.highlight(tree.buf, tree.titles)
  vim.api.nvim_buf_set_keymap(tree.buf, "n", "<CR>", "<cmd>lua Jump2Title('"..tree.file.."')<CR>", {})
  vim.api.nvim_buf_set_keymap(tree.buf, "n", "e", "<cmd>lua EditTitle('"..tree.file.."')<CR>", {})
end
