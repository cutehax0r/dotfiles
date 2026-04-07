vim.pack.add({
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/rktjmp/paperplanes.nvim',
  'https://github.com/esmuellert/codediff.nvim',
})

require('gitsigns').setup({
  signcolumn = false,
  current_line_blame = false,
})

require('paperplanes').setup({
  register = '+',
  provider = 'gist',
  provider_options = {
    command = 'gh',
  },
  notifier = vim.notify or print,
})

require('codediff').setup({
  diff = {
    disable_inlay_hints = true,
    max_computation_time_ms = 5000,
  },
})

local function get_root_branch()
  local remotes = vim.fn.system('git remote 2>/dev/null')
  if vim.trim(remotes) == '' then
    return nil
  end

  local result = vim.fn.system('git rev-parse --abbrev-ref origin/HEAD 2>/dev/null | sed "s/origin\\///"')
  result = vim.trim(result)
  if result ~= '' and not result:match('^fatal') then
    return result
  end

  local common_branches = { 'main', 'master', 'trunk', 'develop' }
  for _, branch in ipairs(common_branches) do
    local check = vim.fn.system('git rev-parse --verify --quiet ' .. branch .. ' 2>/dev/null')
    if vim.v.shell_error == 0 then
      return branch
    end
  end

  return nil
end

vim.keymap.set({ 'n', 'v' }, '<leader>gs', '<cmd>Gitsigns toggle_signs<cr>', { desc = 'Git: toggle showing git changes in the sign column' })
vim.keymap.set({ 'n', 'v' }, '<leader>gb', '<cmd>Gitsigns blame_line<cr>', { desc = 'Git: blame the current line' })
vim.keymap.set({ 'n', 'v' }, '<leader>gB', '<cmd>Gitsigns blame<cr>', { desc = 'Git: blame the the buffer' })
vim.keymap.set({ 'n', 'v' }, ']g', '<cmd>Gitsigns next_hunk<cr>', { desc = 'Git: next hunk' })
vim.keymap.set({ 'n', 'v' }, '[g', '<cmd>Gitsigns prev_hunk<cr>', { desc = 'Git: previous hunk' })
vim.keymap.set({ 'n', 'v' }, '<leader>gg', '<cmd>PP<cr>', { desc = 'Git Gist: create a github gist with the current buffer and put the link on the clipboard' })
vim.keymap.set({ 'v' }, '<leader>gg', "<cmd>'<,'>PP<cr>", { desc = 'Git Gist: create a github gist with the selection and open it in the browser' })
vim.keymap.set({ 'n', 'v' }, '<leader>gd', '<cmd>CodeDiff file HEAD<cr>', { desc = 'Git: Diff file with last commit (HEAD)' })
vim.keymap.set({ 'n', 'v' }, '<leader>gD', '<cmd>CodeDiff HEAD<cr>', { desc = 'Git: Diff branch with last commit (HEAD)' })
vim.keymap.set({ 'n', 'v' }, '<leader>gm', function()
  local root = get_root_branch()
  if root then
    vim.cmd('CodeDiff file ' .. root .. '...')
  else
    vim.notify('No root branch found (no origin or default branches)', vim.log.levels.WARN)
  end
end, { desc = 'Git: Diff file with root branch (PR-style)' })
vim.keymap.set({ 'n', 'v' }, '<leader>gM', function()
  local root = get_root_branch()
  if root then
    vim.cmd('CodeDiff ' .. root .. '...')
  else
    vim.notify('No root branch found (no origin or default branches)', vim.log.levels.WARN)
  end
end, { desc = 'Git: Diff branch files with root branch (PR-style)' })