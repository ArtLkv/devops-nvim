local lspconfig = require('lspconfig')
local util = require('lspconfig/util')
vim.diagnostic.config({ signs = false })
--------------------------------------------
-- On-Attach Function
local on_attach = function(_, bufnr) -- client, bufnr
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local map = vim.keymap.set
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  map('n', 'gD', vim.lsp.buf.declaration, bufopts)
  map('n', 'gd', vim.lsp.buf.definition, bufopts)
  map('n', 'K', vim.lsp.buf.hover, bufopts)
  map('n', 'gi', vim.lsp.buf.implementation, bufopts)
  map('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  map('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  map('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
  map('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  map('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
  map('n', 'gr', vim.lsp.buf.references, bufopts)
  map('n', '<leader>f', function()
    vim.lsp.buf.format({ async = true })
  end, bufopts)
end
---------------------------------------------
-- Lua LSP
lspconfig.lua_ls.setup({
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
})
---------------------------------------------
-- Python LSP
lspconfig.pylsp.setup{
  on_attach = on_attach,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391'},
          maxLineLength = 100
        }
      }
    }
  }
}
--------------------------------------------
-- Golang LSP
lspconfig.gopls.setup({
  on_attach = on_attach,
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_dir = util.root_pattern('go.mod', '.git'),
  single_file_support = true,
})
--------------------------------------------
-- Bash LSP
lspconfig.bashls.setup({
  on_attach = on_attach,
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'sh' },
  root_dir = util.root_pattern(util.find_git_ancestor()),
  settings = {
    bashIde = {
      globPattern = '*@(.sh|.inc|.bash|.command)',
    },
  },
  single_file_support = true,
})
--------------------------------------------
-- Docker LSP
lspconfig.dockerls.setup({
  on_attach = on_attach,
  cmd = { 'docker-langserver', '--stdio' },
  filetypes = { 'dockerfile' },
  root_dir = util.root_pattern('Dockerfile'),
  single_file_support = true,
})

lspconfig.docker_compose_language_service.setup({
  on_attach = on_attach,
  cmd = { 'docker-compose-langserver', '--stdio' },
  filetypes = { 'yaml' },
  root_dir = util.root_pattern('docker-compose.yaml'),
  single_file_support = true,
})
--------------------------------------------
