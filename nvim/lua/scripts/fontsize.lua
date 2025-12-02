local function get_groups()
  return vim.iter(string.gmatch(vim.o.guifont, '(.*):h(%d+)')):totable()[1]
end

vim.keymap.set('n', '<D-=>', function()
  local groups = get_groups()
  vim.o.guifont = groups[1] .. ':h' .. groups[2] + 1
end)

vim.keymap.set('n', '<D-->', function ()
  local groups = get_groups()
  vim.o.guifont = groups[1] .. ':h' .. groups[2] - 1
end)
