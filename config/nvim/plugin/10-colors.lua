vim.pack.add({
  'https://github.com/catppuccin/nvim',
})

require('catppuccin').setup({
  flavour = 'macchiato',
  transparent_background = false,
  show_end_of_buffer = false,
  auto_integrations = true,
  integrations = {
    snacks = {
      enabled = true,
      indent_scope_color = 'flamingo',
    },
    blink_cmp = {
      style = 'bordered',
    },
  },
  styles = {
    comments = { 'italic' },
  },
  custom_highlights = function(colors)
    return {
      ContextVt = { fg = '#494d64' },
      NonText = { fg = '#303446' },
      Whitespace = { fg = '#303446' },
      SnacksPickerDirectory = { fg = colors.overlay2, style = { 'bold' } },
      SnacksPickerPathHidden = { fg = colors.overlay0 },
      SnacksPickerDir = { fg = colors.overlay0 },
      SnacksDim = { fg = colors.surface1 },
      SnacksPickerGitStatusUntracked = { fg = colors.mauve }
    }
  end,
})

vim.cmd.colorscheme('catppuccin-macchiato')