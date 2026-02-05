return { -- Autocompletion
  'hrsh7th/nvim-cmp',
  dependencies = {
    {
      'folke/lazydev.nvim',
      ft = 'lua',
    },
    {
      'supermaven-inc/supermaven-nvim',
      opts = {
        disable_inline_completion = true,
        disable_keymaps = true,
        log_level = 'off',
      },
    },
    {
      'Dynge/gitmoji.nvim',
      opts = {
        completion = {
          complete_as = 'text',
          append_space = true,
        },
      },
    },
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip',
    'onsails/lspkind.nvim',
  },
  config = function()
    local cmp = require 'cmp'
    local lspkind = require 'lspkind'
    cmp.setup {
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm { select = false }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      },
      sources = cmp.config.sources {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'supermaven' },
        { name = '99' },
        { name = 'lazydev', group_index = 0 },
        { name = 'gitmoji' },
      },
      formatting = {
        format = lspkind.cmp_format {
          mode = 'symbol',
          maxwidth = {
            -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            -- can also be a function to dynamically calculate max width such as
            -- menu = function() return math.floor(0.45 * vim.o.columns) end,
            menu = 50, -- leading text (labelDetails)
            abbr = 50, -- actual suggestion item
          },
          ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
          show_labelDetails = true,
          symbol_map = { Supermaven = '󰧑' },
        },
      },
    }
  end,
}
