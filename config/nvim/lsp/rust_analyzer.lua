-- Rust via rust-analyzer
-- https://rust-analyzer.github.io/
return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "Cargo.lock", ".git" },
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = true,
      check = { command = "clippy" },
      procMacro = { enable = true },
    },
  },
}
