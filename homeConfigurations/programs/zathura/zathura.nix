{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
	options = {
		zathura.enable = lib.mkEnableOption "enables zathura";
	};


	config = lib.mkIf config.zathura.enable {
		# Zathura config!
		programs.zathura = {
			
			enable = true;

			extraConfig = builtins.readFile ./zathurarc;

		};
	};

}
