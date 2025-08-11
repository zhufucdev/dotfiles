return {
  'ahmedkhalf/project.nvim',
  dependencies = { 'nvim-telescope/telescope.nvim' },
  config = function()
    require('project_nvim').setup {
      manual_mode = true,
      scope_chdir = 'tab',
    }
    vim.keymap.set('', '<D-O>', '<cmd>Telescope projects<CR>')
  end,
}
