return {
  'akinsho/toggleterm.nvim',
  config = function()
    vim.keymap.set({ 'n', 'i', 't' }, '<D-T>', function()
      require('toggleterm').new(1, nil, 'tab', 'term')
    end)
  end,
}
