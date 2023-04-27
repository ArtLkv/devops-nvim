# DevOps NeoVim - How to add the custom commands

If you want to add the custom command, you should use the three files:
1. [commands.lua](../lua/core/api/commands.lua)
2. [extensions.lua](../lua/core/api/extensions.lua)
3. [registry.lua](../lua/core/api/registry.lua)

You should use `commands.lua`, if you want to registry NeoVim API command. You should use vim.api.nvim_create_user_command with the three arguments.
1. Command name.
2. Function, which should call, when you start this command. opts.fargs it's table with function arguments, opts.fargs[0] it's command name.
First argument it's opts.fargs[1]
3. { nargs="?" } . Count of arguments(1, 2, 3 and etc) or "?" if you don't know the count of arguments.

You should use `extensions.lua`, if you want to add functions, which will use in multiple files.

You should use `registry.lua`, if you want redefine default NeoVim variables, functions.
