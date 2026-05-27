-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  {
    'mikavilpas/yazi.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', lazy = true },
    },
    lazy = false,
    keys = {
      { '<D-1>', '<cmd>Yazi<CR>', silent = true, mode = default_mode },
      { '<D-3>', '<cmd>Yazi cwd<CR>', silent = true, mode = default_mode },
    },
    ---@type YaziConfig | {}
    opts = {
      keymaps = {
        show_help = '?',
      },
      open_for_directories = false,
    },
    init = function()
      -- mark netrw as loaded so it's not loaded at all.
      vim.g.loaded_netrwPlugin = 1
    end,
  },
}
