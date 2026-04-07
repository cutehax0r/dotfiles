vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'neotest-golang' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then vim.cmd.packadd('neotest-golang') end
      vim.system({ 'go', 'install', 'gotest.tools/gotestsum@latest' }):wait()
    end
  end
})

vim.pack.add({
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/antoinemadec/FixCursorHold.nvim',
  'https://github.com/volodya-lombrozo/neotest-ruby-minitest',
  'https://github.com/fredrikaverpil/neotest-golang',
})

require('neotest').setup({
  adapters = {
    require('neotest-ruby-minitest')({ command = 'bundle exec ruby -Itest' }),
    require('neotest-golang')({}),
  },
  diagnostic = {
    enabled = false,
  },
})

vim.keymap.set({ 'n', 'v' }, '<leader>tt', '<cmd>Neotest summary<CR>', { desc = 'Toggle test summary panel' })
vim.keymap.set({ 'n', 'v' }, '<leader>tr', '<cmd>Neotest run<CR>', { desc = 'Run the nearest test' })
vim.keymap.set({ 'n', 'v' }, '<leader>tf', "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", { desc = 'Run the the current test file' })
vim.keymap.set({ 'n', 'v' }, '<leader>to', '<cmd>Neotest output<CR>', { desc = 'View the output for the current test' })
vim.keymap.set({ 'n', 'v' }, '<leader>tO', '<cmd>Neotest output-panel<CR>', { desc = 'Toggle the output panel for tests' })