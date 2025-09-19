vim.keymap.set('n', '<leader>c', function()
  local path = vim.fn.expand '%:p'
  vim.fn.setreg('+', path)
end, {
  desc = '<C>opy path of current buffer',
})

vim.keymap.set('n', '<leader>p', function()
  local buf = vim.api.nvim_create_buf(false, true)
  local path = vim.fn.expand '%:p'
  vim.api.nvim_buf_set_lines(buf, 0, 0, true, { path })
  local current_window = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(current_window);
  vim.api.nvim_open_win(buf, true, {
    relative = 'win',
    width = math.max(string.len(path), math.floor(vim.api.nvim_win_get_width(current_window) * 0.8)),
    height = 5,
    anchor = 'NW',
    bufpos = cursor,
    style = 'minimal',
    title = 'path reveal',
  })
end, {
  desc = 'Reveal path of current buffer',
})
