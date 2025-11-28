return {
  'amekusa/auto-input-switch.nvim',
  opts = {
    match = {
      enable = false,
    },
    restore = {
      enable = true,
    },
    os_settings = {
        macos = {
            cmd_get = '/opt/homebrew/bin/macism',
            cmd_set = '/opt/homebrew/bin/macism %s'
        }
    }
  },
}
