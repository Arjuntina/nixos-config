local lspconfig = require('lspconfig')

lspconfig.lua_ls.setup{ -- for Lua
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" } -- idk apparently this is supposed to be good?
			}
		}
	}
}
lspconfig.clangd.setup{} -- for C
lspconfig.pyright.setup{} -- for python
lspconfig.nil_ls.setup{} -- for nix

vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, {desc = "hover"})
vim.keymap.set('n', '<leader>ld', vim.lsp.buf.hover, {desc = "go to definition"})
vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, {desc = "code actions"})

