local use_prettier = { 'prettier', 'prettierd', stop_after_first = true }

local function use_frontend()
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
      javascript = use_frontend,
      typescript = use_frontend,
      typescriptreact = use_frontend,
      astro = use_frontend,
      markdown = use_frontend,
      mdx = use_frontend,
      json = use_frontend,
      yaml = use_prettier,
      css = use_frontend,
      vue = use_frontend,
    },
  },
}
