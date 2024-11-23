{config, pkgs, lib, ...}:

{
	imports = [
		./neovim/neovimConfig.nix
		./alacritty/alacrittyConfig.nix
	];

	# Enable/disable programs & some options through custom wrappers
	# The options here should be "high level" ones that encompass many changes and be ones I want to change frequently

	neovim = {
		enable = true;

		# Custom option which declares the colorscheme of neovim so that I don't have to go digging around the configuration files
		# Options = catppuccin & tokyonight
		colorscheme = "catppuccin";
	};

	alacritty = {
		enable = true;
	};

	# CLEAN THIS UP!
	# hyprland stuff! 
	wayland.windowManager.hyprland = {
		enable = false;
	};

}