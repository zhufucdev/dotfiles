return {
  'akinsho/toggleterm.nvim',
  config = function()
    vim.keymap.set('', '<D-T>', function()
      require('toggleterm').new(1, nil, 'tab', 'term')
    end)
  end,
}
