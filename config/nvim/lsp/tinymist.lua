-- Typst via Tinymist
-- https://github.com/Myriad-Dreamin/tinymist
return {
  cmd = { "tinymist" },
  filetypes = { "typst" },
  root_markers = {},
  settings = {
    formatterMode = "typstyle",
    exportPdf = "onSave", -- consider 'onType'
    semanticTokens = "disable"
  },
}
