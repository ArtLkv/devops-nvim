----------------------------
-- Main Mappings
local map = vim.keymap.set
vim.g.mapleader = ' '
local function save_file()
  vim.cmd[[update]]
end
map('n', '<leader>sf', save_file)
map('n', '<leader>t', vim.cmd.ToggleTerm)
----------------------------
-- Disable arrows. Only hjkl
map('', '<up>', '', {})
map('', '<down>', '', {})
map('', '<left>', '', {})
map('', '<right>', '', {})
-----------------------------
-- Telescope Mappings
local builtin = require('telescope.builtin')
map('n', '<leader>fv', vim.cmd.NvimTreeToggle)
map('n', '<leader>ff', builtin.find_files)
map('n', '<leader>fb', builtin.buffers)
map('n', '<leader>fg', function()
  builtin.grep_string({ search = vim.fn.input('Grep > ') })
end)
-----------------------------
-- Bufferline Mappings
local function delete_buffer()
  vim.cmd([[update]])
  vim.cmd([[bdelete!]])
end
map('n', '<leader>bq', delete_buffer)
map('n', '<leader>bp', vim.cmd.BufferLineTogglePin)
map('n', '<leader>bs', vim.cmd.BufferLinePick)
map('n', '<C-h>', vim.cmd.BufferLineCyclePrev)
map('n', '<C-l>', vim.cmd.BufferLineCycleNext)
-----------------------------
-- Diagnostic Mappings
map('n', '<leader>e', vim.diagnostic.open_float)
map('n', '[d', vim.diagnostic.goto_prev)
map('n', ']d', vim.diagnostic.goto_next)
map('n', '<leader>q', vim.diagnostic.setloclist)
-----------------------------
