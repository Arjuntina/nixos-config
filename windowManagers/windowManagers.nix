{config, pkgs, lib, ...}:

{
	imports = [
		./sway/sway.nix
		./i3/i3.nix
        ./hyprland/hyprland.nix
	];

	# Enable/disable window managers through high level configuration options here
	config.i3.enable = false;
    config.sway.enable = false;
    config.hyprland.enable = true;


}
