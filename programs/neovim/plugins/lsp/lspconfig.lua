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

vim.keymap.set('n', '<leader>lh', vim.lsp.buf.hover, {desc = "see the definition of various code statements"})

