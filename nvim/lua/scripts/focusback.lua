-- focus back to the previous window
vim.keymap.set({ 'n', 'i', 'v', 't' }, '<C-`>', ':wincmd p<CR>')

-- focus back to the first modifiable window
vim.keymap.set({ 'n', 'i', 'v', 't' }, '<C-1>', function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_is_valid(win) and vim.api.nvim_get_option_value('modifiable', { buf = vim.api.nvim_win_get_buf(win) }) then
      vim.api.nvim_set_current_win(win)
      break
    end
  end
end)
