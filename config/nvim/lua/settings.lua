local o = vim.opt

o.autoindent = true				-- automating indentation
o.autoread = true				-- Re-read a buffer if it's file changes
o.background = "dark"				-- Use dark-mode color groups
o.backspace = "eol,start,indent"		-- Allow backspace to erase line breaks, past the start of insert mode and through indentation
o.backupdir = vim.fn.stdpath("data") .. "/backup" -- Where to store backups (in ~/.local/share/nvim/backup)
o.breakindent = true				-- When line-breaking preserve indentation
o.clipboard = "unnamed,unnamedplus"		-- Use the system clipboard. On mac and windows these are the same but not on linux
o.cmdheight = 1					-- Height for command line. 0 causes issues with some commands right now
o.cmdwinheight = 10				-- Height for command line window
o.colorcolumn = "+0"				-- Highlight the columns at "textwidth"
o.completeopt =					-- see completion.lua
  "menu,preview,noinsert,menuone,noselect"  	-- use a popump menu for completion, even with only one option, make people select to use completion and don't insert until they do
o.diffopt = "internal,filler,closeoff"		-- Custom settings for diff handling
o.directory = vim.fn.stdpath("data") .. "/swap" -- swap path location
o.eadirection = "both"				-- how does "equalalways" work - vertical and horizontal
o.emoji = true					-- always show emoji as full width, even "text" emoji
o.expandtab = true				-- use spaces instead of tabs for indent. Set this up in a ftplug instead if you want tabs to be tabs
o.fillchars =  {				-- default fill chars for status bars, split borders, etc.
  fold = " ",
  foldopen = "▾",
  foldclose = "▸",
}
o.foldenable = false				-- turn off code folding, enable it with 'zi'
o.foldlevelstart = 1				-- new buffers start with some folds closed iff folding is enabled
o.foldlevel = 1					-- set the fold level for the buffer - some open, adjusted by zm/zr etc.
function _G.CustomFoldText() 			-- see https://essais.co/better-folding-in-neovim/
  return  vim.fn.getline(vim.v.foldstart) .. " … " .. vim.fn.getline(vim.v.foldend):gsub("^%s*", "")
end
o.foldtext = "v:lua.CustomFoldText()"		-- use custom function to create fold texts
o.formatoptions = "tcqj"			-- autowrap, autowrap comments, format paragraphs, format with gq, see https://neovim.io/doc/user/change.html#fo-table
o.hidden = true					-- allow buffers to exist even if there are no windows for them
o.history = 10000				-- allow the maximum number of history items
o.hlsearch = false				-- highlight search results
o.ignorecase = true				-- ignore case in searches
o.inccommand = "nosplit"			-- show preview of commands like :s inline instead of as a split
o.incsearch = true				-- highlight search results as you type
o.joinspaces = false				-- don't put 2 spaces after a '." or "?' etc. when using J
o.jumpoptions = "stack"				-- remove unloaded buffers from jump list
o.keywordprg = ":Man"				-- program to use for K
o.laststatus = 2				-- the last window always has a status line
o.list = true					-- by default show "hidden" characters like tab and spaces trailing lines
o.listchars = {					-- characters to use for showing hidden chars
  nbsp = "○",
  tab = "→ ",
  eol = "↵",
  trail = "␣",
  extends = "⇀",
  precedes = "↼",
}
o.matchtime = 2					-- length of time to show matching character (in tenths of a second?!)
o.modeline = false				-- don't check for mode lines
o.modelineexpr = false				-- don't allow expressions in modelines
o.mouse = "nvich"				-- enable mouse in normal, visual, insert, command mode, and when editing help files
o.mousehide = true				-- hide the mouse cursor when characters are typed
o.mousemodel = "popup_setpos"			-- right clicking moves the cursor to the click point and shows a popup menu
o.mousescroll = "ver:5,hor:5"			-- scroll 5 chars with mouse wheel.
o.nrformats = "bin,hex,unsigned"		-- what vim considers to be numbers for ^a ^x
o.number = true					-- print line numbers in this window
o.previewheight = 10				-- use 10 line preview hight of window
o.pumblend = 0					-- fake transparency to use for popump menu (0 = off)
o.pumheight = 10				-- maximum 10 items in pop up menu
o.pumwidth = 15					-- minimum width for popup menu
o.redrawtime = 2000				-- time limit (ms) for redrawing the display. once this time has elapsed, stop redrawing
o.ruler = true					-- show the line and column of the cursor
o.scroll = 5					-- scroll five lines with ^u ^d
o.scrolljump = 1				-- number of lines to scroll when cursor gets off the screen
o.scrolloff = 5					-- number of lines to keep above/below the cursor
o.scrollopt = "hor,ver,jump"			-- scroll bound windows scroll together and jump to maintain relative offset
o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,terminal" -- options for using :mksession
o.shellcmdflag = "-c"				-- flag passed to shell when running "!" commands
o.shiftround = true				-- round indent to multiple of shiftwidth
o.shiftwidth = 2				-- default value to indent by
o.shortmess = "ltToOCFsIcW"			-- helps to avoid a bunch of "press enter" prompts after running commands and stuff
o.showcmd = true				-- show partial command in the last line of the screen
o.showcmdloc = "last"				-- where to show the partially entered command (last line of screen)
o.sidescroll = 5				-- number of horizontal columns to scroll when the cursor is moved off screen
o.sidescrolloff = 10				-- number of characters to keep as padding on the side when scrolling
o.signcolumn = "yes:1"				-- how to draw the sign column
o.smartindent = true				-- do smart indents when inserting a new line
o.smarttab = true				-- using tab inserts according to shiftwidth
o.softtabstop = 2				-- have tab insert a combination of spaces and tabs
o.spell = true					-- enable spell checking
o.splitbelow = true				-- vertical splits happen under current window
o.splitkeep = "cursor"				-- keep the same cursor position when splitting
o.splitright = true				-- horizontal splits happen to the right
o.startofline = false				-- commands like >> and << keep the cursor in the same column
o.suffixes = ".bak,~,.o,.h,.info,.swp,.obj"	-- files with these extensions get lower priority when matching wildcards
o.switchbuf = "uselast"				-- when using quickfix, open items in last used buffer
o.synmaxcol = 3000				-- don't syntax highlight past column 3000. breaks highlighting for the rest of the file, but faster
o.tagcase = "followic"				-- use the ignorecase setting for searching tag files
o.tagrelative = true				-- use filenames relative to the location of the tags file being used
o.tags = "./tags;,tags"				-- default tagfile name to use
o.termguicolors = true				-- enable 24 bit color -- uses gui* instead of cterm* for syntax
o.termpastefilter = "BS,HT,ESC,DEL"		-- don't paste backspace, escape, delete, or tab when pasting
o.termsync = true				-- buffer all screen draw updates so it happens at once: reduces flicker
o.textwidth = 100				-- maximum text width before wrapping
o.timeoutlen = 1000				-- use 1 second for timeouts
o.ttimeoutlen = 50				-- 50ms is enough for partial escape sequences
o.undodir = vim.fn.stdpath("data") .. "/undo"   -- where to store undo files
o.undofile = true				-- enable storing undo files so you can undo between sessions
o.undolevels = 1000				-- have many undo levels
o.undoreload = 10000                            -- save the whole buffer for undo when reloading it
o.updatecount = 0				-- how many characters to wait before writing a swapfile. 0 = no swap
o.updatetime = 4000				-- how long to wait before writing a swap file on idle
o.viewdir = vim.fn.stdpath("data") .. "/view"   -- where to store files for :mkview
o.viewoptions = "folds,cursor,curdir"		-- configures :mkview, save/restores cursor position, folds, and directory
o.warn = true					-- give warning if shell command is used on a changed buffer
o.whichwrap = "b,s"				-- whcih characters move the cursor to the next/previous line (backspace and space). h/l not recommended
o.wildignorecase = true				-- ignore case when completing files and directories
o.wildmenu = true				-- enhanced command line completion
o.wildmode = "full"				-- complete the next full match when using wildmenu
o.wildoptions = "pum,tagfile"			-- use popup menu to show wildmenu completions, show the kind of tag when completing from tag menu
o.winborder = "rounded"                         -- nice round borders on popup windows
o.wrap = false					-- don't wrap
o.wrapmargin = 5				-- wrap 5 chars from the margin
o.wrapscan = true				-- searches wrap around to the top of the file

-- https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.Opts
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰚑",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "Error",
      [vim.diagnostic.severity.WARN] = "Warn",
      [vim.diagnostic.severity.INFO] = "Info",
      [vim.diagnostic.severity.HINT] = "Hint",
    },
    -- numhl also exists if you want to move the highlights to the line number,
  },
  underline = false,
  update_in_insert = false,
  float = {
    scope = "line",
    severity_sort = true,
    header = "Diagnostics",
    source = true,
  },
  virtual_text = false,
  virtual_lines = false, -- { current_line = true }
  severity_sort = true,
})
