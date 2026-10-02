vim.pack.add({
  'https://github.com/stevearc/overseer.nvim',
})

require('overseer').setup({
  templates = { 'builtin' },
  auto_detect_success_color = true,
  task_list = {
    default_detail = 1,
    max_width = { 100, 0.2 },
    min_width = { 40, 0.1 },
    direction = 'right',
    bindings = {
      ['?'] = 'ShowHelp',
      ['r'] = 'RunAction',
      ['<CR>'] = function() vim.cmd(':OverseerQuickAction restart') end,
      ['e'] = 'Edit',
      ['o'] = 'Open',
      ['-'] = 'OpenVsplit',
      ['|'] = 'OpenSplit',
      ['f'] = 'OpenFloat',
      ['p'] = 'TogglePreview',
      ['v'] = 'IncreaseDetail',
      ['V'] = 'DecreaseDetail',
      ['H'] = 'IncreaseAllDetail',
      ['L'] = 'DecreaseAllDetail',
      ['['] = 'DecreaseWidth',
      [']'] = 'IncreaseWidth',
      ['{'] = 'PrevTask',
      ['}'] = 'NextTask',
      ['<C-k>'] = 'ScrollOutputUp',
      ['<C-j>'] = 'ScrollOutputDown',
      ['q'] = 'Close',
    },
  },
  actions = {},
})

vim.keymap.set({ 'n', 'v' }, '<leader>j', '<cmd>OverseerRun<cr>', { desc = 'Overseer: create or run a task' })
vim.keymap.set({ 'n', 'v' }, '<leader>J', '<cmd>OverseerToggle<cr>', { desc = 'Overseer: toggle task list' })

-- Ruby task templates. Minitest is the default; rspec is picked when the project has a spec/ dir.
-- Bare minitest runs `ruby -Itest file` directly (rake test + `-n` filters is unreliable);
-- Rails projects use `bin/rails test`, which handles its own load path.
local function ruby_template(name, builder, condition)
  require('overseer').register_template({
    name = name,
    builder = builder,
    condition = condition,
  })
end

local function is_rails(dir)
  return vim.uv.fs_stat(dir .. '/bin/rails') ~= nil
end

ruby_template('ruby: test file', function()
  local file = vim.fn.expand('%:p')
  local cmd
  if vim.uv.fs_stat(vim.fn.getcwd() .. '/spec') and file:match('_spec%.rb$') then
    cmd = { 'bundle', 'exec', 'rspec', file }
  elseif is_rails(vim.fn.getcwd()) then
    cmd = { 'bin/rails', 'test', file }
  else
    cmd = { 'bundle', 'exec', 'ruby', '-Itest', '-Ilib', file }
  end
  return { cmd = cmd, components = { 'default' } }
end, { filetype = { 'ruby' } })

ruby_template('ruby: test suite', function()
  local cwd = vim.fn.getcwd()
  local cmd
  if vim.uv.fs_stat(cwd .. '/spec') then
    cmd = { 'bundle', 'exec', 'rspec' }
  elseif is_rails(cwd) then
    cmd = { 'bin/rails', 'test' }
  else
    cmd = { 'bundle', 'exec', 'rake', 'test' }
  end
  return { cmd = cmd, components = { 'default' } }
end, { dir = nil })

ruby_template('ruby: typecheck (sorbet)', function()
  return { cmd = { 'bundle', 'exec', 'srb', 'tc' }, components = { 'default' } }
end, { filetype = { 'ruby' } })

ruby_template('ruby: rubocop (autocorrect safe)', function()
  return { cmd = { 'bundle', 'exec', 'rubocop', '-a' }, components = { 'default' } }
end, { filetype = { 'ruby' } })
