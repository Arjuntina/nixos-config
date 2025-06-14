require("mason").setup { ui = { border = "rounded" } }
require("mason-lspconfig").setup {
	automatic_installation = false,
}

local lspconfig = require('lspconfig')

-- local capabilities = require("cmp_nvim_lsp").default_capabilities()     -- this apparently ensures that the LSP suggestions are included in the autocomplete box? I think? -- will set up later (one day)

-- for Lua
vim.lsp.config('lua_ls', {
    settings = {
		Lua = { -- apply the settings below for Lua documents
			diagnostics = {
				globals = { "vim" } -- tells the language server that "vim" is a global variable, which stops the server from yelling at you when running "vim.g...." commands
			}
		}
    },
})
-- for C
vim.lsp.enable('clangd')
-- for python
vim.lsp.enable('pyright')
-- for nix
vim.lsp.enable('nixd')
-- for java
vim.lsp.enable('jdtls')

vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, {desc = "hover"})
vim.keymap.set('n', '<leader>ld', vim.lsp.buf.hover, {desc = "go to definition"})
vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, {desc = "code actions"})


-- LAZY-LSP (which I have not configured)
-- local lsp_zero = require("lsp-zero")
-- 
-- lsp_zero.on_attach(function(client, bufnr)
-- 	-- see :help lsp-zero-keybindings to learn the available actions
-- 	lsp_zero.default_keymaps({
-- 		buffer = bufnr,
-- 		preserve_mappings = false
-- 	})
-- end)
-- 
-- require('lazy-lsp').setup {
-- 	excluded_servers = {},
-- 	preferred_servers = {},
-- 	prefer_local = true, -- I think???? This prefers locally installed servers over nix-shell
-- 	-- A default config passed to all servers to specify on_attach callback & other options
-- 	-- I don't really understand, so will just leave it as the default value
-- 	default_config = {
-- 		flags = {
-- 			debounce_text_changes = 150,
-- 		},
-- 		-- on_attach = on_attach,
-- 		-- capabilities = capabilities,
-- 	},
-- 	-- Can put specific server overrides below, but tbh just want to get it to work rn
-- }
