local function get_command_from_buf(buf)
  local commit_message = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  return "git commit -m '" .. table.concat(commit_message, '\n') .. "'"
end

-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local default_mode = { 'i', 'n', 't' }
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
            local buf = vim.api.nvim_create_buf(false, true)
            vim.keymap.set('n', '<CR>', function()
              local cmd = get_command_from_buf(buf)
              vim.fn.execute('term ' .. cmd)
            end, {
              buffer = buf,
            })
            vim.keymap.set('n', 'P', function()
              local cmd = get_command_from_buf(buf) .. ' && git push'
              vim.fn.execute('term ' .. cmd)
            end, {
              buffer = buf,
            })

            vim.api.nvim_set_option_value('filetype', 'gitcommit', { buf = buf })
            local parent_win = vim.api.nvim_get_current_win()
            local msg_win_id = vim.api.nvim_open_win(buf, true, {
              relative = 'win',
              width = 50,
              height = 10,
              anchor = 'SW',
              row = vim.api.nvim_win_get_height(parent_win),
              col = 0,
              style = 'minimal',
              title = 'commit message',
            })
            vim.fn.execute 'startinsert'
            vim.keymap.set('n', '<ESC>', function()
              vim.api.nvim_win_close(msg_win_id, false)
            end, { buffer = buf })
          end,
        },
      },
    },
  },
}
