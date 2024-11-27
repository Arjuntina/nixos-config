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

            systemd.enable = true;

            # The code below is generated using the python script ./convert.py, which is nondeclarative!
            # However, I am using it because I have no idea how to otherwise pass in a file to this function
            # The input needs to be in the "(list of (JSON value)) or attribute set of (JSON value)" form, which does not make much sense :/
            # Figure it out someday :/
            settings = {};

            style = builtins.readFile ./style.css;

        };
	};
}


