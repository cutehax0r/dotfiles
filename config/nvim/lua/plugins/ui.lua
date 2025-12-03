-- A number of small addons that improve the editing experience

-- A simple UI for toggling on and off visual clutter
-- ~/Documents/src/github.com/cutehax0r/toggler.nvim
local toggler = {
  dir = "~/Documents/src/github.com/cutehax0r/toggler.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  command = { "Toggler", },
  config = function()
    require('toggler').setup({
      icons = {
        enabled = '',
        disabled = '',
      },
      features = {
        {
          name = "Everything",
          description = "Turn off everything",
          get = function() return true end,
          set = function() vim.notify("Toggling off everyting") end,
          icons = {
            enabled = "X",
            disabled = "X",
          },
        },
        {
          name = "Render Markdown",
          description = "Stop 'fancy' rendering of markdown",
          get = function()
            local ok, lib = pcall(require, "render-markdown")
            if not ok then return false end
            return lib.get() == true
          end,
          set = function(state)
            if state then
              require('render-markdown').enable()
            else
              require('render-markdown').disable()
            end
          end
        },
        {
          name = "Auto-completion popup menu",
          get = function()
            return not (vim.b.completion == false) -- nil or true = enabled so check on false.
          end,
          set = function(state)
            if state then
              vim.b.completion = nil
            else
              vim.b.completion = false
            end
          end,
        },
        {
          name = "Indent level marking",
          get = function() return Snacks.indent.enabled == true end,
          set = function(state)
            if state then
              Snacks.indent.enable()
            else
              Snacks.indent.disable()
            end
          end,
        },
        {
          name = "Underline spelling errors",
          get = function() return vim.wo.spell end,
          set = ":set spell!",
        },
        {
          name = "Invisible characters",
          get = function() return vim.o.list == true end,
          set = function(state) vim.o.list = state end,
        },
        {
          name = "Git signs",
          get = function()
            return require('gitsigns.config').config.signcolumn
          end,
          set = ":Gitsigns toggle_signs",
        },
        {
          name = "LSP inlay hints",
          get = function() return vim.lsp.inlay_hint.is_enabled() end,
          set = function(state) vim.lsp.inlay_hint.enable(state) end,
        },
        {
          name = "LSP diagnostics",
          get = function() return vim.diagnostic.is_enabled() end,
          set = function(state) vim.diagnostic.enable(state) end,
        },
        {
          name = "Code comments hiding",
          get = function() return require('hide-comment').is_enabled() end,
          set = ":HideCommentToggle",
        },
        {
          name = "Color swatches",
          get = function() return require("nvim-highlight-colors").is_active() end,
          set = ":HighlightColors Toggle",
        },
        {
          name = "Virtual Column",
          get = function() return require("virt-column.config").config.enabled end,
          set = function(state)
            require("virt-column").update({ enabled = state })
          end,
        },
        {
          name = "Top of window tree sitter context",
          get = function()
            return require('treesitter-context').enabled()
          end,
          set = ":TSContext toggle",
        },
        {
          name = "Scope closing tree sitter context",
          get = function()
            -- there's no good way to do this. It's fragile as heck
            local _, value = debug.getupvalue(require("nvim_context_vt").toggle_context, 1)
            return value.enabled
          end,
          set = ":NvimContextVtToggle",
        },
        {
          name = "Image rendering in markdown files",
          get = function() return true end,
          set = function(state)
            if state then
              vim.notify("needs an updatd config to use snacks")
            else
              vim.notify("needs an updatd config to use snacks")
            end
          end
        },
        {
          name = "Copilot auto trigger",
          get = function()
            return vim.b.copilot_suggestion_auto_trigger
          end,
          set = ':Copilot suggestion toggle_auto_trigger',
        },
      }
    })
  end
}

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

return { toggler, autopairs, sandwich, lualine, virtual_column, blink, goto_preview, highlight_colors, comments }
