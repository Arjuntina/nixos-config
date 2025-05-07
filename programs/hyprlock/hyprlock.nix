{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
    # NOT USING THIS TOGGLE because I would rather link this toggle to the hyprland toggle!
	# options = {
	# 	hyprlock.enable = lib.mkEnableOption "enables hyprlock";
	# };

    # Only enable this module when hyprland is enabled
	config = lib.mkIf config.hyprland.enable {

        # hyprlock config!
        programs.hyprlock = {

            enable = true;

            extraConfig = builtins.readFile ./hyprlockConfig.conf;

        };
	};
}


