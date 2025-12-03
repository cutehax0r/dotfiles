-- Python via based-pyrite
-- https://docs.basedpyright.com/
return {
  cmd = { "basedpyright-langserver", "--stdio" },
  filetypes = { "python" },
  root_markers = {
    ".python-version",
    "pyproject.toml",
    "pyrightconfig.json",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    "Pipfile",
    ".git",
  },
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
      inlayHints = {
        variableTypeHints = true,
        functionReturnTypeHints = true,
        callArgumentTypeHints = true,
      },
    },
  },
}
