{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
	options = {
		wofi.enable = lib.mkEnableOption "enables wofi";
	};

	config = lib.mkIf config.wofi.enable {

		# Wofi config!
		programs.wofi = {

			enable = true;

            style = builtins.readFile ./style.css;

		};
	};

}
