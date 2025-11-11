return {
  'amekusa/auto-input-switch.nvim',
  opts = {
    match = {
      enable = true,
      languages = {
        Zh = { enable = true, priority = 0 },
      },
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
