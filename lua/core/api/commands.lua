--------------------------------------------
-- Golang commands
vim.api.nvim_create_user_command('GoInstallDeps', function()
  require('core.api.utils.golang.devtools').install_tools()
end, {})

vim.api.nvim_create_user_command('GoModInit', function(opts)
  require('core.api.utils.golang.devtools').create_module(opts.fargs[1])
end, { nargs = 1 })

vim.api.nvim_create_user_command('GoModTidy', function()
  require('core.api.utils.golang.devtools').tidy_module()
end, {})

vim.api.nvim_create_user_command('GoTagsAdd', function(opts)
  require('core.api.utils.golang.devtools').tags_add(opts.fargs[1])
end, { nargs = 1 })

vim.api.nvim_create_user_command('GoTagsRm', function(opts)
  require('core.api.utils.golang.devtools').tags_rm(opts.fargs[1])
end, { nargs = 1 })

vim.api.nvim_create_user_command('GoTagsClr', function()
  require('core.api.utils.golang.devtools').tags_clear()
end, {})

vim.api.nvim_create_user_command('GoTestAdd', function(opts)
  require('core.api.utils.golang.devtools').one_function_test(opts.fargs[1])
end, { nargs = 1 })

vim.api.nvim_create_user_command('GoTestsAll', function(opts)
  require('core.api.utils.golang.devtools').all_functions_tests(opts.fargs[1])
end, { nargs = 1 })

vim.api.nvim_create_user_command('GoTestsExp', function(opts)
  require('core.api.utils.golang.devtools').all_exported_functions_tests(opts.fargs[1])
end, { nargs = 1 })
--------------------------------------------
