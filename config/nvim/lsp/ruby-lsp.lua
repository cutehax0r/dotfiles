-- Ruby via Ruby-lsp
-- https://github.com/Shopify/ruby-lsp
--
-- Ruby-lsp owns navigation (definition/references/symbols), code actions (rubocop quick fixes),
-- diagnostics, formatting, and inlay hints. Completion/hover/signature help come from solargraph
-- (see solargraph.lua) because it infers types for stdlib receivers like `[].m`.
return {
  cmd = { "ruby-lsp" },
  -- ruby-lsp sees `sorbet-static` in the bundle and defers to the sorbet LSP: no references,
  -- rename or workspace symbols, and no constant definitions in `typed: strict` files. We don't run
  -- the sorbet LSP, so make it behave as if sorbet weren't there.
  cmd_env = { RUBY_LSP_BYPASS_TYPECHECKER = "1" },
  filetypes = {
    "ruby",
    "eruby"
  },
  -- Project root if a marker is found walking up; otherwise treat the file's own directory as a
  -- standalone workspace (scratch scripts), so unrelated loose files don't share one server.
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, { "Gemfile", ".git", ".ruby-version", "Rakefile" })
    on_dir(root or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
  end,
  init_options = {
    -- Anything not listed defaults to enabled. Only turn off what solargraph does better.
    enabledFeatures = {
      completion = false,
      hover = false,
      signatureHelp = false,
    },
  },
  on_attach = function(client)
    -- belt and braces: make sure nothing in nvim asks ruby-lsp for these
    client.server_capabilities.completionProvider = nil
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.signatureHelpProvider = nil
  end,
}
