local lspconfig = require('lspconfig')

-- lspconfig.nil.setup{}
lspconfig.lua_ls.setup{
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" }
			}
		}
	}
}
lspconfig.clangd.setup{}
lspconfig.pyright.setup{}
lspconfig.nil_ls.setup{}

-- vim.api.nvim_exec_autocmds("FileType", {})
