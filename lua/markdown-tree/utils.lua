#! /usr/bin/lua
--
-- utils.lua
-- 
-- 2024-01-15
--
--
local conf = require('plugin.lib.conf')
local get_buf_name = conf.get_buf_name

local function line_diff(str1, str2)
  local line_count1 = select(2, str1:gsub("\n", ""))
  local line_count2 = select(2, str2:gsub("\n", ""))
  return line_count1 - line_count2
end

local function escape_special_char(str)
  local special_char = {
    '%', '(', ')', '-', '.', '^',
    '$', '[', ']', '*', '+', '?'
  }

  for _, char in pairs(special_char) do
    if char ~= '%' then
      str = str:gsub("%"..char, "%%"..char)
    else
      str = str:gsub("%"..char, "%%%"..char)
    end
  end

  return str
end

local function read_file()
  local dir = vim.fn.system("pwd")
  local ab_file_name = ""
  local file_name = vim.fn.getreg('%')

  if file_name:match("^/home") then
    ab_file_name = file_name
  else
    ab_file_name = dir:gsub("\n", "/") .. vim.fn.getreg('%')
  end

  local fh = assert(io.open(ab_file_name), "Can not open "..ab_file_name)

  local f_content = {}
  f_content.content = fh:read("*a")
  f_content.file = vim.fn.getreg('%')
  fh:close()

  return f_content
end

local function line_num_finder(titles)
  local f_content = read_file()
  local line_count = 0
  local lines = {}
  local titles_with_line_nr = {}

  for line in f_content.content:gmatch("[^\n]*\n?") do
    table.insert(lines, line)
  end

  for _, title in pairs(titles) do
    local slice_begin = 1
    for _, line in pairs(lines) do
      line_count  = line_count + 1
      slice_begin = slice_begin + 1
      if line:match(escape_special_char(title.title)) then
        table.insert(titles_with_line_nr, {title = title.title, line_nr = line_count, len = title.len})
        if #lines > slice_begin then
          lines = {unpack(lines, slice_begin)}
        end
        slice_begin = 1
        break
      end
    end
  end
  return titles_with_line_nr
end

local function get_buf()
  local BUF_NAME = get_buf_name()
  local regex = '.*'..BUF_NAME..'$'

  for _, win in pairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_name = vim.api.nvim_buf_get_name(buf)

    if string.match(buf_name, regex) ~= nil then return buf end
  end

  return nil
end

local function get_win()
  local BUF_NAME = get_buf_name()
  local regex = '.*'..BUF_NAME..'$'

  for _, win in pairs(vim.api.nvim_list_wins()) do
    local buf_name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))

    if string.match(buf_name, regex) ~= nil then return win end
  end

  return nil
end

return {
  read_file = read_file,
  line_num_finder = line_num_finder,
  get_buf = get_buf,
  escape_special_char = escape_special_char
}
