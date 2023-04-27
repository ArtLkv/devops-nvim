local parser = require('core.api.utils.parser')

local M = {}

M.querys = {
  struct_block = [[((type_declaration (type_spec name:(type_identifier) @struct.name type: (struct_type)))@struct.declaration)]],
  em_struct_block = [[(field_declaration name:(field_identifier)@struct.name type: (struct_type)) @struct.declaration]],
  package = [[(package_clause (package_identifier)@package.name)@package.clause]],
  interface = [[((type_declaration (type_spec name:(type_identifier) @interface.name type:(interface_type)))@interface.declaration)]],
  method_name = [[((method_declaration receiver: (parameter_list)@method.receiver name: (field_identifier)@method.name body:(block))@method.declaration)]],
  func = [[((function_declaration name: (identifier)@function.name) @function.declaration)]],
}

function M.get_struct_at_cursor_position(row, col)
  local query = M.querys.struct_block .. ' '  .. M.querys.em_struct_block
  local bufnr = vim.api.nvim_get_current_buf()
  local nodes = parser.nodes_at_cursor(query, bufnr, row, col)
  if nodes == nil then
    vim.notify('Struct not found', 'warn')
  else
    return nodes[#nodes]
  end
end

function M.get_func_at_cursor_position(row, col)
  local query = M.querys.func .. ' ' .. M.querys.method_name
  local bufnr = vim.api.nvim_get_current_buf()
  local nodes = parser.nodes_at_cursor(query, bufnr, row, col)
  if nodes == nil then
    vim.notify('Function not found', 'warn')
  else
    return nodes[#nodes]
  end
end

return M
