-- A number of small addons that improve the editing experience

-- Enable automatic insertion of mathing quotes and brackets
-- https://github.com/windwp/nvim-autopairs
local autopairs = {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
}

-- Operators for wrapping text with brackets, quotes, etc.
-- https://github.com/machakann/vim-sandwich
local sandwich = {
  "machakann/vim-sandwich",
  event = "InsertEnter",
}

-- Have better control over the "cursor colum" showing 80/100/120 lines
-- https://github.com/lukas-reineke/virt-column.nvim
local virtual_column = {
  "lukas-reineke/virt-column.nvim",
  config = function()
    require("virt-column").setup({
      exclude = {
        buftype = { "snacks_dashboard" },
      },
    })
  end,
}

-- Improved status bar
-- https://github.com/nvim-lualine/lualine.nvim
local lualine = {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "catppuccin",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        refresh = {
          statusline = 100,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {},
        lualine_c = {
          {
            "filename",
            file_status = true,
            newfile_status = true,
            symbols = {
              modified = "",
              readonly = "",
              unnamed = " Unnamed",
              newfile = "",
            },
          },
        },
        lualine_x = { "filetype" },
        lualine_y = {
          {
            color = { fg = "#ff9e64" },
          },
        },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}

-- Blink Auto completion
-- https://cmp.saghen.dev/
local blink = {
  "saghen/blink.cmp",
  version = "1.*",
  event = "BufEnter",
  config = function()
    require("blink.cmp").setup({
      completion = {
        documentation = { auto_show = true },
        list = {
          selection = {
            preselect = false,  -- Nothing selected when typing
            auto_insert = false -- No auto-insert preview,
          },
        },
      },
      keymap = {
        preset = "none",  -- Start with no preset, use custom keymaps only
        -- ["<C-space>"] = { "select_and_accept", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Escape>"] = {
          function(cmp)
            -- Always close the menu if it's open
            if cmp.menu and cmp.menu.is_open() then
              cmp.hide()
            end
            -- Always run fallback to exit insert mode
            return false
          end,
          "fallback",
        },
        ["<CR>"] = { "accept", "fallback" },
      },
      signature = {
        enabled = true,
        window = {
          max_width = 40,
          direction_priority = { "n", "s" },  -- "n" = above, "s" = below
          show_documentation = false,  -- Only show signature, not full docs,
        },
      },
      sources = {
        default = { "lsp", "path", "buffer" },
      },
    })
  end,
  opts_extend = { "sources.default" },
}

-- Peek definition via Goto Preview
-- https://github.com/rmagatti/goto-preview
local goto_preview = {
  "rmagatti/goto-preview",
  dependencies = { "rmagatti/logger.nvim" },
  event = "BufEnter",
  keys = {
    { "<leader>p", function() require('goto-preview').goto_preview_definition() end, mode = { "n", "v" }, desc = "LSP: Peek definition" },
  },
  config = function()
    require("goto-preview").setup({
      width = 60,
      height = 10,
      default_mappings = false,
      debug = false,
      opacity = nil,
      resize_mappings = false,
      references = {
        provider = "snacks",
      },
      focus_on_open = false,
      dismiss_on_move = true,
      bufhidden = "wipe",
      same_file_float_preview = true,
      vim_ui_input = true,
    })
  end,
}

-- Highlights colors, putting little "dots" to preview them inline
-- https://github.com/brenoprata10/nvim-highlight-colors
local highlight_colors = {
  "brenoprata10/nvim-highlight-colors",
  config = function()
    vim.opt.termguicolors = true
    require("nvim-highlight-colors").setup({
      render = "virtual",
      virtual_symbol = "⏺",
      virtual_symbol_prefix = " ",
      virtual_symbol_suffix = "",
      virtual_symbol_position = "eow",
    })
  end,
}

-- Hide comments with conceal - is archived now. Is there an alternative?
-- https://github.com/wroyca/hide-comment.nvim
local comments = {
  "wroyca/hide-comment.nvim",
  opts = {
    auto_enable = false,
    smart_navigation = true,
    conceal_level = 3,
    refresh_on_change = true,
  },
}

return { autopairs, sandwich, lualine, virtual_column, blink, goto_preview, highlight_colors, comments }
