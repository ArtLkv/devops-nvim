-- Disable TreeSitter, if file's line count more than 10000
local function treesitter_disable(_, bufnr) -- lang, bufnr
    return vim.api.nvim_buf_line_count(bufnr) > 10000
end

require'nvim-treesitter.configs'.setup {
  ensure_installed = 'all',

  sync_install = false,
  auto_install = true,

  highlight = {
    enable = true,
    disable = function(lang, bufnr)
        return treesitter_disable(lang, bufnr)
    end,
    additional_vim_regex_highlighting = false,
  },
}
