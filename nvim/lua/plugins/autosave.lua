return {
  'Pocco81/auto-save.nvim',
  opts = {
    enabled = true,
    execution_message = {
      message = function() -- message to print on save
        return ('Saved at ' .. vim.fn.strftime '%H:%M:%S')
      end,
      dim = 0.18, -- dim the color of `message`
      cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
    },
    trigger_events = { 'InsertLeave' },
  },
}
