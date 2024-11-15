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
				# Here are some functions that allow configuration strings/files below to be converted into Lua
				# It makes the rest of the config cleaner
				toLua = str: "lua << EOF\n${str}\nEOF\n";	
				toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";	
			
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
				{
					plugin = catppuccin-nvim;
					config = toLuaFile ./plugins/catppuccin.lua;
				}
			];
		};
	};

}
