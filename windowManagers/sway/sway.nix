{config, pkgs, lib, ...}:

{
	# Some options to alter/toggle the config with nix declaration
	options = {
		sway.enable = lib.mkEnableOption "enables sway";
	};


	config = lib.mkIf config.sway.enable {
		wayland.windowManager.sway = {
			enable = true;
			config = rec {
				terminal = "alacritty";
				startup = [
					{command = "firefox";}
				];
			};
		};
	};

}
