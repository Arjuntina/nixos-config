{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
	options = {
		yt-dlp.enable = lib.mkEnableOption "enables yt-dlp";
	};


	config = lib.mkIf config.yt-dlp.enable {
        # yt-dlp config!
        programs.yt-dlp = {
            enable = true;

            extraConfig = ''
                --max-filesize 10G  # Hopefully this is reasonable? I can always adjust later hm hm
                --write-subs
                --write-auto-subs
                --sub-langs "en*"
            '';
        };
	};
}
