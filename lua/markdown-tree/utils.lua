#! /usr/bin/lua
--
-- utils.lua
-- 
-- 2024-01-15
--
--

local function line_diff(str1, str2)
  local line_count1 = select(2, str1:gsub("\n", ""))
  local line_count2 = select(2, str2:gsub("\n", ""))
  return line_count1 - line_count2
end

local function read_file()
  local dir = vim.fn.system("pwd")
  local ab_file_name = dir:gsub("\n", "/") .. vim.fn.getreg('%')

  local fh = assert(io.open(ab_file_name), "Can not open ${ab_file_name}")
  local f_content = fh:read("*a")
  fh:close()

  return f_content
end

local function line_num_finder(titles)
  local f_content = read_file()
  local line_count = 0
  local lines = {}
  local titles_with_line_nr = {}

  for line in f_content:gmatch("[^\n]*\n?") do
    table.insert(lines, line)
  end

  for _, title in pairs(titles) do
    local slice_begin = 1
    for _, line in pairs(lines) do
      line_count  = line_count + 1
      slice_begin = slice_begin + 1
      if line:match(title.title) then
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


return {
  read_file = read_file,
  line_num_finder = line_num_finder
}
