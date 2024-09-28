-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)


-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {{"williamboman/mason.nvim", 'williamboman/mason-lspconfig.nvim', 'neovim/nvim-lspconfig'}},
  -- automatically check for plugin updates
  checker = { enabled = true },
})

require("mason").setup({ui = {icons = {package_installed = "✓", package_pending = "➜", package_uninstalled = "✗"}}})
-- This function will be executed when a buffer is created
local function on_attach(_, _)
  -- Add your mason-lspconfig.setup() or other code here
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
  vim.keymap.set('n', '#', vim.lsp.buf.definition, {})
  print('##')
end

-- This autocommand will execute the setup_mason_lspconfig function when a new buffer is created
--vim.api.nvim_create_autocmd("BufNewFile,BufRead", {
  --pattern = "*",
  --callback = setup_mason_lspconfig,
--})
local mason_lspconfig = require('mason-lspconfig')

-- Function to run for each installed server
local function setup_server(server_name)
  print("Setting up server: " .. server_name)
  local opts = {on_attach = on_attach} -- add your server-specific options here, if any
  require'lspconfig'[server_name].setup(opts)
end

-- Run the setup function for each server
for _, server in ipairs(mason_lspconfig.get_installed_servers()) do setup_server(server) end
