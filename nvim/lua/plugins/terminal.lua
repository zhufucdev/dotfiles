return {
  'akinsho/toggleterm.nvim',
  config = function()
    local term = require('toggleterm')
    term.setup()
    local nit = { 'n', 'i', 't' }
    vim.keymap.set(nit, '<D-T>', function()
      term.new(1, nil, 'tab', 'term')
    end)
    vim.keymap.set(nit, '<D-/>', function ()
      vim.fn.execute('ToggleTerm size=40 direction=float')
    end)
  end,
}
