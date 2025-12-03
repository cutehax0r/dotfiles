-- Open Code integration
-- https://github.com/NickvanDyke/opencode.nvim
-- This may be a better alternative if you want something using neovim natively
-- https://github.com/sudo-tee/opencode.nvim
local opencode = {
 "NickvanDyke/opencode.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  command = { "Opencode", "OpencodePrompt" },
  keys = {
    { "<leader>aa", function() require("opencode").toggle() end, mode = { "n", "v" }, desc = "AI Chat: Toggle OpenCode" },
  },
  config = function()
    --  setup custom opencode opts
    --  vim.g.opencode_opts = { ... }
  end,
}

-- A lua interface for working with Copilot
-- https://github.com/zbirenbaum/copilot.lua
local copilot = {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  -- event = "InsertEnter",
  command = { "Copilot" },
  keys = {
    { "<leader>ac", "<CMD>Copilot suggestion toggle_auto_trigger<CR>", mode = { "n", "v" }, desc = "Copilot: toggle suggestions" },
  },
  config = function()
    require("copilot").setup({
      panel = { enabled = false, },
      nes = { enabled = false, },
      suggestion = {
        enabled = true,
        auto_trigger = false,
        debounce = 100,
        trigger_on_accept = true,
        keymap = {
          accept = "<C-space>",
          accept_line = "<C-S-space>",
          next = "<C-n>",
          prev = "<C-p>",
          dismiss = "<C-Escape>",
        },
      },
    })
    -- Hide copilot suggestion when Blink menu is open
    vim.api.nvim_create_autocmd("User", {
      pattern = "BlinkCmpMenuOpen",
      callback = function()
        vim.b.copilot_suggestion_hidden = true
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "BlinkCmpMenuClose",
      callback = function()
        vim.b.copilot_suggestion_hidden = false
      end,
    })
  end,
}

return { opencode, copilot }
