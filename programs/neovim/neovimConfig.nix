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
				${builtins.readFile ./lsp.lua}
				${builtins.readFile ./completions.lua}
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
								(convertLuaFile ./plugins/colorscheme/catppuccin.lua)
								(convertLua "vim.cmd.colorscheme \"catppuccin\"")
							]
						else 
							(convertLuaFile ./plugins/colorscheme/catppuccin.lua)
					);
				}
				{
					plugin = tokyonight-nvim;
					config = (if  config.neovim.colorscheme == "tokyonight"
						then
							lib.strings.concatStrings [
								(convertLuaFile ./plugins/colorscheme/tokyonight.lua)
								(convertLua "vim.cmd.colorscheme \"tokyonight\"")
							]
						else 
							(convertLuaFile ./plugins/colorscheme/tokyonight.lua)
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

				# LSP Stuff
                # all configuration defined in the ./lsp.lua file
				# Mason -- a LSP Installation client that doesn't work on nix, but is installed here so that the other plugins don't break
				mason-nvim
				# Mason-lspconfig -- program that sets the aliases for the language servers properly
				mason-lspconfig-nvim
				# LSPconfig -- main program that sets up and configures language servers for neovim
			    nvim-lspconfig
				# Lazy-LSP -- a lsp client built for nix in mind, but I could not figure out how to set it up properly

				# Autocompletion
				# Since there's so many plugins with mixed functionality, all the configuration will be located in ./completions.lua
				# Cmp -- main autocompletion engine which displays the completion box and all that jazz
				nvim-cmp
				# cmp_luasnip -- provides nvim-cmp with snippet translations from luasnip (below) & friendly snippets (below)
				cmp_luasnip
				# luasnip - a snippet expansion tool
				luasnip
				# Friendly snippets -- snippet collections from various programming languages (& VSCode?)
			    friendly-snippets
				# Cmp-nvim-lsp -- a completion source for nvim-cmp that offers completion from the installed language server
                # Configuration for this plugin is actually defined in ./lsp.lua because it has to be loaded into various language servers
				cmp-nvim-lsp

                # Latex stuff
                {
                    plugin = vimtex;
					config = convertLuaFile ./plugins/vimtex.lua;
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
