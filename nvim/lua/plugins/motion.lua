return {
  'smoka7/hop.nvim',
  keys = {
    { '<D-:>', '<cmd>HopChar1<CR>', mode = { 'n', 't', 'v', 'i' } },
  },
  config = function()
    local hop = require 'hop'
    hop.setup {
      keys = 'etovxqpdygfblzhckisuran',
    }
  end,
}
