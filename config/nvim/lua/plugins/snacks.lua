-- Vim snacks includes a number of minimal but well integrated options to improve the UI

-- bigfile: https://github.com/folke/snacks.nvim/blob/main/docs/bigfile.md
-- Prevents loading of LSP, Treesitter, etc. on very large files to improve performance
local bigfile = {
  enabled = true,
  size = 0.5 * 1024 * 1024, -- 500kb = big file,
}

-- enable image rendering in markdown files and stuff
-- https://github.com/folke/snacks.nvim/blob/main/docs/image.md
local image = {
  enabled = true,
  force = false,
  doc = {
    enabled = true,
    inline = false,
    float = true, -- used only if inline = false
    max_width = 40,
    max_height = 20,
  },
  cache = vim.fn.stdpath("cache") .. "/snacks/image",
}

-- indent: https://github.com/folke/snacks.nvim/blob/main/docs/indent.md
-- highlights text indentation evel
local indent =  {
  enabled = true,
}

-- input: https://github.com/folke/snacks.nvim/blob/main/docs/input.md
-- improvements to vim.ui.input(). You still need something else to improve the command/search/etc
-- interfaces. 
local input = {
  enabled = true,
}

-- notifier: https://github.com/folke/snacks.nvim/blob/main/docs/notifier.md
-- A nicer handler for notifications
local notifier = {
  enabled = true,
  style = "compact",
}

-- picker: https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
-- general picker. opening files, searching lsp results, choosing buffers, etc
local picker = {
  enabled = true,
  sources = {
    explorer = {
      layout = {
        layout = {
          position = "right",
        },
      },
    },
  },
}

-- terminal: mostly used for external tools that want to run terminal programs
-- https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md
local terminal = {
  enabled = true,
}

-- quickfile: https://github.com/folke/snacks.nvim/blob/main/docs/quickfile.md
-- When opening a file from the command line `nvim foo.txt` render it asap before plugins load
local quickfile = {
  enabled = true,
}

-- statuscolumn: https://github.com/folke/snacks.nvim/blob/main/docs/statuscolumn.md
-- customizes the display of the status column
local statuscolumn = {
  enabled = true,
}

-- dashboard: https://github.com/folke/snacks.nvim/blob/main/docs/dashboard.md
-- pretty default start page
local dashboard = {
  enabled = true,
  sections = {
    { section = "header" },
    { section = "keys", gap = 1, padding = 1 },
  },
  preset = {
    keys = {
      { icon = " ", key = "n", desc = "New", action = ":ene | startinsert" },
      { icon = " ", key = "o", desc = "Open", action = ":lua Snacks.dashboard.pick('files')" },
      { icon = "󰒲 ", key = "u", desc = "Update", action = ":Lazy sync", enabled = package.loaded.lazy ~= nil },
      { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
      { icon = " ", key = "q", desc = "Quit", action = ":qa" },
    },
    header = [[
__   ___ 
\ \ / / |
 \ V /| |
  \_/ |_|
    ]],
  },
}

-- Dims text 'out of scope'
-- https://github.com/folke/snacks.nvim/blob/main/docs/dim.md
local dim = {
  enabled = true,
}

-- focus on a single file
-- https://github.com/folke/snacks.nvim/blob/main/docs/zen.md
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
      width = 0, -- full width
    },
  },
  center = true,
  show = {
    statusline = false,
  },
  win = {
    style = "zen",
    backdrop = { transparent = false, },
  },
  on_open = function(_) end,
  on_close = function(_) end,
}

-- git browse
-- https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md
local gitbrowse = {
  enabled = true,
}

-- Aggregates all of the individual moduels into a single big one.
-- https://github.com/folke/snacks.nvim/blob/main/README.md
local snacks = {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  keys = {
    { "<leader><leader>", function() Snacks.picker.files() end, mode = { "n", "v" }, desc = "Open a file with fuzzy searching path" },
    { "<leader>b", function() Snacks.picker.buffers() end, mode = { "n", "v" }, desc = "Open a buffer in the current window" },
    -- needs to enter the window
    { "<C-r>", function()
        local cmd_text = vim.fn.getcmdline()
        Snacks.picker.command_history({ confirm = "cmd", pattern = cmd_text })
    end, mode = { "c" }, desc = "Select a command that was previously run with current input" },
    { "<leader>/", function() Snacks.picker.grep() end, mode = { "n", "v" }, desc = "Open a file by fuzzy searching for its content" },
    { "<leader>?", function() Snacks.picker.lines() end, mode = { "n", "v" }, desc = "Search the lines in the current file" },
    { "<leader>k", function() Snacks.picker.keymaps({ layout = { preset = "select"} }) end, mode = { "n", "v" }, desc = "Search keymaps for an action" },
    { "<leader>l", function() Snacks.picker.explorer() end, mode = { "n", "v" }, desc = "Open file explorer" },
    { "<leader><s-bs>", function() Snacks.bufdelete() end, mode = { "n", "v" }, desc = "Delete bufer (not window)" },
    { "<leader><del>", function() Snacks.bufdelete() end, mode = { "n", "v" }, desc = "Delete bufer (not window)" },
    { "<leader>n", function() Snacks.notifier.show_history() end, mode = { "n", "v" }, desc = "Show the notification history" },
    { "z=", function() Snacks.picker.spelling() end, mode = { "n", "v" }, desc = "Show spelling suggestions" },
    { "<leader>u", function() Snacks.picker.undo() end, mode = { "n", "v" }, desc = "Undo history" },
    { "<leader>s", function() Snacks.picker.lsp_workspace_symbols() end, mode = { "n", "v" }, desc = "Search workspace symbols" },
    { "<leader>S", function() Snacks.picker.lsp_symbols() end, mode = { "n", "v" }, desc = "Search document symbols" },
    { "<leader>r", function() Snacks.picker.lsp_references() end, mode = { "n", "v" }, desc = "Show references to symbol" },
    { "<leader>E", function() Snacks.picker.diagnostics() end, mode = { "n", "v" }, desc = "Show diagnostic errors list" },
    { "<leader>@", function() Snacks.picker.registers() end, mode = { "n", "v" }, desc = "Show the content of registers, allow yank to clipboard" },
    { "<leader>z", function() Snacks.zen.zen() end, mode = { "n", "v" }, desc = "Focus on this window: 120 columns, no distractions enabled." },
    { "<leader><cr>", function() Snacks.zen.zoom() end, mode = { "n", "v" }, desc = "Zoom this window to fill the terminal." },
    { "gd", function() Snacks.picker.lsp_definitions() end, mode = { "n", "v" }, desc = "Go to definition" },
    { "<leader>gl", function() Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false }) end, mode = { "n", "v" }, desc = "Git Link: copy github.com link to current file" },
    { "<leader>gL", function() Snacks.gitbrowse({ notify = false }) end, mode = { "n", "v" }, desc = "Git link: open current file on github.com in browser" },
    -- git_log ??, -- changes to the repo
    -- git_log_file -- changes to the file
    -- git_diff -- changes in the branch
    -- git signs show commit(?)
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        _G.dd = function(...) Snacks.debug.inspect(...) end
        _G.bt = function() Snacks.debug.backtrace() end
        if vim.fn.has("nvim-0.11") == 1 then
          vim._print = function(_, ...)
            dd(...)
          end
        else
          vim.print = _G.dd
        end
      end,
    })
  end,
  opts = {
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
  },
}

return { snacks }
