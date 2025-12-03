-- Lua vai LuaLS
-- https://github.com/luals/lua-language-server
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    { ".luarc.json", ".luarc.jsonc" }, -- grouped means equal priority
    ".git",
    "lazy-lock.json", -- for nvim config,
  },
  settings = {
    Lua = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          'vim',
          'require'
        },
      },
      hint = {
        enable = true,
        paramName = "All",
        paramType = true,
        semicolon = "All",
        setType = true,
      },
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
}
