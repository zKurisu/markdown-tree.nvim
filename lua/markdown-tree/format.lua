#! /usr/bin/lua
--
-- format.lua
-- Define highlight groups and highlight the buffer
-- 2024-01-14
--
--

local api = vim.api

local HIGHLIGHT_GROUPS = {
  ['^#%s+']         = { name = 'FirstLevel'  , len = 1 },
  ['^##%s+']        = { name = 'SecondLevel' , len = 2 },
  ['^###%s+']       = { name = 'ThirdLevel'  , len = 3 },
  ['^####%s+']      = { name = 'FourthLevel' , len = 4 },
  ['^#####%s+']     = { name = 'FifthLevel'  , len = 5 },
  ['^######%s+']    = { name = 'SixthLevel'  , len = 6 },
  ['^#######%s+']   = { name = 'SeventhLevel', len = 7 },
  ['^########%s+']  = { name = 'EighthLevel' , len = 8 },
  ['^#########%s+'] = { name = 'NinthLevel'  , len = 9 },
}

local function highlight_title(buffer, titles)
  local function highlight(group, line, from, to)
    api.nvim_buf_add_highlight(buffer, -1, group, line, from, to)
  end
  local text_start = 0
  for i, title in pairs(titles) do
    local line_nr = i - 1
    for regex, hg in pairs(HIGHLIGHT_GROUPS) do
      if title.title:match(regex) then
        highlight("MarkdownTitle"..hg.name, line_nr, text_start, text_start+hg.len)
        highlight("Comment", line_nr, title.len, -1)
        break
      end
    end
  end
end

return {
  highlight = highlight_title
}
