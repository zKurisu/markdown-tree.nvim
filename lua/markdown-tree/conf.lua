#! /usr/bin/lua
--
-- conf.lua
-- 2024-01-16
--
--
local BUF_NAME = 'Markdown Title'
local SEP_STR = ' -- '

local function get_buf_name()
  return BUF_NAME
end

local function get_separator()
  return { str = SEP_STR, len = string.len(SEP_STR) }
end

return {
  get_buf_name = get_buf_name,
  get_separator = get_separator
}
