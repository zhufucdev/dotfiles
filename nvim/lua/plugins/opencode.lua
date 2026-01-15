local opencode_version = 'v1.1.20'
local opencode_instances = {}

local function get_term(id)
  if opencode_instances[id] then
    return opencode_instances[id]
  end
  local Terminal = require('toggleterm.terminal').Terminal
  local new_instance = Terminal:new {
    cmd = 'nix run github:anomalyco/opencode/' .. opencode_version .. ' -- --port',
    direction = 'float',
    float_opts = {
      border = 'curved',
    },
    hidden = true,
  }
  opencode_instances[id] = new_instance
  return new_instance
end

return {
  'NickvanDyke/opencode.nvim',
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    -- Required for `snacks` provider.
    ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
    { 'folke/snacks.nvim', opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    local opencode = require 'opencode'
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      provider = {
        toggle = function()
          get_term(vim.fn.getcwd()):toggle()
        end,
        start = function()
          get_term(vim.fn.getcwd()):open()
        end,
        stop = function()
          get_term(vim.fn.getcwd()):shutdown()
        end,
      },
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    vim.keymap.set({ 'n', 'x' }, 'gop', function()
      opencode.ask('@this: ', { submit = true })
    end, { desc = '[G]oto [O]pencode [P]rompt' })
    vim.keymap.set({ 'n', 'x' }, 'goa', function()
      opencode.select()
    end, { desc = '[G]oto [O]pencode [A]ction' })
    vim.keymap.set({ 'n', 't' }, '<D-.>', function()
      opencode.toggle()
    end, { desc = 'Toggle OpenCode' })

    vim.keymap.set({ 'n', 'x' }, 'goA', function()
      return opencode.operator '@this '
    end, { expr = true, desc = '[G]oto [O]pencode [A]dd range' })
    vim.keymap.set('n', 'gol', function()
      return opencode.operator '@this ' .. '_'
    end, { expr = true, desc = '[G]oto [O]pencode Add [Line]' })

    vim.keymap.set('n', '<S-C-u>', function()
      opencode.command 'session.half.page.up'
    end, { desc = 'opencode half page up' })
    vim.keymap.set('n', '<S-C-d>', function()
      opencode.command 'session.half.page.down'
    end, { desc = 'opencode half page down' })
  end,
}
