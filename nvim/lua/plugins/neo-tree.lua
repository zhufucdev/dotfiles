-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '<D-1>', ':Neotree reveal<CR>', silent = true },
    { '<D-2>', ':Neotree git_status<CR>', silent = true },
    { '<D-3>', ':Neotree buffers<CR>', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['<D-1>'] = 'close_window',
          ['<D-n>'] = 'add',
          ['<D-N>'] = 'add_directory',
        },
      },
      filtered_items = {
        visible = true,
      },
    },
  },
}
