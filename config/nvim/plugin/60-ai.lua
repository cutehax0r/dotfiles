vim.pack.add({
  'https://github.com/NickvanDyke/opencode.nvim',
  'https://github.com/zbirenbaum/copilot.lua',
})

local opencode_cmd = 'opencode --port'
---@type snacks.terminal.Opts
local opencode_terminal_opts = {
  win = {
    position = 'right',
    enter = false,
  },
}

---@type opencode.Opts
vim.g.opencode_opts = {
  server = {
    start = function()
      require('snacks.terminal').open(opencode_cmd, opencode_terminal_opts)
    end,
  },
}

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

vim.keymap.set({ 'n', 'v' }, '<leader>aa', function()
  require('snacks.terminal').toggle(opencode_cmd, opencode_terminal_opts)
end, { desc = 'AI Chat: Toggle OpenCode' })
vim.keymap.set({ 'n', 'v' }, '<leader>ac', '<cmd>Copilot suggestion toggle_auto_trigger<cr>', { desc = 'Copilot: toggle suggestions' })