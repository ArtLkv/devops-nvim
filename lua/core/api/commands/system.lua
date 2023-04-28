local M = {}

function M.make_notify_message(msg, title, lvl)
  vim.notify(msg, lvl, {
    title = title,
  })
end

return M
