{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
	options = {
		neovim.enable = lib.mkEnableOption "enables neovim";
	};


	config = lib.mkIf config.neovim.enable {
		# Neovim config!
		programs.neovim = 
			let 
				# This function works for my other installed plugins
				convertLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";	
			
			in {
			# Install neovim to the system & make it the default editor
			enable = true;
			defaultEditor = true;

			# Make the commands `vi`, `vim`, and `vimdiff` automatically launch neovim
			viAlias = true;
			vimAlias = true;	
			vimdiffAlias = true;


			# Define the plugins to install & use on the system
			plugins = with pkgs.vimPlugins; [
				# LSP Setup
				# LSPconfig
				{
					plugin = nvim-lspconfig;
					config = convertLuaFile ./plugins/lspconfig.lua;
				}
			];

			extraPackages = with pkgs; [
				nil #Nix
				lua-language-server #Lua
				pyright #Python
			];
		};
	};

}
