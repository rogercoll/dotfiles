-- See: https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html#org4e437d4
-- MODE
local modes = {
  ['n'] = 'NORMAL',
  ['no'] = 'NORMAL',
  ['v'] = 'VISUAL',
  ['V'] = 'VISUAL LINE',
  [''] = 'VISUAL BLOCK',
  ['s'] = 'SELECT',
  ['S'] = 'SELECT LINE',
  [''] = 'SELECT BLOCK',
  ['i'] = 'INSERT',
  ['ic'] = 'INSERT',
  ['R'] = 'REPLACE',
  ['Rv'] = 'VISUAL REPLACE',
  ['c'] = 'COMMAND',
  ['cv'] = 'VIM EX',
  ['ce'] = 'EX',
  ['r'] = 'PROMPT',
  ['rm'] = 'MOAR',
  ['r?'] = 'CONFIRM',
  ['!'] = 'SHELL',
  ['t'] = 'TERMINAL',
}

local function mode()
  local current_mode = vim.api.nvim_get_mode().mode
  return string.format(' %s ', modes[current_mode]):upper()
end

local function update_mode_colors()
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_color = '%#StatusLineAccent#'
  if current_mode == 'n' then
    mode_color = '%#StatuslineAccent#'
  elseif current_mode == 'i' or current_mode == 'ic' then
    mode_color = '%#StatuslineInsertAccent#'
  elseif current_mode == 'v' or current_mode == 'V' or current_mode == '' then
    mode_color = '%#StatuslineVisualAccent#'
  elseif current_mode == 'R' then
    mode_color = '%#StatuslineReplaceAccent#'
  elseif current_mode == 'c' then
    mode_color = '%#StatuslineCmdLineAccent#'
  elseif current_mode == 't' then
    mode_color = '%#StatuslineTerminalAccent#'
  end
  return mode_color
end

-- Git branch
local function git_branch()
  local branch = vim.fn.system "git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'"
  if string.len(branch) > 0 then
    return branch
  else
    return ':'
  end
end

local function filetype()
  return string.format(' %s ', vim.bo.filetype):upper()
end

local function filepath()
  local fpath = vim.fn.fnamemodify(vim.fn.expand '%', ':~:.:h')
  if fpath == '' or fpath == '.' then
    return ' '
  end
  return string.format(' %%<%s/', fpath)
end

local function filename()
  local fname = vim.fn.expand '%:t'
  if fname == '' then
    return ''
  end
  return fname .. ' '
end

local function lsp()
  local count = {}
  local levels = {
    errors = 'Error',
    warnings = 'Warn',
    info = 'Info',
    hints = 'Hint',
  }

  for k, level in pairs(levels) do
    count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  end

  local errors = ''
  local warnings = ''
  local hints = ''
  local info = ''

  if count['errors'] ~= 0 then
    errors = ' %#LspDiagnosticsSignError# ' .. count['errors']
  end
  if count['warnings'] ~= 0 then
    warnings = ' %#LspDiagnosticsSignWarning# ' .. count['warnings']
  end
  if count['hints'] ~= 0 then
    hints = ' %#LspDiagnosticsSignHint# ' .. count['hints']
  end
  if count['info'] ~= 0 then
    info = ' %#LspDiagnosticsSignInformation# ' .. count['info']
  end

  return errors .. warnings .. hints .. info
end

-- SET STATUSLINE
Statusline = {}

Statusline.active = function()
  local mode_str = string.format('%s%s', update_mode_colors(), mode())
  local branch_str = string.format('%s %s %s', '%#PmenuSel#', git_branch(), '%#LineNr#')
  local align_right = '%='
  local modified = ' %m'
  local percentage = ' %p%%'
  local linecol = ' %l:%c'
  return table.concat {
    '%#Statusline#',
    mode_str,
    branch_str,
    '%#Normal# ',
    '%=%#StatusLineExtra#',
    align_right,
    lsp(),
    modified,
    filepath(),
    filename(),
    percentage,
    linecol,
    '%#Normal#',
    filetype(),
  }
end

function Statusline.inactive()
  return ' %F'
end

function Statusline.short()
  return '%#StatusLineNC#   NvimTree'
end

vim.api.nvim_exec(
  [[
  augroup Statusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
  au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
  au WinEnter,BufEnter,FileType NvimTree setlocal statusline=%!v:lua.Statusline.short()
  augroup END
]],
  false
)
