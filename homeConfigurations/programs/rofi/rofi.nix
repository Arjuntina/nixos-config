{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
	options = {
		rofi.enable = lib.mkEnableOption "enables rofi";
	};


	config = lib.mkIf config.rofi.enable {
		# Rofi config!
		programs.rofi = {

			enable = true;

		};
	};

}
