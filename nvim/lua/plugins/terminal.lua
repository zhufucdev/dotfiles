local nit = { 'n', 'i', 't' }
return {
  'akinsho/toggleterm.nvim',
  keys = {
    {
      '<D-T>',
      function()
        require('toggleterm').new(nil, nil, 'tab', 'term')
      end,
      mode = nit,
    },
    {
      '<D-/>',
      function()
        require('toggleterm').toggle(2000, nil, nil, 'float')
      end,
      mode = nit,
    },
  },
  config = function()
    local term = require 'toggleterm'
    term.setup()
  end,
}
