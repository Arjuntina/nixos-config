{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
	options = {
		retroarch.enable = lib.mkEnableOption "enable Retroarch with selected cores";
	};


	config = lib.mkIf config.retroarch.enable {
        home.packages = [ 
            (pkgs.retroarch.withCores
                (cores: with cores; [
                    # NES
                    mesen
                    # SNES
                    bsnes
                    # N64
                    mupen64plus
                    # DS
                    melonds
                ])
            )
        ];
	};

}
