require('bufferline').setup({
  options = {
    diagnostics_indicator = function(count, level, _, _) -- count, level, diagnostics_dict, context
      local icon = level:match('error') and " " or " "
      return " " .. icon .. count
    end,
  },
})
