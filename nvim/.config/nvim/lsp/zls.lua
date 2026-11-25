---@type vim.lsp.Config
return {
  cmd = { 'zls' },
  filetypes = { 'zig', 'zon' },
  root_markers = { 'build.zig', 'build.zig.zon', '.git' },
}
