vim.pack.add({
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/RRethy/nvim-treesitter-endwise',
  'https://github.com/MeanderingProgrammer/treesitter-modules.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  'https://github.com/andersevenrud/nvim_context_vt',
})

require('nvim-treesitter').setup({
  build = ':TSUpdate',
  branch = 'main',
})

require('treesitter-modules').setup({
  ensure_installed = {
    'arduino',
    'c',
    'cmake',
    'css',
    'csv',
    'diff',
    'dockerfile',
    'dot',
    'git_config',
    'git_rebase',
    'gitcommit',
    'go',
    'gomod',
    'gotmpl',
    'graphql',
    'html',
    'javascript',
    'json',
    'lua',
    'luadoc',
    'make',
    'markdown',
    'python',
    'ruby',
    'sql',
    'tsv',
    'tsx',
    'typescript',
    'typst',
    'yaml',
  },
  fold = { enable = true },
  highlight = { enable = true },
  indent = { enable = true },
  auto_install = true,
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      node_decremental = '<c-s-space>',
    },
  },
})

require('treesitter-context').setup({
  enable = true,
  multiwindow = false,
  max_lines = 0,
  min_window_height = 0,
  line_numbers = true,
  multiline_threshold = 5,
  trim_scope = 'outer',
  mode = 'topline',
})

require('nvim_context_vt').setup({
  enabled = true,
  prefix = '󰁡',
  disable_ft = { 'markdown' },
  disable_virtual_lines = false,
  disable_virtual_lines_ft = { 'yaml' },
  min_rows = 5,
  highlight = 'ContextVt',
})