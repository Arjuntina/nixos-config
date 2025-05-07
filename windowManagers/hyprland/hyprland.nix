
{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
	options = {
		hyprland.enable = lib.mkEnableOption "enables hyprland";
	};

	config = lib.mkIf config.hyprland.enable {
        wayland.windowManager.hyprland = {
            # Set to true but is also set to true in configuration.nix! -- Look into what should be done! (Does this install it again?)
            enable = true;
            
            extraConfig = builtins.readFile ./hyprland.conf;
        };
	};

}
