{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
	options = {
		neovim.enable = lib.mkEnableOption "enables neovim";

		neovim.colorscheme = lib.mkOption {
			# name = "Custom Neovim colorscheme selector";
			type = lib.types.str;
			default = "catppuccin";
			example = "tokyonight";
			description = "What colorscheme to enable for neovim. Should not only change the UI colorscheme but also the colorscheme of the different packages";
		};
	};


	config = lib.mkIf config.neovim.enable {
		# Neovim config!
		programs.neovim = 
			let 
				# Here are some functions that allow configuration strings/files in Lua to be converted to Vimscript (because Nix only allows vimscript)
				# It makes the rest of the config cleaner
				convertLua = str: "lua << EOF\n${str}\nEOF\n";	
				convertLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";	
			
			in {
			# Install neovim to the system & make it the default editor
			enable = true;
			defaultEditor = true;

			# Make the commands `vi`, `vim`, and `vimdiff` automatically launch neovim
			viAlias = true;
			vimAlias = true;	
			vimdiffAlias = true;

			# Read in from the options.lua file so that this configuration file doesn't get too crowded
			extraLuaConfig = ''
				${builtins.readFile ./options.lua}
			'';

			# Define the plugins to install & use on the system
			plugins = with pkgs.vimPlugins; [
				# Colorscheme
				# The config statements here are a bit complex because they interface with the custom colorscheme wrapper
				{
					plugin = catppuccin-nvim;
					config = (if  config.neovim.colorscheme == "catppuccin"
						then
							lib.strings.concatStrings [
								(convertLuaFile ./plugins/catppuccin.lua)
								(convertLua "vim.cmd.colorscheme \"catppuccin\"")
							]
						else 
							(convertLuaFile ./plugins/catppuccin.lua)
					);
				}
				{
					plugin = tokyonight-nvim;
					config = (if  config.neovim.colorscheme == "tokyonight"
						then
							lib.strings.concatStrings [
								(convertLuaFile ./plugins/tokyonight.lua)
								(convertLua "vim.cmd.colorscheme \"tokyonight\"")
							]
						else 
							(convertLuaFile ./plugins/tokyonight.lua)
					);
				}

				# Telescope
				{
					plugin = telescope-nvim;
					config = convertLuaFile ./plugins/telescope.lua;
				}

				# Tree-sitter
				{
					plugin = (nvim-treesitter.withPlugins (p: [
						# Real programming languages
						p.tree-sitter-python
						p.tree-sitter-c
						p.tree-sitter-java
						p.tree-sitter-haskell
						# Niche programming languages
						p.tree-sitter-bash
						p.tree-sitter-r
						p.tree-sitter-latex
						# Configuration languages
						p.tree-sitter-html
						p.tree-sitter-css
						p.tree-sitter-nix
						p.tree-sitter-vim
						p.tree-sitter-lua
						p.tree-sitter-yaml
						p.tree-sitter-toml
					]));
					config = convertLuaFile ./plugins/treesitter.lua;
				}

				# Neotree
				{
					plugin = neo-tree-nvim;
					config = convertLuaFile ./plugins/neotree.lua;
				}
				# Devicons
				{
					plugin = nvim-web-devicons;
					config = convertLuaFile ./plugins/devicons.lua;
				}
				# Plenary
				{
					plugin = plenary-nvim;
					config = convertLuaFile ./plugins/plenary.lua;
				}

				# Lualine
				{
					plugin = lualine-nvim;
					config = convertLuaFile ./plugins/lualine.lua;
				}

				# indent-blankline-nvim - shows a small transparent line wherever I indent in a file
				{
					plugin = indent-blankline-nvim;
					config = convertLuaFile ./plugins/indentBlankline.lua;
				}

                # Whichkey
                # Let a neovim popup window remind me of my <leader> keybinds
                {
                    plugin = which-key-nvim;
                    # config = convertLuaFile ./plugins/whichKey.lua;
                }

				# LSP Setup
				# Mason just so that the other plugins don't break
				mason-nvim
				# Mason-lspconfig -- may set the aliases for language servers properly? idk
				{
					plugin = mason-lspconfig-nvim;
					config = convertLuaFile ./plugins/lsp/masonLsp.lua;
				}
				# LSPconfig -- am disabling the config bc it not working but leaving it here bc it might(?) be a dependency for lazy-lsp below
				{
					plugin = nvim-lspconfig;
					config = convertLuaFile ./plugins/lsp/lspconfig.lua;
				}
				# Lazy-LSP
				# Should use this and follow the documentation because it seems like it was built with Nix & Home-manager in mind!!!!
				# If used properly should be able to replace both masonLsp & nvim-lspconfig described above
				#{
				#	plugin = lazy-lsp-nvim;
				#	config = convertLuaFile ./plugins/lsp/lazyLsp.lua;
				#}
				# Other stuff
				# vim-nix - a plugin for nix highlighting/syntax
                		# Disabled because, although it sounds nice in theory, it messes up the indentation significantly
                		# vim-nix

				# Autocompletion
				#luasnip
				#cmp_luasnip
				# Cmp -- plugin for autocomplete
				{
				 	plugin = nvim-cmp;
				 	config = convertLuaFile ./plugins/cmp.lua;
				}
				{
					plugin = cmp-nvim-lsp;
				}


			];

			# Extra packages? Am using for lsp servers but might change as i don't really understand them rn
			extraPackages = with pkgs; [
				nil #Nix
				lua-language-server #Lua
				pyright #Python
				clang-tools #C
			];
		};
	};

}
