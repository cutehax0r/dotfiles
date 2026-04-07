vim.pack.add({
  'https://github.com/folke/snacks.nvim',
})

local bigfile = {
  enabled = true,
  size = 0.5 * 1024 * 1024,
}

local image = {
  enabled = true,
  force = false,
  doc = {
    enabled = true,
    inline = false,
    float = true,
    max_width = 40,
    max_height = 20,
  },
  cache = vim.fn.stdpath('cache') .. '/snacks/image',
}

local indent = {
  enabled = true,
}

local input = {
  enabled = true,
}

local notifier = {
  enabled = true,
  style = 'compact',
  width = {
    min = 24,
    max = 0.3,
  },
  padding = false,
}

local picker = {
  enabled = true,
  sources = {
    explorer = {
      layout = {
        layout = {
          position = 'right',
        },
      },
    },
  },
  win = {
    input = {
      keys = {
        ['<C-.>'] = { 'toggle_hidden_ignored', mode = { 'n', 'i' } },
      },
    },
  },
  actions = {
    toggle_hidden_ignored = function(picker)
      picker:action('toggle_hidden')
      picker:action('toggle_ignored')
    end,
  },
}

local terminal = {
  enabled = true,
}

local quickfile = {
  enabled = true,
}

local statuscolumn = {
  enabled = true,
}

local dashboard = {
  enabled = true,
  sections = {
    { section = 'header' },
    { section = 'keys', gap = 1, padding = 1 },
  },
  preset = {
    keys = {
      { icon = '󰎙 ', key = 'n', desc = 'New', action = ':ene | startinsert' },
      { icon = '󰂆 ', key = 'o', desc = 'Open', action = ':lua Snacks.dashboard.pick("files")' },
      { icon = '󰒲 ', key = 'u', desc = 'Update', action = ':lua vim.pack.update()', enabled = package.loaded['vim.pack'] ~= nil },
      { icon = '󰣒 ', key = 'c', desc = 'Config', action = ':lua Snacks.dashboard.pick("files", {cwd = vim.fn.stdpath("config")})' },
      { icon = '󰍔 ', key = 'q', desc = 'Quit', action = ':qa' },
    },
    header = [[
 __   ___ 
 \ \ / / |
  \ V /| |
   \_/ |_|
     ]],
  },
}

local dim = {
  enabled = true,
}

local zen = {
  enabled = true,
  toggles = {
    dim = true,
    git_signs = false,
    diagnostics = false,
    inlay_hints = false,
  },
  zoom = {
    toggles = {},
    center = false,
    show = {
      statusline = true
    },
    win = {
      backdrop = false,
      width = 0,
    },
  },
  center = true,
  show = {
    statusline = false,
  },
  win = {
    style = 'zen',
    backdrop = { transparent = false },
  },
  on_open = function(_) end,
  on_close = function(_) end,
}

local gitbrowse = {
  enabled = true,
}

require('snacks').setup({
  gitbrowse = gitbrowse,
  dashboard = dashboard,
  dim = dim,
  bigfile = bigfile,
  indent = indent,
  input = input,
  notifier = notifier,
  picker = picker,
  quickfile = quickfile,
  statuscolumn = statuscolumn,
  terminal = terminal,
  image = image,
  zen = zen,
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    _G.dd = function(...) Snacks.debug.inspect(...) end
    _G.bt = function() Snacks.debug.backtrace() end
    if vim.fn.has('nvim-0.11') == 1 then
      vim._print = function(_, ...)
        dd(...)
      end
    else
      vim.print = _G.dd
    end
  end,
})

vim.keymap.set({ 'n', 'v' }, '<leader><leader>', function() Snacks.picker.files() end, { desc = 'Open a file with fuzzy searching path' })
vim.keymap.set({ 'n', 'v' }, '<leader>b', function() Snacks.picker.buffers() end, { desc = 'Open a buffer in the current window' })
vim.keymap.set('c', '<C-r>', function()
  local cmd_text = vim.fn.getcmdline()
  Snacks.picker.command_history({ confirm = 'cmd', pattern = cmd_text })
end, { desc = 'Select a command that was previously run with current input' })
vim.keymap.set({ 'n', 'v' }, '<leader>/', function() Snacks.picker.grep() end, { desc = 'Open a file by fuzzy searching for its content' })
vim.keymap.set({ 'n', 'v' }, '<leader>?', function() Snacks.picker.lines() end, { desc = 'Search the lines in the current file' })
vim.keymap.set({ 'n', 'v' }, '<leader>k', function() Snacks.picker.keymaps({ layout = { preset = 'select'} }) end, { desc = 'Search keymaps for an action' })
vim.keymap.set({ 'n', 'v' }, '<leader>l', function() Snacks.picker.explorer() end, { desc = 'Open file explorer' })
vim.keymap.set({ 'n', 'v' }, '<leader><s-bs>', function() Snacks.bufdelete() end, { desc = 'Delete bufer (not window)' })
vim.keymap.set({ 'n', 'v' }, '<leader><del>', function() Snacks.bufdelete() end, { desc = 'Delete bufer (not window)' })
vim.keymap.set({ 'n', 'v' }, '<leader>n', function() Snacks.notifier.show_history() end, { desc = 'Show the notification history' })
vim.keymap.set({ 'n', 'v' }, 'z=', function() Snacks.picker.spelling() end, { desc = 'Show spelling suggestions' })
vim.keymap.set({ 'n', 'v' }, '<leader>u', function() Snacks.picker.undo() end, { desc = 'Undo history' })
vim.keymap.set({ 'n', 'v' }, '<leader>s', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'Search workspace symbols' })
vim.keymap.set({ 'n', 'v' }, '<leader>S', function() Snacks.picker.lsp_symbols() end, { desc = 'Search document symbols' })
vim.keymap.set({ 'n', 'v' }, '<leader>r', function() Snacks.picker.lsp_references() end, { desc = 'Show references to symbol' })
vim.keymap.set({ 'n', 'v' }, '<leader>E', function() Snacks.picker.diagnostics() end, { desc = 'Show diagnostic errors list' })
vim.keymap.set({ 'n', 'v' }, '<leader>@', function() Snacks.picker.registers() end, { desc = 'Show the content of registers, allow yank to clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>z', function() Snacks.zen.zen() end, { desc = 'Focus on this window: 120 columns, no distractions enabled.' })
vim.keymap.set({ 'n', 'v' }, '<leader><cr>', function() Snacks.zen.zoom() end, { desc = 'Zoom this window to fill the terminal.' })
vim.keymap.set({ 'n', 'v' }, 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Go to definition' })
vim.keymap.set({ 'n', 'v' }, '<leader>gu', function() Snacks.gitbrowse({ open = function(url) vim.fn.setreg('+', url) end, notify = false }) end, { desc = 'Git Link: copy github.com link to current file' })
vim.keymap.set({ 'n', 'v' }, '<leader>gU', function() Snacks.gitbrowse({ notify = false }) end, { desc = 'Git link: open current file on github.com in browser' })
vim.keymap.set({ 'n', 'v' }, '<leader>gl', function() Snacks.picker.git_log_line() end, { desc = 'Git: Browse changes to the line' })
vim.keymap.set({ 'n', 'v' }, '<leader>gf', function() Snacks.picker.git_log_file() end, { desc = 'Git: Browse changes to the file' })
vim.keymap.set({ 'n', 'v' }, '<leader>gh', function() Snacks.picker.git_log() end, { desc = 'Git: Browse changes to the repository' })