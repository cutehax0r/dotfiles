-- Ruby via Ruby-lsp
-- https://github.com/Shopify/ruby-lsp
return {
  cmd = { "ruby-lsp" },
  filetypes = {
    "ruby",
    "eruby"
  },
  root_markers = {
    "Gemfile",
    ".git",
    ".ruby-version",
    "Rakefile"
  },
  init_options = {
    experimentalFeaturesEnabled = true,
    enabledFeatures = {
      codeActions = true,
      codeLens = true,
      completion = false,
      definition = false,
      diagnostics = true,
      documentHighlights = false,
      documentLink = false,
      documentSymbols = false,
      foldingRanges = false,
      formatting = true,
      hover = false,
      inlayHint = true,
      onTypeFormatting = true,
      selectionRanges = false,
      semanticHighlighting = false,
      signatureHelp = false,
      typeHierarchy = false,
      workspaceSymbol = false,
    },
  },
}
