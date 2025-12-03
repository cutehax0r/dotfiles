local neotest = {
  "nvim-neotest/neotest",
  lazy = true,
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- test adapters
    -- python
    -- rspec
    -- some kind of javascript/typescript
    {
      "volodya-lombrozo/neotest-ruby-minitest",
    },
    {
      "fredrikaverpil/neotest-golang",
      version = "*",  -- Optional, but recommended; track releases
      build = function()
        vim.system({"go", "install", "gotest.tools/gotestsum@latest"}):wait()
      end,
    },
  },
  -- event = { "BufEnter", "LspAttach" },
  opts = {},
  command = { "Neotest" },
  keys = {
    { "<leader>tt", "<cmd>Neotest summary<CR>", mode = { "n", "v" }, desc = "Toggle test summary panel" },
    { "<leader>tr", "<cmd>Neotest run<CR>", mode = { "n", "v" }, desc = "Run the nearest test" },
    { "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", mode = { "n", "v" }, desc = "Run the the current test file" },
    { "<leader>to", "<cmd>Neotest output<CR>", mode = { "n", "v" }, desc = "View the output for the current test" },
    { "<leader>tO", "<cmd>Neotest output-panel<CR>", mode = { "n", "v" }, desc = "Toggle the output panel for tests" },
  },

  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-ruby-minitest")({ command = "bundle exec ruby -Itest" }),
        require("neotest-golang")({}),
      },
      diagnostic = {
        enabled = false,
      },
    })
  end,
}

return { neotest }
