local M = {}

local parser = require('core.api.utils.golang.parser')
local commands = require('core.api.commands.system')
local extensions = require('core.api.extensions')
--------------------------------------------
-- Golang Tools Variables
M.urls = {
  gopls = 'golang.org/x/tools/gopls',
  gomodifytags = 'github.com/fatih/gomodifytags',
  gotests = 'github.com/cweill/gotests/...',
  impl = 'github.com/josharian/impl',
  iferr = 'github.com/koron/iferr',
}
--------------------------------------------
-- Golang Impl support
function M.impl(fargs)
  local Job = require('plenary.job')

  local receiver_name, receiver, interface =  '', '', ''
  if #fargs == 0 then
    commands.make_notify_message('Example: `GoImpl f *File io.Reader`', 'Usage', 'info')
    return
  elseif #fargs == 1 then
    local args = extensions.split(fargs[1])
    if #args ~= 3 then
      commands.make_notify_message('Example: `GoImpl f *File io.Reader`', 'Usage', 'info')
      return
    elseif #args == 3 then
      receiver_name = args[1]
      receiver = args[2]
      interface = args[3]
      receiver = string.format('%s %s', receiver_name, receiver)
    end
  end
  local cmd_args = {
    '-dir', vim.fn.fnameescape(vim.fn.expand '%:p:h'),
    receiver,
    interface,
  }

  local res_data
  Job:new({
    command = 'impl',
    args = cmd_args,
    on_exit = function(data, retval)
      if retval ~= 0 then
        commands.make_notify_message('Command `impl` FAILED with code ' .. retval, 'impl', 'error')
        return
      end
      res_data = data:result()
    end,
  }):sync()

  local pos = vim.fn.getcurpos()[2]
  table.insert(res_data, 1, '')
  vim.fn.append(pos, res_data)
end
--------------------------------------------
-- Golang If-Err support
function M.ifErr()
  local buffer = vim.fn.wordcount().cursor_bytes
  local cmd = ('iferr' .. ' -pos ' .. buffer)
  local data  = vim.fn.systemlist(cmd, vim.fn.bufnr('%'))

  if vim.v.shell_error ~= 0 then
    commands.make_notify_message('Command `iferr` FAILED with code ' .. vim.v.shell_error, 'iferr', 'error')
    return
  end

  local pos  = vim.fn.getcurpos()[2]
  vim.fn.append(pos, data)
  vim.cmd[[silent normal! j=2j]]
  vim.fn.setpos('.', pos)
end
--------------------------------------------
-- Golang Tests support
local function run_test(cmd_args)
  local Job = require('plenary.job')
  Job:new({
    command = 'gotests',
    args = cmd_args,
    on_exit = function(_, retval)
      if retval ~= 0 then
        commands.make_notify_message('Command `gotests` FAILED with code ' .. retval, 'gotests', 'error')
        return
      end
      commands.make_notify_message('Unit test(s) generation SUCCEDED', 'gotests', 'info')
    end,
  }):start()
end

local function create_test(cmd_args)
  local fpath = vim.fn.expand('%')
  table.insert(cmd_args, '-w')
  table.insert(cmd_args, fpath)
  run_test(cmd_args)
end

function M.one_function_test(is_parallel)
  local nodes = parser.get_func_at_cursor_position(unpack(vim.api.nvim_win_get_cursor(0)))
  if nodes == nil or nodes.name == nil then
    commands.make_notify_message('Put cursor on func/method and execute the command again', 'gotests', 'info')
    return
  end

  local cmd_args = {
    '-only', nodes.name
  }
  if is_parallel then
    table.insert(cmd_args, '-parallel')
  end

  create_test(cmd_args)
end

function M.all_functions_tests(is_parallel)
  local cmd_args = { '-all' }
  if is_parallel then
    table.insert(cmd_args, '-parallel')
  end

  create_test(cmd_args)
end

function M.all_exported_functions_tests(is_parallel)
  local cmd_args = { '-exported' }
  if is_parallel then
    table.insert(cmd_args, '-parallel')
  end

  create_test(cmd_args)
end
--------------------------------------------
-- Golang Tags support
local function modify_tags(operation, type)
  local Job = require('plenary.job')
  local file_path = vim.fn.expand('%')
  local nodes = parser.get_struct_at_cursor_position(unpack(vim.api.nvim_win_get_cursor(0)))
  if nodes == nil then
    return
  end
  local cmd_args = {
    '-format', 'json',
    '-file', file_path,
    '-w'
  }
  if nodes.name == nil then
    local _, csrow, _, _ = unpack(vim.fn.getpos('.'))
    table.insert(cmd_args, '-line')
    table.insert(cmd_args, csrow)
  else
    table.insert(cmd_args, '-struct')
    table.insert(cmd_args, nodes.name)
  end

  if operation == 'add' then
    table.insert(cmd_args, '-add-tags')
    table.insert(cmd_args, type)
  elseif operation == 'remove' then
    table.insert(cmd_args, '-remove-tags')
    table.insert(cmd_args, type)
  elseif operation == 'clear' then
    table.insert(cmd_args, '-clear-tags')
  end

  print(unpack(cmd_args))
  local res_data
  Job:new({
    command = 'gomodifytags',
    args = cmd_args,
    on_exit = function(data, retval)
      if retval ~= 0 then
        commands.make_notify_message('Command `gomodifytags` FAILED with code ' .. retval, 'gomodifytags', 'error')
        return
      end
      res_data = data:result()
    end,
  }):sync()

  local tagged = vim.json.decode(table.concat(res_data))
  if tagged.errors ~= nil or tagged.lines == nil or tagged['start'] == nil or tagged['start'] == 0 then
    commands.make_notify_message('Failed to set tags ' .. vim.inspect(tagged), 'gomodifytags', 'error')
  end

  for index, value in ipairs(tagged.lines) do
    tagged.lines[index] = extensions.rtrim(value)
  end

  vim.api.nvim_buf_set_lines(0, tagged.start - 1, tagged.start - 1 + #tagged.lines, false, tagged.lines)
  vim.cmd('write')
end

function M.tags_add(type)
  modify_tags('add', type)
end

function M.tags_rm(type)
  modify_tags('remove', type)
end

function M.tags_clear()
  modify_tags('clear', type)
end
--------------------------------------------
-- Golang Mod support
function M.create_module(name)
  local Job = require('plenary.job')
  Job:new({
    command = 'go',
    args = { 'mod', 'init', name },
    on_exit = function(_, retval)
      if retval ~= 0 then
        commands.make_notify_message('Initializing go module `' .. name .. '` FAILED with code ' .. retval, 'Module', 'error')
        return
      end
      commands.make_notify_message('Initializing go module `' .. name .. '` SUCCEDED', 'Module', 'info')
    end,
  }):start()
end

function M.tidy_module()
  local Job = require('plenary.job')
  Job:new({
    command = 'go',
    args = { 'mod', 'tidy' },
    on_exit = function(_, retval)
      if retval ~= 0 then
        commands.make_notify_message('Tidy go module FAILED with code ' .. retval, 'Module', 'error')
        return
      end
      commands.make_notify_message('Tidy go module SUCCEDED', 'Module', 'info')
    end,
  }):start()
end
--------------------------------------------
-- Golang DevTools installation script
function M.install_tools()
  for pkg, _ in pairs(M.urls) do
    local Job = require('plenary.job') -- For Async work
    local url = M.urls[pkg] .. '@latest'
    Job:new({
      command = 'go',
      args = { 'install', url },
      on_exit = function(_, retval)
        if retval ~= 0 then
          commands.make_notify_message('Installing ' .. url .. ' FAILED with code ' .. retval, 'Install DevTools', 'error')
          return
        end
        commands.make_notify_message('Installing ' .. url .. ' SUCCEDED', 'Install DevTools', 'info')
      end,
    }):start()
  end
end
--------------------------------------------
return M
