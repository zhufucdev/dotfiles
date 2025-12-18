local function get_groups()
  return vim.iter(string.gmatch(vim.o.guifont, '(.*):h(%d+)')):totable()[1]
end

vim.keymap.set('n', '<D-=>', function()
  if vim.g.neovide then
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1
  else
    local groups = get_groups()
    vim.o.guifont = groups[1] .. ':h' .. groups[2] + 1
  end
end)

vim.keymap.set('n', '<D-->', function()
  if vim.g.neovide then
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1
  else
    local groups = get_groups()
    vim.o.guifont = groups[1] .. ':h' .. groups[2] - 1
  end
end)
