return {
  'petertriho/nvim-scrollbar',
  config = function()
    require('scrollbar.handlers.gitsigns').setup()
    require('scrollbar').setup()
  end,
}
