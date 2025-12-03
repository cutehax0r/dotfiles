-- Color scheme: catppuccin
-- https://github.com/catppuccin/nvim
local catppuccin = {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "macchiato",
      transparent_background = false,
      show_end_of_buffer = false,
      auto_integrations = true,
      integrations = {
        snacks = {
          enabled = true,
          indent_scope_color = "flamingo",
        },
        blink_cmp = {
          style = "bordered",
        },
      },
      styles = {
        comments = { "italic" },
      },
      -- look for colors at https://catppuccin.com/palette/
      custom_highlights = function(colors)
        return {
          ContextVt = { fg = "#494d64" }, -- colors.surface1
          NonText = { fg = "#303446" }, -- return character etc in list chars -- colors.base
          Whitespace = { fg = "#303446" }, -- trailing whitespace chars
          -- Snacks picker directory and hidden text is too dark when selecting a file: Make it brighter
          SnacksPickerDirectory = { fg = colors.overlay0, style = { "bold" } },
          SnacksPickerPathHidden = { fg = colors.overlay0 },
          SnacksPickerDir = { fg = colors.overlay0 },
          SnacksDim = { fg = colors.surface1 }
        }
      end,

    })
    vim.cmd.colorscheme("catppuccin-macchiato")
  end,
}

return { catppuccin }
