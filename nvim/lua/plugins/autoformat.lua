local use_prettier = { 'prettierd', 'prettier', stop_after_first = true }

local function use_fontend()
  if vim.fn.filereadable 'eslint.config.js' == 1 or vim.fn.filereadable 'eslint.config.mjs' == 1 then
    return { 'eslint_d' }
  end
  return use_prettier
end

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
      javascript = use_fontend,
      typescript = use_fontend,
      typescriptreact = use_fontend,
      astro = use_fontend,
      markdown = use_fontend,
      json = use_fontend,
      yaml = use_prettier,
      css = use_fontend,
      vue = use_fontend,
    },
  },
}
