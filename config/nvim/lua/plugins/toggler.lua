-- A simple UI for toggling on and off visual clutter
local toggler = {
  "cutehax0r/toggler.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  command = {
    "Toggler",
  },
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
          -- "on" = use copilot, "off" = use blink
          name = "LSP over Copilot",
          description = "Use copilot instead of LSP-powered auto completion",
          get = function() return true end,
          set = function() vim.notify("Toggle between Copilot and LSP suggestions", "info") end,
          icons = {
            enabled = "",
            disabled = "",
          },
        },
        {
          name = "Markdown",
          description = "Stop “fancy” rendering of markdown",
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
          name = "Popup",
          description = "Blink auto-completion popup menu",
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
          name = "Indent",
          description = "Indent level marking for blocks of code",
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
          name = "Spelling",
          description = "Underline of spelling errors",
          get = function() return vim.wo.spell end,
          set = ":set spell!",
        },
        {
          name = "Invisible",
          description = "Showing invisible characters like space, tabs, and returns",
          get = function() return vim.o.list == true end,
          set = function(state) vim.o.list = state end,
        },
        {
          name = "Git",
          description = "Showing added, changed, and removed lines in the sign column",
          get = function()
            return require('gitsigns.config').config.signcolumn
          end,
          set = ":Gitsigns toggle_signs",
        },
        {
          name = "Inlay",
          description = "LSP inlay-hints, showing argument names and types with virtual text",
          get = function() return vim.lsp.inlay_hint.is_enabled() end,
          set = function(state) vim.lsp.inlay_hint.enable(state) end,
        },
        {
          name = "Diagnostics",
          description = "Showing warnings, errors, and info-notices in the sign column",
          get = function() return vim.diagnostic.is_enabled() end,
          set = function(state) vim.diagnostic.enable(state) end,
        },
        {
          name = "Comments",
          description = "Hiding code comments",
          get = function() return require('hide-comment').is_enabled() end,
          set = ":HideCommentToggle",
        },
        {
          name = "Color",
          description = "Color swatches beside rgb hex color definitions",
          get = function() return require("nvim-highlight-colors").is_active() end,
          set = ":HighlightColors Toggle",
        },
        {
          name = "Column",
          description = "Marker for text columns at 80 or 120 columns",
          get = function() return require("virt-column.config").config.enabled end,
          set = function(state)
            require("virt-column").update({ enabled = state })
          end,
        },
        {
          name = "Context",
          description = "Show context at the top of the windows",
          get = function()
            return require('treesitter-context').enabled()
          end,
          set = ":TSContext toggle",
        },
        {
          name = "Crumbs",
          description = "Show code context bread-crumbs at the closing elements of blocks",
          get = function()
            -- there's no good way to do this. It's fragile as heck
            local _, value = debug.getupvalue(require("nvim_context_vt").toggle_context, 1)
            return value.enabled
          end,
          set = ":NvimContextVtToggle",
        },
        {
          name = "Images",
          description = "Rendering of images in markdown documents",
          get = function() return true end,
          set = function(state)
            if state then
              vim.notify("needs an update config to use snacks")
            else
              vim.notify("needs an update config to use snacks")
            end
          end
        },
        {
          name = "Copilot",
          description = "Automatically toggle github copilot suggestions",
          get = function()
            return vim.b.copilot_suggestion_auto_trigger
          end,
          set = ':Copilot suggestion toggle_auto_trigger',
        },
      }
    })
  end
}

return { toggler }
