{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
	options = {
		tmux.enable = lib.mkEnableOption "enables tmux";
	};


	config = lib.mkIf config.tmux.enable {
		# Tmux config!
		programs.tmux = {
			
			enable = true;

		};
	};

}
