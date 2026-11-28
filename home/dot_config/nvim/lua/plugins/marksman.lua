local marksman = "/etc/nvim/marksman"
if vim.fn.executable(marksman) ~= 1 then
  return {}
end

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      marksman = {
        mason = false,
        cmd = { marksman, "server" },
      },
    },
  },
}
