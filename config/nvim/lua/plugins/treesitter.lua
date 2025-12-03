-- auto install treesitter languages and enable folding / indenting
vim.api.nvim_create_autocmd({ "Filetype" }, {
  callback = function(event)
    local ignored_fts = {
      "snacks_dashboard",
      "snacks_notif",
      "snacks_input",
      "prompt", -- bt: snacks_picker_input,
    }

    if vim.tbl_contains(ignored_fts, event.match) then return end
    local ok, nvim_treesitter = pcall(require, "nvim-treesitter")
    if not ok then return end

    local ft = vim.bo[event.buf].ft
    local lang = vim.treesitter.language.get_lang(ft)
    nvim_treesitter.install({ lang }):await(function(err)
      if err then
        vim.notify("Treesitter install error for ft: " .. ft .. " err: " .. err)
        return
      end

      pcall(vim.treesitter.start, event.buf)
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end)
  end,
})

-- A fast document parser that provides syntax coloring, folding, indentation, etc.
-- https://github.com/nvim-treesitter/nvim-treesitter
local treesitter = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  branch = "main",
  lazy = false,
}

-- -- Further extends treesitter to automatically insert "end" for functions in lua/ruby/etc
-- -- https://github.com/RRethy/nvim-treesitter-endwise
local endwise = {
  "RRethy/nvim-treesitter-endwise",
  event = "InsertEnter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
}

-- Missing Treesitter functionality: Incremental selection, etc.
-- https://github.com/MeanderingProgrammer/treesitter-modules.nvim
local ts_modules = {
  "MeanderingProgrammer/treesitter-modules.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    ensure_installed = {
      "arduino",
      "c",
      "cmake",
      "css",
      "csv",
      "diff",
      "dockerfile",
      "dot",
      "git_config",
      "git_rebase",
      "gitcommit",
      -- "gitignore",
      "go",
      "gomod",
      "gotmpl",
      "graphql",
      "html",
      "javascript",
      "json",
      "lua",
      "luadoc",
      "make",
      "markdown",
      "python",
      "ruby",
      "sql",
      "tsv",
      "tsx",
      "typescript",
      "typst",
      "yaml",
    },
    fold = { enable = true },
    highlight = { enable = true },
    indent = { enable = true },
    auto_install = true,
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<c-space>", -- set to `false` to disable one of the mappings
        node_incremental = "<c-space>",
        node_decremental = "<c-s-space>",
      },
    },
  },
}

-- function context at the top of the window
-- https://github.com/nvim-treesitter/nvim-treesitter-context
local context = {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    enable = true,
    multiwindow = false,
    max_lines = 0,
    min_window_height = 0,
    line_numbers = true,
    multiline_threshold = 5,
    trim_scope = "outer",
    mode = "topline", -- or cursor
  },
}

-- Context at the end closing bracket of scopes
-- https://github.com/andersevenrud/nvim_context_vt
local vt_context = {
  "andersevenrud/nvim_context_vt",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    enabled = true,
    prefix = "",
    disable_ft = { "markdown" },
    disable_virtual_lines = false,
    disable_virtual_lines_ft = { "yaml" },
    min_rows = 5,
    highlight = "ContextVt",
  },
}

-- https://github.com/cameronr/dotfiles/blob/e51cece81ca64995498d9543b73b99f4939e7176/nvim/lua/plugins/treesitter.lua#L15
return { treesitter, endwise, ts_modules, context, vt_context }
