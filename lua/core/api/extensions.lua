local M = {}

function M.rtrim(value)
  local len = #value
  while len > 0 and value:find('^%s', len) do
    len = len - 1
  end

  return value:sub(1, len)
end

function M.split(value)
  local result = {}
  for match in string.gmatch(value, '%S+') do
    table.insert(result, match)
  end
  return result
end

return M
