vim.pack.add({
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/igorlfs/nvim-dap-view',
  'https://github.com/theHamsta/nvim-dap-virtual-text',
})

local dap = require('dap')

-- rdbg (debug gem) is launched by nvim-dap under a free port and attached to. `-n` makes it run
-- until the first breakpoint instead of stopping on line 1. Uses `bundle exec rdbg` so the
-- project's own `debug` gem version is used.
local function rdbg_adapter(callback, config)
  local args = { 'exec', 'rdbg', '-n', '--open', '--port', '${port}', '-c', '--' }
  vim.list_extend(args, config.command)
  callback({
    type = 'server',
    host = '127.0.0.1',
    port = '${port}',
    executable = { command = 'bundle', args = args },
  })
end

local function prompt_args()
  local input = vim.fn.input('Arguments: ')
  return input == '' and {} or vim.split(input, ' ', { trimempty = true })
end

dap.adapters.ruby = rdbg_adapter

dap.configurations.ruby = {
  {
    type = 'ruby', name = 'Run current file', request = 'attach', localfs = true,
    command = function() return { 'ruby', vim.fn.expand('%:p') } end,
  },
  {
    type = 'ruby', name = 'Minitest: current file', request = 'attach', localfs = true,
    command = function() return { 'ruby', '-Itest', '-Ilib', vim.fn.expand('%:p') } end,
  },
  {
    type = 'ruby', name = 'RSpec: current file', request = 'attach', localfs = true,
    command = function() return { 'rspec', vim.fn.expand('%:p') } end,
  },
  {
    type = 'ruby', name = 'Executable (exe/...)', request = 'attach', localfs = true,
    command = function()
      return { vim.fn.input('Executable: ', vim.fn.getcwd() .. '/exe/', 'file') }
    end,
  },
  {
    type = 'ruby', name = 'Executable with arguments', request = 'attach', localfs = true,
    command = function()
      local cmd = { vim.fn.input('Executable: ', vim.fn.getcwd() .. '/exe/', 'file') }
      return vim.list_extend(cmd, prompt_args())
    end,
  },
}

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
vim.keymap.set({ 'n', 'v' }, '<leader>D', '<cmd>DapViewToggle<CR>', { desc = 'Debugger: toggle the debugger UI' })
