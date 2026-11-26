require 'keymaps'
require 'settings'
require 'plugins'
require 'snippets'

if vim.g.neovide then
  require 'neovide'
end

vim.lsp.enable({
  'clangd',
  'gopls',
  'lua_ls',
  'ruff',
  'rust_analyzer',
  'ty',
  'zls',
})
