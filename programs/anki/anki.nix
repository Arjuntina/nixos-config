{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
	options = {
		anki.enable = lib.mkEnableOption "enables anki";
	};


	config = lib.mkIf config.anki.enable {
         # Add anki to the home.packages list
        home.packages = [ pkgs.anki ];

        # Set ANKI_WAYLAND=1 (as disabled by default)
        home.sessionVariables.ANKI_WAYLAND = "1";
	};

}
