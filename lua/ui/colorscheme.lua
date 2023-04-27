function SetColorscheme(color)
  color = color or "vscode"
  vim.cmd.colorscheme(color)
end

SetColorscheme()
