#! /usr/bin/lua
--
-- conf.lua
-- 2024-01-16
--
--
local BUF_NAME = 'Markdown Title'

local function get_buf_name()
  return BUF_NAME
end

return {
  get_buf_name = get_buf_name
}

