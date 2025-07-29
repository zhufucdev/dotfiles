return {
  'smoka7/hop.nvim',
  config = function()
    local hop = require 'hop'
    hop.setup {
      keys = 'etovxqpdygfblzhckisuran',
    }
    vim.keymap.set({ 'i', 'n', 't' }, '<D-:>', hop.hint_char1)
  end,
}
