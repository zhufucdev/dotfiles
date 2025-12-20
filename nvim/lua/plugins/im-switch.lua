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
            cmd_get = 'macism',
            cmd_set = 'macism %s'
        }
    }
  },
}
