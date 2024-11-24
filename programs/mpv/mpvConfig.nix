{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
	options = {
		mpv.enable = lib.mkEnableOption "enables mpv";
	};


	config = lib.mkIf config.mpv.enable {
		# Mpv config!
		programs.mpv = {
			
			enable = true;

		};
	};

}
