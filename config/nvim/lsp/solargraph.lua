-- Ruby via Solargraph
-- https://solargraph.org/
--
-- Used for completion, hover docs and signature help (RBS core/stdlib + YARD). Navigation, symbols,
-- code actions and diagnostics come from ruby-lsp (see ruby-lsp.lua), so those are disabled here
-- to avoid duplicate results in pickers.
return {
  cmd = { "solargraph", "stdio" },
  filetypes = {
    "ruby",
    "eruby"
  },
  -- Project root if a marker is found walking up; otherwise treat the file's own directory as a
  -- standalone workspace (scratch scripts), so unrelated loose files don't share one server.
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, { ".solargraph.yml", "Gemfile", ".ruby-version", ".git" })
    on_dir(root or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
  end,
  init_options = { formatting = false },
  settings = {
    solargraph = {
      diagnostics = false,
      completion = true,
      hover = true,
      autoformat = false,
      folding = false,
      references = false,
      rename = false,
      symbols = false,
    },
  },
  on_attach = function(client)
    -- Clearing server_capabilities isn't enough: solargraph also registers these methods
    -- dynamically, so nvim (and Snacks pickers) would still ask it and show duplicate results.
    -- Make the client report them unsupported.
    local blocked = {
      ["textDocument/definition"] = true,
      ["textDocument/typeDefinition"] = true,
      ["textDocument/implementation"] = true,
      ["textDocument/references"] = true,
      ["textDocument/rename"] = true,
      ["textDocument/prepareRename"] = true,
      ["textDocument/documentSymbol"] = true,
      ["workspace/symbol"] = true,
      ["textDocument/documentHighlight"] = true,
      ["textDocument/formatting"] = true,
      ["textDocument/rangeFormatting"] = true,
      ["textDocument/foldingRange"] = true,
      ["textDocument/codeAction"] = true,
      ["textDocument/diagnostic"] = true,
    }
    local supports_method = client.supports_method
    client.supports_method = function(self, method, ...)
      if blocked[method] then
        return false
      end
      return supports_method(self, method, ...)
    end
  end,
}
