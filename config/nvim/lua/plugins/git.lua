-- Tools for interacting with git and github

-- Displays git diff status in the sign column and blaming on lines.
-- https://github.com/lewis6991/gitsigns.nvim
local gitsigns = {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
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

-- Git diff view that is a little more robust than the default `vimdiff`. Inspired by vscode it has
-- different highlights for line vs character level changes,
-- -- https://github.com/esmuellert/vscode-diff.nvim?tab=readme-ov-file
-- the 'next' branch is a pre-release version that includes 3-way merge and conflict resolution
-- improvements. It may be buggy.
-- https://github.com/esmuellert/vscode-diff.nvim/issues/97
-- git config --global merge.tool vscode-diff
-- git config --global mergetool.vscode-diff.cmd 'nvim "$MERGED" -c "CodeDiff merge \"$MERGED\""'

-- Helper function to detect the default/root branch
local function get_root_branch()
  -- Check if we have any remotes configured
  local remotes = vim.fn.system("git remote 2>/dev/null")
  if vim.trim(remotes) == "" then
    -- No remotes - this is a local-only repo
    return nil
  end

  -- Try to get the default branch from origin/HEAD
  local result = vim.fn.system("git rev-parse --abbrev-ref origin/HEAD 2>/dev/null | sed 's/origin\\///'")
  result = vim.trim(result)
  if result ~= "" and not result:match("^fatal") then
    return result
  end

  -- Fallback: check for common branch names
  local common_branches = { "main", "master", "trunk", "develop" }
  for _, branch in ipairs(common_branches) do
    local check = vim.fn.system("git rev-parse --verify --quiet " .. branch .. " 2>/dev/null")
    if vim.v.shell_error == 0 then
      return branch
    end
  end

  -- No root branch found
  return nil
end

local codediff = {
  "esmuellert/vscode-diff.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  branch = "next",
  cmd = "CodeDiff",
  keys = {
    -- maybe this should be gd = menu, and then gdf = codediff file, etc?
    { "<leader>gd", "<cmd>CodeDiff file HEAD<cr>", mode = { "n", "v" }, desc = "Git: Diff file with last commit (HEAD)" },
    { "<leader>gD", "<cmd>CodeDiff HEAD<cr>", mode = { "n", "v" }, desc = "Git: Diff branch with last commit (HEAD)" },
    { "<leader>gm", function()
      local root = get_root_branch()
      if root then
        vim.cmd("CodeDiff file " .. root .. "...")
      else
        vim.notify("No root branch found (no origin or default branches)", vim.log.levels.WARN)
      end
    end, mode = { "n", "v" }, desc = "Git: Diff file with root branch (PR-style)" },
    { "<leader>gM", function()
      local root = get_root_branch()
      if root then
        vim.cmd("CodeDiff " .. root .. "...")
      else
        vim.notify("No root branch found (no origin or default branches)", vim.log.levels.WARN)
      end
    end, mode = { "n", "v" }, desc = "Git: Diff branch files with root branch (PR-style)" },
  },
  config = function()
    require("vscode-diff").setup({
      diff = {
        disable_inlay_hints = true,
        max_computation_time_ms = 5000,
      },
    })
  end,
}

return { gitsigns, paperplanes, codediff }
