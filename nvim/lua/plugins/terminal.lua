return {
  'akinsho/toggleterm.nvim',
  config = function()
    local term = require 'toggleterm'
    term.setup()
    local nit = { 'n', 'i', 't' }
    vim.keymap.set(nit, '<D-T>', function()
      term.new(nil, nil, 'tab', 'term')
    end)
    vim.keymap.set(nit, '<D-/>', function()
      term.toggle(2000, nil, nil, 'float')
    end)
  end,
}
