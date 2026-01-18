local function get_command_from_buf(buf)
  local commit_message = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  return "git commit -m '" .. table.concat(commit_message, '\n') .. "'"
end

-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local default_mode = { 'i', 'n', 't' }
return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
    },
    lazy = false,
    keys = {
      { '<D-1>', '<cmd>:Neotree reveal<CR>', silent = true, mode = default_mode },
      { '<D-2>', '<cmd>:Neotree git_status<CR>', silent = true, mode = default_mode },
      { '<D-3>', '<cmd>:Neotree buffers<CR>', silent = true, mode = default_mode },
    },
    opts = {
      clipboard = {
        sync = 'global',
      },
      window = {
        position = 'float',
      },
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
      git_status = {
        window = {
          mappings = {
            ['gc'] = function()
              vim.api.nvim_command 'CommitPad'
            end,
          },
        },
      },
    },
  },
  {
    'Sengoku11/commitpad.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = { 'CommitPad' },
    opts = {},
  },
}
