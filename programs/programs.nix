{config, pkgs, lib, ...}:

{
	imports = [
		./neovim/neovimConfig.nix
	];

	# Enable/disable programs
	neovim.enable = true;

	# hyprland stuff!
	wayland.windowManager.hyprland = {
		enable = false;
	};

}
