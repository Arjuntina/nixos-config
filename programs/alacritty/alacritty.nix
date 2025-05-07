{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
	options = {
		alacritty.enable = lib.mkEnableOption "enables alacritty";
	};


	config = lib.mkIf config.alacritty.enable {
		# Alacritty config!
		programs.alacritty = {
			
			enable = true;

			settings = builtins.fromTOML (builtins.readFile ./alacrittyConfig.toml);

		};
	};

}
