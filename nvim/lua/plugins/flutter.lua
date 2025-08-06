return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim', -- optional for vim.ui.select
  },
  opts = {
    root_patterns = { 'pubspec.yaml' },
    fvm = true,
    debugger = {
      enabled = true,
      exception_breakpoints = true,
      evaluate_to_string_in_debug_views = true,
    },
    lsp = {
      settings = {
        lineLength = 120,
      },
    },
  },
}
