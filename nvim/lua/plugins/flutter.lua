return {
  'nvim-flutter/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim', -- optional for vim.ui.select
  },
  config = {
    debugger = {
      enabled = true,
      exception_breakpoints = true,
      evaluate_to_string_in_debug_views = true,
    },
    flutter_path = '/Users/zhufu/flutter/bin/flutter',
    lsp = {
      settings = {
        lineLength = 120,
      },
    },
  },
}
