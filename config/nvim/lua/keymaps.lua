-- Mapping keys that don't have anything to do with plugins
local k = vim.keymap.set
vim.g.mapleader = " "                       -- Use "space" as leader key
k({ "n", "v" }, "XX", "<cmd>qall!<cr>", { silent = true, desc = "Quit without saving changes" })
k({ "n", "v" }, "ZZ", "<cmd>x<cr>", { silent = true, desc = "Save changes (if any) and quit" })
k({ "n", "v" }, "<leader>\\", "<cmd>vsplit<cr>", { silent = true, desc = "Split the window vertically" })
k({ "n", "v" }, "<leader>-", "<cmd>split<cr>", { silent = true, desc = "Split the window horizontally" })
k({ "n", "v" }, "<leader><bs>", "<cmd>close<cr>", { silent = true, desc = "Close the current window" })
k({ "n", "v" }, "<c-h>", "<cmd>wincmd h<cr>", { silent = true, desc = "Select to the window on the left" })
k({ "n", "v" }, "<c-j>", "<cmd>wincmd j<cr>", { silent = true, desc = "Select to the window below" })
k({ "n", "v" }, "<c-k>", "<cmd>wincmd k<cr>", { silent = true, desc = "Select to the window above" })
k({ "n", "v" }, "<c-l>", "<cmd>wincmd l<cr>", { silent = true, desc = "Select to the window on the right" })
k({ "n", "v" }, "<c-s-h>", function() vim.api.nvim_win_set_width(0, vim.api.nvim_win_get_width(0)-5) end, { silent = true, desc = "Resize window: narrower" })
k({ "n", "v" }, "<c-s-j>", function() vim.api.nvim_win_set_height(0, vim.api.nvim_win_get_height(0)-5) end, { silent = true, desc = "Resize window: shorter" })
k({ "n", "v" }, "<c-s-k>", function() vim.api.nvim_win_set_height(0, vim.api.nvim_win_get_height(0)+5) end, { silent = true, desc = "Resize window: taller" })
k({ "n", "v" }, "<c-s-l>", function() vim.api.nvim_win_set_width(0, vim.api.nvim_win_get_width(0)+5) end, { silent = true, desc = "Resize window: wider" })

k({ "n", "v" }, "<leader>]", "<cmd>bnext<cr>", { silent = true, desc = "Switch to the next buffer in the current window" })
k({ "n", "v" }, "<leader>[", "<cmd>bprev<cr>", { silent = true, desc = "Switch to the previous buffer in the current window" })
k({ "n", "v" }, "<leader><s-bs>", "<cmd>bdelete<cr>", { silent = true, desc = "Delete the current buffer" })

k({ "n", "v" }, "]e", function() vim.diagnostic.jump({ count = 1, float = true }) end, { silent = true, desc = "Go to next diagnostic" })
k({ "n", "v" }, "[e", function() vim.diagnostic.jump({ count = -1, float = true }) end, { silent = true, desc = "Go to previous diagnostic" })
k({ "n", "v" }, "<leader>e", vim.diagnostic.open_float, { silent = true, desc = "Show floating diagnostics window for current line" })
k({ "n", "v" }, "<leader>x", vim.lsp.buf.code_action, { silent = true, desc = "Show code actions" })
k({ "n", "v" }, "K", vim.lsp.buf.hover, { silent = true, desc = "Show hover documentation" })
-- Replaced by snacks.  There are some default keybindings for these you should just learn
k({ "n", "v" }, "<leader>S", vim.lsp.buf.document_symbol, { silent = true, desc = "Show document symbols (in quickfix)" })
k({ "n", "v" }, "<leader>s", vim.lsp.buf.workspace_symbol, { silent = true, desc = "Show workplace symbols (in quickfix)" })
k({ "n", "v" }, "<leader>r", vim.lsp.buf.references, { silent = true, desc = "Show LSP references" })
k({ "n", "v" }, "gd", vim.lsp.buf.definition, { silent = true, desc = "Go to LSP definition" })
