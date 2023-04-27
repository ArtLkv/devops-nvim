local M = {}

function M.rtrim(value)
  local len = #value
  while len > 0 and value:find('^%s', len) do
    len = len - 1
  end

  return value:sub(1, len)
end

return M
