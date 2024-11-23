local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
	-- see :help lsp-zero-keybindings to learn the available actions
	lsp_zero.default_keymaps({
		buffer = bufnr,
		preserve_mappings = false
	})
end)

require('lazy-lsp').setup {
	excluded_servers = {},
	preferred_servers = {},
	prefer_local = true, -- I think???? This prefers locally installed servers over nix-shell
	-- A default config passed to all servers to specify on_attach callback & other options
	-- I don't really understand, so will just leave it as the default value
	default_config = {
		flags = {
			debounce_text_changes = 150,
		},
		-- on_attach = on_attach,
		-- capabilities = capabilities,
	},
	-- Can put specific server overrides below, but tbh just want to get it to work rn
}
