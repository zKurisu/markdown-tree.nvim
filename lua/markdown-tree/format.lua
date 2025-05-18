#! /usr/bin/lua
--
-- format.lua
-- Define highlight groups and highlight the buffer
-- 2024-01-14
--
--

local api = vim.api

local HIGHLIGHT_GROUPS

if vim.bo.filetype == 'markdown' then
    HIGHLIGHT_GROUPS = {
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
elseif vim.bo.filetype == 'typst' then
    HIGHLIGHT_GROUPS = {
        ['^=%s+']         = { name = 'FirstLevel'  , len = 1 },
        ['^==%s+']        = { name = 'SecondLevel' , len = 2 },
        ['^===%s+']       = { name = 'ThirdLevel'  , len = 3 },
        ['^====%s+']      = { name = 'FourthLevel' , len = 4 },
        ['^=====%s+']     = { name = 'FifthLevel'  , len = 5 },
        ['^======%s+']    = { name = 'SixthLevel'  , len = 6 },
        ['^=======%s+']   = { name = 'SeventhLevel', len = 7 },
        ['^========%s+']  = { name = 'EighthLevel' , len = 8 },
        ['^=========%s+'] = { name = 'NinthLevel'  , len = 9 },
    }
elseif vim.bo.filetype == 'tex' then
    HIGHLIGHT_GROUPS = {
        ['^\\section']            = { name = 'FirstLevel'  , len = 8 },
        ['^\\subsection']         = { name = 'SecondLevel' , len = 11 },
        ['^\\subsubsection']      = { name = 'ThirdLevel'  , len = 14 },
    }
end


local function highlight_one_title(buffer, line_nr, title)
  local function highlight(group, line, from, to)
    api.nvim_buf_add_highlight(buffer, -1, group, line, from, to)
  end
  local text_start = 0
  for regex, hg in pairs(HIGHLIGHT_GROUPS) do
    if title.title:match(regex) then
      highlight("MarkdownTitle"..hg.name, line_nr, text_start, text_start+hg.len)
      highlight("Comment", line_nr, title.len, -1)
      break
    end
  end
end

local function highlight_title(buffer, titles)
  for i, title in pairs(titles) do
    local line_nr = i - 1
    highlight_one_title(buffer, line_nr, title)
  end
end

return {
  highlight_one_title = highlight_one_title,
  highlight = highlight_title,
  HIGHLIGHT_GROUPS = HIGHLIGHT_GROUPS
}
