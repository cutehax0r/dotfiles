-- Tools for interacting with git and github

-- Displays git diff status in the sign column and blaming on lines.
-- https://github.com/lewis6991/gitsigns.nvim
local gitsigns = {
  "lewis6991/gitsigns.nvim",
  cmd = "Gitsigns",
  keys = {
    { "<leader>gs", "<cmd>Gitsigns toggle_signs<cr>", mode = { "n", "v" }, desc = "Git: toggle showing git changes in the sign column" },
    { "<leader>gb", "<cmd>Gitsigns blame_line<cr>", mode = { "n", "v" }, desc = "Git: blame the current line" },
    { "<leader>gB", "<cmd>Gitsigns blame<cr>", mode = { "n", "v" }, desc = "Git: blame the the buffer" },
    { "]g", "<cmd>Gitsigns next_hunk<cr>", mode = { "n", "v" }, desc = "Git: next hunk" },
    { "[g", "<cmd>Gitsigns prev_hunk<cr>", mode = { "n", "v" }, desc = "Git: previous hunk" },
  },
  config = function()
    require("gitsigns").setup({
      signcolumn = false,
      current_line_blame = false,
    })
  end,
}

-- Generates "pastebins" or "gists". Takes text in your editor and puts it on the internet so you
-- can share the links with people without creating a repository.
-- https://github.com/rktjmp/paperplanes.nvim
local paperplanes = {
  "rktjmp/paperplanes.nvim",
  cmd = "PP",
  opts = {
    register = "+",
    provider = "gist",
    provider_options = {
      command = "gh",
    },
    notifier = vim.notify or print,
  },
  keys = {
    { "<leader>gg", "<cmd>PP<cr>", mode = { "n" }, desc = "Git Gist: create a github gist with the current buffer and put the link on the clipboard" },
    { "<leader>gg", "<cmd>'<,'>PP<cr>", mode = { "v" }, desc = "Git Gist: create a github gist with the selection and open it in the browser" },
  },
}

-- Shows what's changed in a source repository. Diff files side-by-side, browse history of changes, compare revisions, branches, or handle merging.
-- https://github.com/sindrets/diffview.nvim
local diffview = {
  "sindrets/diffview.nvim",
  keys = {
    { "<leader>gd", function() if next(require("diffview.lib").views) == nil then vim.cmd("DiffviewOpen") else vim.cmd("DiffviewClose") end end, mode = { "n" }, desc = "Git diff the current buffer" },
  },
}

return { gitsigns, paperplanes, diffview }
