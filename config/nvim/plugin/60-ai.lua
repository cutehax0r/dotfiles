vim.pack.add({
  'https://github.com/coder/claudecode.nvim',
  'https://github.com/zbirenbaum/copilot.lua',
})

require('claudecode').setup()

require('copilot').setup({
  panel = { enabled = false },
  nes = { enabled = false },
  suggestion = {
    enabled = true,
    auto_trigger = false,
    debounce = 100,
    trigger_on_accept = true,
    keymap = {
      accept = '<C-space>',
      accept_line = '<C-S-space>',
      next = '<C-n>',
      prev = '<C-p>',
      dismiss = '<C-Escape>',
    },
  },
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuOpen',
  callback = function()
    vim.b.copilot_suggestion_hidden = true
  end,
})
vim.api.nvim_create_autocmd('User', {
  pattern = 'BlinkCmpMenuClose',
  callback = function()
    vim.b.copilot_suggestion_hidden = false
  end,
})

vim.keymap.set({ 'n', 'v' }, '<leader>aa', '<cmd>ClaudeCode<cr>', { desc = 'AI Chat: Toggle Claude Code' })
vim.keymap.set({ 'n', 'v' }, '<leader>ac', '<cmd>Copilot suggestion toggle_auto_trigger<cr>', { desc = 'Copilot: toggle suggestions' })
