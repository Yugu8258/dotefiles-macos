require 'keymaps'
require 'settings'
require 'plugins'
require 'snippets'

vim.lsp.enable({
  'clangd',
  'gopls',
  'lua_ls',
  'ruff',
  'rust_analyzer',
  'ty',
  'zls',
})
