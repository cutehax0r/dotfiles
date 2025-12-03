-- Ruby via Solargraph
-- https://solargraph.org/
return {
  enabled = false,
  cmd = { "solargraph", "stdio" },
  filetypes = { "ruby", "eruby" },
  root_markers = { ".ruby-version", "Gemfile", ".git" },
  init_options = { formatting = false },
  settings = {
    solargraph = {
      diagnostics = false,
    },
  },
}
