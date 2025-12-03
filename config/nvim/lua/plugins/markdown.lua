-- markdown rendering
-- https://github.com/MeanderingProgrammer/render-markdown.nvim

local render_markdown = {
   "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.nvim",
  },
  lazy = true,
  event = "BufEnter",
  ft = "markdown",
}

return { render_markdown }