return {
  {
    'SmiteshP/nvim-navic',
    dependencies = { 'neovim/nvim-lspconfig' },
    opts = false,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      winbar = {
        lualine_c = { { 'navic', color_correction = nil, navic_opts = nil } },
      },
    },
  },
}
