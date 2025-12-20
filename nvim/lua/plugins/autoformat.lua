local use_prettier = { 'prettierd', 'prettier', stop_after_first = true }

return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      'L',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = 'Linter',
    },
  },
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Conform can also run multiple formatters sequentially
      python = { 'isort', 'black', stop_after_first = false },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      javascript = use_prettier,
      typescript = { 'eslint_d', 'prettierd', stop_after_first = true },
      typescriptreact = { 'eslint_d', 'prettierd', stop_after_first = true },
      markdown = use_prettier,
      json = use_prettier,
      yaml = use_prettier,
      css = use_prettier,
      vue = { 'eslint_d' },
    },
  },
}
