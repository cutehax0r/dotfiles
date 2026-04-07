vim.pack.add({
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/igorlfs/nvim-dap-view',
  'https://github.com/theHamsta/nvim-dap-virtual-text',
})

local dap = require('dap')

dap.configurations.ruby = {
  {
    type = 'ruby',
    name = 'Executable',
    request = 'attach',
    port = 12345,
    localfs = true,
    program = function()
      local program = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/exe/', 'file')
      return { 'bundle', 'exec', program }
    end,
  },
  {
    type = 'ruby',
    name = 'Executable with arguments',
    request = 'attach',
    port = 12345,
    localfs = true,
    program = function()
      local program = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/exe/', 'file')
      local args = vim.fn.input('Arguments: ')
      local command = { 'bundle', 'exec' }
      command = vim.list_extend(command, { program })
      args = vim.split(args, ' ')
      return vim.list_extend(command, args)
    end,
  },
}

dap.adapters.ruby = function(callback, config)
  local args = { '--open', '--port=${port}', '-c', '--' }
  local final = vim.list_extend(args, config.program)
  callback {
    type = 'server',
    port = '${port}',
    executable = {
      command = 'rdbg',
      args = final,
    },
  }
end

dap.configurations.go = {
  {
    type = 'delve',
    name = 'Debug',
    request = 'launch',
    program = '${file}',
  },
  {
    type = 'delve',
    name = 'Debug test',
    request = 'launch',
    mode = 'test',
    program = '${file}',
  },
  {
    type = 'delve',
    name = 'Debug test (go.mod)',
    request = 'launch',
    mode = 'test',
    program = './${relativeFileDirname}',
  },
}

dap.adapters.delve = function(callback, config)
  if config.mode == 'remote' and config.request == 'attach' then
    callback({
      type = 'server',
      host = config.host or '127.0.0.1',
      port = config.port or '38697',
    })
  else
    callback({
      type = 'server',
      port = '${port}',
      executable = {
        command = 'dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output=dap' },
        detached = vim.fn.has('win32') == 0,
      },
    })
  end
end

require('nvim-dap-virtual-text').setup({
  enabled = true,
  enabled_commands = true,
  commented = false,
  only_first_definition = true,
  clear_on_continue = false,
  all_frames = false,
  virt_lines = false,
  virt_text_pos = 'inline',
})

vim.keymap.set({ 'n', 'v' }, '<leader>dd', '<cmd>DapViewToggle<CR>', { desc = 'Debugger: toggle the debugger UI' })
vim.keymap.set({ 'n', 'v' }, '<leader>dt', '<cmd>DapTerminate<CR>', { desc = 'Debugger: terminate debugger' })
vim.keymap.set({ 'n', 'v' }, '<leader>db', '<cmd>DapToggleBreakpoint<CR>', { desc = 'Debugger: toggle breakpoint' })
vim.keymap.set({ 'n', 'v' }, '<leader>dc', '<cmd>DapContinue<CR>', { desc = 'Debugger: continue' })
vim.keymap.set({ 'n', 'v' }, '<leader>do', '<cmd>DapStepOver<CR>', { desc = 'Debugger: step over' })
vim.keymap.set({ 'n', 'v' }, '<leader>di', '<cmd>DapStepInto<CR>', { desc = 'Debugger: step into' })
vim.keymap.set({ 'n', 'v' }, '<leader>du', '<cmd>DapStepOut<CR>', { desc = 'Debugger: step up (out)' })
vim.keymap.set({ 'n', 'v' }, '<leader>de', '<cmd>DapToggleRepl<CR>', { desc = 'Debugger: toggle REPL' })
vim.keymap.set({ 'n', 'v' }, '<leader>dr', function() require('dap').run_to_cursor() end, { desc = 'Debugger: run to cursor' })
vim.keymap.set({ 'n', 'v' }, '<leader>dsu', function() require('dap').up() end, { desc = 'Debugger: stack Trace Up' })
vim.keymap.set({ 'n', 'v' }, '<leader>dsd', function() require('dap').down() end, { desc = 'Debugger: stack Trace Down' })