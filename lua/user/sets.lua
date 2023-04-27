local opt = vim.opt
-----------------------
-- Main Settings
opt.syntax = "on"
opt.showmode = false
opt.errorbells = false
opt.number = true
opt.relativenumber = true
opt.guicursor = ""
opt.termguicolors = true
opt.scrolloff = 8
opt.updatetime = 50
-----------------------
-- Tabs
opt.expandtab = true
opt.smartcase = true
opt.autoindent = true
opt.smartindent = true
opt.wrap = false
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4
opt.linespace = 8
-----------------------
-- Files
opt.incsearch = true
opt.hidden = true
opt.completeopt='menuone,noinsert,noselect'
-----------------------
-- Backup
opt.swapfile = false
opt.backup = false
opt.writebackup = false
-----------------------
