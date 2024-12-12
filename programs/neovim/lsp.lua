require("mason").setup { ui = { border = "rounded" } }
require("mason-lspconfig").setup {
	automatic_installation = false,
}
local lspconfig = require('lspconfig')

local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig.lua_ls.setup{ -- for Lua
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" } -- idk apparently this is supposed to be good?
			}
		}
	},
    capabilities = capabilities
}

lspconfig.clangd.setup{             -- for C
    capabilities = capabilities
}
lspconfig.pyright.setup{            -- for python
    capabilities = capabilities
}
lspconfig.nil_ls.setup{            -- for nix
}

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
