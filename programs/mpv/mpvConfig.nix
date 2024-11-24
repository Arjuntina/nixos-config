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

            config = {
                keep-open="always";  # prevent mpv from closing and from going to the next entry in a playlist automatically

                # For modernx UI
                osc="no";
                border="no";
            };

            scripts = with pkgs.mpvScripts; [
                thumbfast
                modernx
            ];

		};
	};

}
