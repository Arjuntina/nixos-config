{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
	options = {
		starship.enable = lib.mkEnableOption "enables starship";
	};


	config = lib.mkIf config.starship.enable {
        programs.starship = {
            enable = true;
            enableZshIntegration = true;
            settings = builtins.fromTOML (builtins.readFile ./starshipConfig.toml);
        };
	};

}


