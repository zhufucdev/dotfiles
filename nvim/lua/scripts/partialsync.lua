local IPC_FILE = vim.fs.joinpath(vim.fn.stdpath 'state', 'partial_sync.tmp')

vim.api.nvim_create_user_command('PartialSyncSend', function(opts)
  local id = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(id)
  local line_range = { vim.fn.getpos('v')[2], vim.fn.getpos('.')[2] }
  if line_range[1] > line_range[2] then
    line_range = { line_range[2], line_range[1] }
  end
  vim.fn.writefile(line_range[1] .. ':' .. line_range[2] .. '\n', IPC_FILE, 'S')
  vim.fn.writefile(vim.api.nvim_buf_get_lines(id, 0, -1, false), IPC_FILE, 'as')
end, { desc = 'Partial sync setup', nargs = 0 })

vim.api.nvim_create_user_command('PartialSyncInsert', function(opts)
  if not vim.fn.filereadable(IPC_FILE) then
    vim.notify('Sync file is not created or not readable', vim.log.levels.ERROR)
    return
  end
  local ipc_lines = vim.fn.readfile(IPC_FILE)
  if #ipc_lines == 0 then
    vim.notify('Sync file is empty', vim.log.levels.ERROR)
  end
  local line_range = vim.tbl_map(tonumber, vim.split(ipc_lines[1], ':'))
  if #line_range ~= 2 then
    vim.notify('Invalid sync file', vim.log.levels.ERROR)
    return
  end

  local id = vim.api.nvim_get_current_buf()
  local source_lines = vim.fn.slice(ipc_lines, 1, #ipc_lines)
  local buffer_lines = vim.api.nvim_buf_get_lines(id, 0, -1, false)
  local function seek_line(from, to, step)
    for source_idx = from, to, step do
      for buf_idx = 1, #buffer_lines do
        if buffer_lines[buf_idx] == source_lines[source_idx] then
          return buf_idx
        end
      end
    end
    return 0
  end

  local insert_after = seek_line(line_range[1], 1, -1) -- seek to the start
  if insert_after == 0 then
    local seek_end = seek_line(line_range[2], #source_lines, 1) -- seek to the end
    if seek_end == 0 then
      insert_after = #buffer_lines
    else
      insert_after = seek_end - 1
    end
  end

  local inseration = vim.fn.slice(source_lines, line_range[1] - 1, line_range[2])
  buffer_lines = vim.fn.extend(buffer_lines, inseration, insert_after)
  vim.api.nvim_buf_set_lines(id, 0, -1, false, buffer_lines)
end, { desc = 'Partial receive and insert into current buffer', nargs = 0 })

vim.keymap.set({ 'n', 'v' }, '^', '<cmd>PartialSyncSend<CR><ESC>')
vim.keymap.set({ 'n', 'v' }, '<D-^>', '<cmd>PartialSyncInsert<CR><ESC>')
