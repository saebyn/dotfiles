local preview_dir = "/etc/nvim/markdown-preview"
if vim.fn.isdirectory(preview_dir) ~= 1 then
  return {}
end

return {
  "iamcco/markdown-preview.nvim",
  optional = true,
  dir = preview_dir,
  build = false, -- Nixpkgs bundles the Node dependencies instead of downloading a prebuilt binary.
}
