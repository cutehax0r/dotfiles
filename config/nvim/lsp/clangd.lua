-- C via Clangd
-- https://clangd.llvm.org/installation.html
return {
  cmd = { "clangd" },
  filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
    "cuda",
  },
  root_markers = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ca",
    "makefile",
    ".git",
  },
  -- settings = { }
}

