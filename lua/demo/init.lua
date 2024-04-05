local Utils = require("demo.utils")

--@class Demo
local M = {}

M.setup = function(opts)
  require("demo.config").setup(opts)
  print("LOG: require(\"demo\").setup({})")
end

M.create = function()
  local buf_id = vim.api.nvim_create_buf(false, true)
  local opts = {
        relative = "editor",
        width = 80,
        height = 20,
        row = 10,
        col = 10,
        border = "rounded",
        style = "minimal"
    }

  local win_id = vim.api.nvim_open_win(buf_id, false, opts)
  return win_id
end

M.shit = function()
  print("shit function")
end

return M
