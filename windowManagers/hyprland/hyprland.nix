
{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
	options = {
		hyprland.enable = lib.mkEnableOption "enables i3";
	};

	config = lib.mkIf config.hyprland.enable {
        wayland.windowManager.hyprland = {
            enable = true;
            
            extraConfig = builtins.readFile ./hyprland.conf;
        };
	};

}
