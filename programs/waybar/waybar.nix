{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
	options = {
		waybar.enable = lib.mkEnableOption "enables waybar";
	};


	config = lib.mkIf config.waybar.enable {

        # waybar config!
        programs.waybar = {

            enable = true;

            systemd.enable = false;

            # Not really sure why or how but the JSON file needs to be wrapped with a "mainBar" wrapper -- so that the name of the bar is known??? idk
            settings = {
                mainBar = builtins.fromJSON (builtins.readFile ./config1/config);
            };

            style = builtins.readFile ./config1/style.css;

        };
	};
}


