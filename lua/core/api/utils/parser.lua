local M = {}

local function check_intersects(row, col, sRow, sCol, eRow, eCol)
  if sRow > row or eRow < row then
    return false
  end

  if sRow == row and sCol > col then
    return false
  end

  if eRow == row and eCol < col then
    return false
  end

  return true
end

function M.intersect_nodes(nodes, row, col)
  local found = {}
  for index = 1, #nodes do
    local node = nodes[index]
    local sRow = node.dim.s.r
    local sCol = node.dim.s.c
    local eRow = node.dim.e.r
    local eCol = node.dim.e.c

    if check_intersects(row, col, sRow, sCol, eRow, eCol) then
      table.insert(found, node)
    end
  end
  return found
end

function M.sort_nodes(nodes)
  table.sort(nodes, function(a, b)
    return M.count_parents(a) < M.count_parents(b)
  end)

  return nodes
end

function M.get_all_nodes(query, lang, bufnr, cursor_position)
  local results = {}

  local treesitter_query = require('nvim-treesitter.query')
  local treesitter_parsers = require('nvim-treesitter.parsers')
  local treesitter_locals = require('nvim-treesitter.locals')

  bufnr = bufnr or 0
  cursor_position = cursor_position or 30000

  local ok, parsed_query = pcall(function()
    return vim.treesitter.query.parse(lang, query)
  end)

  if not ok then
    return nil
  end

  ------------------------------------------
  -- Main Algo
  local parser = treesitter_parsers.get_parser(bufnr, lang)
  local root = parser:parse()[1]:root()
  local start_row, _, end_row, _ = root:range()

  for match in treesitter_query.iter_prepared_matches(parsed_query, root, bufnr, start_row, end_row) do
    local sRow, sCol, eRow, eCol
    local declarationNode
    local type, name, operator = '', '', ''
    treesitter_locals.recurse_local_nodes(match, function(_, node, path)
      local index = string.find(path, '.[^.]*$')
      operator = string.sub(path, index + 1, #path)
      type = string.sub(path, 1, index - 1)

      if operator == 'name' then
        name = vim.treesitter.get_node_text(node, bufnr)
      elseif operator == 'declaration' or operator == 'clause' then
        declarationNode = node
        sRow, sCol, eRow, eCol = node:range()
        sRow = sRow + 1
        eRow = eRow + 1
        sCol = sCol + 1
        eCol = eCol + 1
      end
    end)

    if declarationNode ~= nil then
      table.insert(results, {
        declarationNode = declarationNode,
        dim = {
          s = { r = sRow, c = sCol },
          e = { r = eRow, c = eCol },
        },
        name = name,
        operator = operator,
        type = type,
      })
    end
  end
  ------------------------------------------

  return results
end

function M.nodes_at_cursor(query, bufnr, row, col)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filetype = vim.api.nvim_buf_get_option(bufnr, 'ft')
  local nodes = M.get_all_nodes(query, filetype, bufnr, row)
  if nodes == nil then
    vim.notify('Unable to find any nodes', 'debug')
    return nil
  end

  nodes = M.intersect_nodes(nodes, row, col)
  if nodes == nil or #nodes == 0 then
    vim.notify('Unable to find any nodes at cursor position. ' .. tostring(row) .. ':' .. tostring(col), 'debug')
    return nil
  end

  return nodes
end

return M
