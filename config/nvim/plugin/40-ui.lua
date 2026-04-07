vim.pack.add({
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/saghen/blink.cmp',
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/machakann/vim-sandwich',
  'https://github.com/lukas-reineke/virt-column.nvim',
  'https://github.com/rmagatti/goto-preview',
  'https://github.com/rmagatti/logger.nvim',
  'https://github.com/brenoprata10/nvim-highlight-colors',
  'https://github.com/cutehax0r/hide-comment.nvim',
})

require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'catppuccin-macchiato',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
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
    lualine_a = { 'mode' },
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        file_status = true,
        newfile_status = true,
        symbols = {
          modified = '󰈤',
          readonly = '󰌾',
          unnamed = '󰠙 Unnamed',
          newfile = '󰿔',
        },
      },
    },
    lualine_x = { 'filetype' },
    lualine_y = {
      {
        color = { fg = '#ff9e64' },
      },
    },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
})

require('blink.cmp').setup({
  fuzzy = {
    implementation = "lua",
  },
  completion = {
    documentation = { auto_show = true },
    list = {
      selection = {
        preselect = false,
        auto_insert = false
      },
    },
  },
  keymap = {
    preset = 'none',
    ['<Tab>'] = { 'select_next', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'fallback' },
    ['<C-n>'] = {
      function(cmp)
        if cmp.snippet_active({ direction = 1 }) then
          cmp.snippet_forward()
          return true
        end
      end,
    },
    ['<C-p>'] = {
      function(cmp)
        if cmp.snippet_active({ direction = -1 }) then
          cmp.snippet_backward()
          return true
        end
      end,
    },
    ['<Escape>'] = {
      function(cmp)
        if cmp.menu and cmp.menu.is_open() then
          cmp.hide()
        end
        return false
      end,
      'fallback',
    },
    ['<CR>'] = { 'accept', 'fallback' },
  },
  signature = {
    enabled = true,
  },
  sources = {
    default = { 'lsp', 'path', 'buffer' },
  },
})

require('nvim-autopairs').setup({
})

require('virt-column').setup({
  exclude = {
    buftype = { 'snacks_dashboard' },
  },
})

require('goto-preview').setup({
  width = 60,
  height = 10,
  default_mappings = false,
  debug = false,
  opacity = nil,
  resize_mappings = false,
  references = {
    provider = 'snacks',
  },
  focus_on_open = false,
  dismiss_on_move = true,
  bufhidden = 'wipe',
  same_file_float_preview = true,
  vim_ui_input = true,
})

vim.opt.termguicolors = true
require('nvim-highlight-colors').setup({
  render = 'virtual',
  virtual_symbol = '󰏺',
  virtual_symbol_prefix = ' ',
  virtual_symbol_suffix = '',
  virtual_symbol_position = 'eow',
})

require('hide-comment').setup({
  auto_enable = false,
  smart_navigation = true,
  smart_navigation_mode = 'skip',
  conceal_level = 3,
  refresh_on_change = true,
  refresh_debounce_ms = 100,
})

vim.keymap.set({ 'n', 'v' }, '<leader>p', function() require('goto-preview').goto_preview_definition() end, { desc = 'LSP: Peek definition' })
