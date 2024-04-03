# Demo Plugin

demo repo for developing neovim plugin

---

## Useful Neovim Tips

```neovim
:luafile ~/path/to/lua/file
:source
:runtime
```


```lua
--[[
vim.inspect
vim.regex
vim.api
vim.ui
vim.loop
vim.lsp
vim.treesitter
--]]

function _G.put(...)
  local obj = {}
  for i = 1, select("#", ...) do
    local v = select(i, ...)
    table.insert(obj, vim.inspect(v))
  end
  print(table.concat(obj, "\n")
  return ...
end

vim.api.nvim_command("new") -- vim.cmd()
vim.api.nvim_replace_termcodes()
vim.api.nvim_set_option()
vim.api.nvim_get_option()
vim.api.nvim_buf_set_option()
vim.api.nvim_buf_get_option()
vim.api.nvim_win_set_option()
vim.api.nvim_win_get_option()

-- vim.fn
-- vim.keymap.set()
-- vim.keymap.del()

vim.api.nvim_create_user_command()
vim.api.nvim_del_user_command()
vim.api.nvim_buf_create_user_command()
vim.api.nvim_buf_del_user_command()
```


