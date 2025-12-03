-- Task Runner with Overseer
-- https://github.com/stevearc/overseer.nvim
local overseer = {
  "stevearc/overseer.nvim",
  version = "v1.6.0",
  keys = {
    { "<leader>j", "<cmd>OverseerRun<cr>",    mode = { "n", "v" }, desc = "Overseer: create or run a task" },
    { "<leader>J", "<cmd>OverseerToggle<cr>", mode = { "n", "v" }, desc = "Overseer: toggle task list" },
  },
  opts = {
    templates = { "builtin" },
    auto_detect_success_color = true,
    task_list = {
      default_detail = 1,
      max_width = { 100, 0.2 },
      min_width = { 40, 0.1 },
      direction = "right",
      bindings = {
        ["?"] = "ShowHelp",
        ["r"] = "RunAction",
        ["<CR>"] = function() vim.cmd(":OverseerQuickAction restart") end,
        ["e"] = "Edit",
        ["o"] = "Open",
        ["-"] = "OpenVsplit",
        ["|"] = "OpenSplit",
        ["f"] = "OpenFloat",
        ["p"] = "TogglePreview",
        ["v"] = "IncreaseDetail",
        ["V"] = "DecreaseDetail",
        ["H"] = "IncreaseAllDetail",
        ["L"] = "DecreaseAllDetail",
        ["["] = "DecreaseWidth",
        ["]"] = "IncreaseWidth",
        ["{"] = "PrevTask",
        ["}"] = "NextTask",
        ["<C-k>"] = "ScrollOutputUp",
        ["<C-j>"] = "ScrollOutputDown",
        ["q"] = "Close",
      },
    },
    actions = {},
  },
}

return { overseer }