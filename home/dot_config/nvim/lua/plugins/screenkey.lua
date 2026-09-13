return {
  "NStefan002/screenkey.nvim",
  lazy = false,
  version = "*", -- or branch = "main", to use the latest commit
  config = function(_, opts)
    local screenkey = require("screenkey")
    screenkey.setup(opts)

    if vim.uv.fs_stat(vim.fn.expand("~/.stream-mode")) and not screenkey.is_active() then
      screenkey.toggle()
    end
  end,
}
