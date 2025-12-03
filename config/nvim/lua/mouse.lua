-- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/_defaults.lua
-- https://www.youtube.com/watch?v=_U54QKdFQno

vim.cmd([[
  aunmenu PopUp
  anoremenu <silent> PopUp.󰱼\ \ Search\ in\ File :lua Snacks.picker.grep_buffers()<CR>
  anoremenu <silent> PopUp.\ \ Search\ in\ Project :lua Snacks.picker.grep()<CR>
  anoremenu <silent> PopUp.-1- <NOP>
  anoremenu <silent> PopUp.\ \ Go\ to\ Definition :lua Snacks.picker.lsp_definitions()<CR>
  anoremenu <silent> PopUp.\ \ Show\ References :lua Snacks.picker.lsp_references()<CR>
  anoremenu <silent> PopUp.󰌍\ \ Go\ back <C-t>
  anoremenu <silent> PopUp.\ \ Hover\ Doc :lua vim.lsp.buf.hover()<CR>
  anoremenu <silent> PopUp.\ \ Code\ Actions :lua vim.lsp.buf.code_action()<CR>
  anoremenu <silent> PopUp.-2- <NOP>
  anoremenu <silent> PopUp.\ \ Git\ Blame :Gitsigns blame_line<CR>
  anoremenu <silent> PopUp.󰊤\ \ Git\ Link\ (copy) :lua Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })<CR>
  anoremenu <silent> PopUp.\ \ Git\ Link\ (open) :lua Snacks.gitbrowse({ notify = false })<CR>
  anoremenu <silent> PopUp.\ \ Git\ Gist\ (open) :'<,'>PP<CR>
  anoremenu <silent> PopUp.-3- <NOP>
  anoremenu <silent> PopUp.\ \ Fold\ Toggle :set foldenable!<CR>
  anoremenu <silent> PopUp.\ \ Fold\ More zm
  anoremenu <silent> PopUp.\ \ Fold\ Less zr
  anoremenu <silent> PopUp.-4- <NOP>
  anoremenu <silent> PopUp.\ \ V-Split :vsplit<CR>
  anoremenu <silent> PopUp.\ \ H-Split :split<CR>
  anoremenu <silent> PopUp.\ \ Close\ Window :close<CR>
  anoremenu <silent> PopUp.\ \ Delete\ Buffer :bdelete<CR>
  anoremenu <silent> PopUp.-5- <NOP>
  anoremenu <silent> PopUp.\ \ Copy\ Path :lua vim.fn.setreg('+', vim.fn.expand('%:p'))<CR>
  anoremenu <silent> PopUp.\ \ Open\ Containing\ Folder :lua vim.system({'open', '-R', vim.fn.expand('%:p')}, {detach = true})<CR>
  anoremenu <silent> PopUp.󰖟\ \ Open\ in\ Browser gx
]])

local group = vim.api.nvim_create_augroup("nvim.popupmenu", { clear = true })
vim.api.nvim_create_autocmd("MenuPopup", {
  pattern = "*",
  group = group,
  desc = "Mouse Popup Setup",
  callback = function()
    local has_lsp = #vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() }) > 0

    -- Check if file is in a git repository
    local git_check = vim.system({ "git", "rev-parse", "--git-dir" }, { cwd = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h"), text = true, }):wait()
    local has_git = git_check.code == 0

    -- Disable LSP menu items if no LSP
    if not has_lsp then

      vim.cmd([[silent! aunmenu PopUp.\ \ Go\ to\ Definition]])
      vim.cmd([[silent! aunmenu PopUp.\ \ Show\ References]])
      vim.cmd([[silent! aunmenu PopUp.\ \ Hover\ Doc]])
      vim.cmd([[silent! aunmenu PopUp.󰌍\ \ Go\ back]])
      vim.cmd([[silent! aunmenu PopUp.\ \ Code\ Actions]])
      vim.cmd([[silent! aunmenu PopUp.-2-]])
    end

    -- Disable Git menu items if not in a git repository
    if not has_git then
      vim.cmd([[silent! aunmenu PopUp.\ \ Git\ Blame]])
      vim.cmd([[silent! aunmenu PopUp.󰊤\ \ Git\ Link\ (copy)]])
      vim.cmd([[silent! aunmenu PopUp.\ \ Git\ Link\ (open)]])
      vim.cmd([[silent! aunmenu PopUp.\ \ Git\ Gist\ (open)]])
      vim.cmd([[silent! aunmenu PopUp.-3-]])
    end
  end,
})
