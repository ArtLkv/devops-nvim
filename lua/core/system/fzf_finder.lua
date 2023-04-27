local telescope = require('telescope')
local config = require('telescope.config')

local vimgrep_args = { unpack(config.values.vimgrep_arguments) } -- Clone the default settings

--------------------------------------------
-- VimGrep Arguments Filter
table.insert(vimgrep_args, '--hidden') -- I want to search in hidden files
table.insert(vimgrep_args, '--glob') -- I don't want to search in the `.git` directory
table.insert(vimgrep_args, '!**/.git/**') -- I don't want to search in the `.git` directory
--------------------------------------------

telescope.setup({
  defaults = {
    hidden = true,
    vimgrep_arguments = vimgrep_args,
  },
  pickers = {
    find_files = {
      hidden = true,
      find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/**' },
    },
    buffers = {
      initial_mode = 'normal'
    },
  },
})

require('telescope').setup({
  pickers = {
    live_grep = {
      additional_args = function(_) -- _ts
        return { '--hidden' }
      end,
    },
  },
})
